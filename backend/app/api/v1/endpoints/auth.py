from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import get_current_user, get_db_session
from app.models.user import User
from app.schemas.auth import (
    LoginRequest,
    RefreshTokenRequest,
    TokenResponse,
    UserProfileResponse,
)
from app.schemas.common import APIResponse
from app.services.auth_service import AuthService

router = APIRouter(prefix="/auth", tags=["Authentication & Identity"])


@router.post("/login", response_model=APIResponse[TokenResponse])
async def login(
    data: LoginRequest,
    db: AsyncSession = Depends(get_db_session),
):
    """User authentication and JWT issuance across all authorized institutional roles."""
    user, access_token, refresh_token = await AuthService.authenticate_user(
        db=db,
        email=data.email,
        password=data.password,
        college_id=data.college_id,
    )
    profile_id = AuthService.extract_profile_id(user)
    return APIResponse(
        message="Authentication successful",
        data=TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
            token_type="bearer",
            user_id=user.user_id,
            college_id=user.college_id,
            role=user.role,
            profile_id=profile_id,
        ),
    )


@router.get("/me", response_model=APIResponse[UserProfileResponse])
async def get_current_user_profile(
    current_user: User = Depends(get_current_user),
):
    """Fetch profile metadata and tenant affiliation for currently authenticated session."""
    profile_data = AuthService.build_profile_dict(current_user)
    return APIResponse(
        data=UserProfileResponse(
            user_id=current_user.user_id,
            college_id=current_user.college_id,
            college_name=current_user.college.name if current_user.college else "N/A",
            college_domain=current_user.college.domain if current_user.college else "N/A",
            email=current_user.email,
            role=current_user.role,
            is_active=current_user.is_active,
            profile=profile_data,
        )
    )


@router.post("/refresh", response_model=APIResponse[dict])
async def refresh_token(
    data: RefreshTokenRequest,
    db: AsyncSession = Depends(get_db_session),
):
    """Rotate and refresh access token with active account verification."""
    new_access, new_refresh = await AuthService.refresh_access_token(
        db=db, refresh_token_str=data.refresh_token
    )
    return APIResponse(
        message="Token refreshed successfully",
        data={
            "access_token": new_access,
            "refresh_token": new_refresh,
            "token_type": "bearer",
        },
    )
