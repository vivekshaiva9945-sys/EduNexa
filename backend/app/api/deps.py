from typing import AsyncGenerator, List, Optional
from uuid import UUID
from fastapi import Depends, Header, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.exceptions import (
    AuthenticationException,
    PermissionDeniedException,
    TenantMismatchException,
)
from app.core.security import decode_access_token
from app.db.session import AsyncSessionLocal, set_tenant_context
from app.models.user import User

security_bearer = HTTPBearer(auto_error=False)


async def get_db_session() -> AsyncGenerator[AsyncSession, None]:
    """Base database session dependency."""
    async with AsyncSessionLocal() as session:
        try:
            yield session
        finally:
            await session.close()


async def get_current_user(
    auth: Optional[HTTPAuthorizationCredentials] = Depends(security_bearer),
    db: AsyncSession = Depends(get_db_session),
) -> User:
    """Validate Bearer JWT and return active user object with tenant preloaded."""
    if not auth or not auth.credentials:
        raise AuthenticationException("Authorization Bearer token is required")

    payload = decode_access_token(auth.credentials)
    if not payload:
        raise AuthenticationException("Invalid or expired authentication token")

    user_id_str = payload.get("sub")
    if not user_id_str:
        raise AuthenticationException("Malformed token claims")

    try:
        user_uuid = UUID(user_id_str)
    except ValueError:
        raise AuthenticationException("Malformed user identifier in token")

    query = (
        select(User)
        .options(
            selectinload(User.college),
            selectinload(User.admin_profile),
            selectinload(User.faculty_profile),
            selectinload(User.student_profile),
        )
        .where(User.user_id == user_uuid, User.is_active == True)
    )
    result = await db.execute(query)
    user = result.scalar_one_or_none()

    if not user:
        raise AuthenticationException("User account not found or deactivated")

    # Set PostgreSQL RLS tenant context
    await set_tenant_context(db, user.college_id)
    return user


class RequireRole:
    """Dependency for enforcing Role-Based Access Control (RBAC)."""

    def __init__(self, allowed_roles: List[str]):
        self.allowed_roles = allowed_roles

    def __call__(self, current_user: User = Depends(get_current_user)) -> User:
        if current_user.role not in self.allowed_roles:
            raise PermissionDeniedException(
                f"Role '{current_user.role}' is not authorized. Required: {', '.join(self.allowed_roles)}"
            )
        return current_user


async def get_tenant_session(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db_session),
    x_tenant_id: Optional[str] = Header(None, alias="X-Tenant-ID"),
) -> AsyncSession:
    """
    Enforces multi-tenant boundary. If X-Tenant-ID header is present,
    it must strictly match the authenticated user's assigned college_id.
    """
    if x_tenant_id:
        try:
            header_uuid = UUID(x_tenant_id)
            if header_uuid != current_user.college_id:
                raise TenantMismatchException("X-Tenant-ID header does not match authenticated tenant")
        except ValueError:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Malformed X-Tenant-ID UUID header",
            )

    await set_tenant_context(db, current_user.college_id)
    return db
