from typing import Any, Dict, Optional, Tuple
from uuid import UUID
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.exceptions import AuthenticationException
from app.core.security import (
    create_access_token,
    create_refresh_token,
    decode_access_token,
    verify_password,
)
from app.models.college import College
from app.models.user import User


class AuthService:
    @staticmethod
    async def authenticate_user(
        db: AsyncSession,
        email: str,
        password: str,
        college_id: Optional[UUID] = None,
    ) -> Tuple[User, str, str]:
        """Authenticate user credentials and issue access + refresh JWTs."""
        stmt = (
            select(User)
            .options(
                selectinload(User.college),
                selectinload(User.admin_profile),
                selectinload(User.faculty_profile),
                selectinload(User.student_profile),
            )
            .where(User.email == email.lower().strip())
        )
        if college_id:
            stmt = stmt.where(User.college_id == college_id)

        result = await db.execute(stmt)
        user = result.scalar_one_or_none()

        if not user:
            raise AuthenticationException("Invalid email or password")

        if not user.is_active:
            raise AuthenticationException("User account has been deactivated")

        if not verify_password(password, user.password_hash):
            raise AuthenticationException("Invalid email or password")

        profile_id = AuthService.extract_profile_id(user)

        claims = {
            "sub": str(user.user_id),
            "college_id": str(user.college_id),
            "role": user.role,
            "profile_id": str(profile_id) if profile_id else None,
        }

        access_token = create_access_token(claims)
        refresh_token = create_refresh_token(claims)
        return user, access_token, refresh_token

    @staticmethod
    def extract_profile_id(user: User) -> Optional[UUID]:
        """Extract role-specific profile ID (admin_id, faculty_id, student_id)."""
        if user.role == "ADMIN" and user.admin_profile:
            return user.admin_profile.admin_id
        elif user.role == "FACULTY" and user.faculty_profile:
            return user.faculty_profile.faculty_id
        elif user.role == "STUDENT" and user.student_profile:
            return user.student_profile.student_id
        return None

    @staticmethod
    def build_profile_dict(user: User) -> Dict[str, Any]:
        """Construct a standardized dictionary representation of role profiles."""
        if user.role == "ADMIN" and user.admin_profile:
            return {
                "admin_id": str(user.admin_profile.admin_id),
                "first_name": user.admin_profile.first_name,
                "last_name": user.admin_profile.last_name,
                "phone": user.admin_profile.phone,
            }
        elif user.role == "FACULTY" and user.faculty_profile:
            return {
                "faculty_id": str(user.faculty_profile.faculty_id),
                "employee_code": user.faculty_profile.employee_code,
                "first_name": user.faculty_profile.first_name,
                "last_name": user.faculty_profile.last_name,
                "department": user.faculty_profile.department,
                "designation": user.faculty_profile.designation,
            }
        elif user.role == "STUDENT" and user.student_profile:
            return {
                "student_id": str(user.student_profile.student_id),
                "roll_number": user.student_profile.roll_number,
                "first_name": user.student_profile.first_name,
                "last_name": user.student_profile.last_name,
                "enrollment_year": user.student_profile.enrollment_year,
                "semester": user.student_profile.semester,
            }
        return {}

    @staticmethod
    async def refresh_access_token(db: AsyncSession, refresh_token_str: str) -> Tuple[str, str]:
        """Verify refresh token and issue a new access token."""
        payload = decode_access_token(refresh_token_str)
        if not payload:
            raise AuthenticationException("Invalid or expired refresh token")

        user_id_str = payload.get("sub")
        try:
            user_uuid = UUID(user_id_str)
        except (ValueError, TypeError):
            raise AuthenticationException("Malformed token claims")

        result = await db.execute(select(User).where(User.user_id == user_uuid, User.is_active == True))
        user = result.scalar_one_or_none()
        if not user:
            raise AuthenticationException("User account not found or deactivated")

        claims = {
            "sub": str(user.user_id),
            "college_id": str(user.college_id),
            "role": user.role,
            "profile_id": payload.get("profile_id"),
        }
        new_access_token = create_access_token(claims)
        new_refresh_token = create_refresh_token(claims)
        return new_access_token, new_refresh_token
