from typing import Any, Dict, Optional
from uuid import UUID
from pydantic import BaseModel, EmailStr, ConfigDict


class LoginRequest(BaseModel):
    email: EmailStr
    password: str
    college_id: Optional[UUID] = None


class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    user_id: UUID
    college_id: UUID
    role: str
    profile_id: Optional[UUID] = None


class RefreshTokenRequest(BaseModel):
    refresh_token: str


class TokenPayload(BaseModel):
    sub: str
    college_id: str
    role: str
    profile_id: Optional[str] = None
    exp: Optional[int] = None


class UserProfileResponse(BaseModel):
    user_id: UUID
    college_id: UUID
    college_name: str
    college_domain: str
    email: str
    role: str
    is_active: bool
    profile: Dict[str, Any]

    model_config = ConfigDict(from_attributes=True)
