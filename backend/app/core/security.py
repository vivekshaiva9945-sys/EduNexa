import datetime
import hashlib
import threading
import uuid
from typing import Any, Dict, Optional
import bcrypt
import jwt
from app.core.config import settings


def hash_password(password: str) -> str:
    """Hash a password using bcrypt."""
    salt = bcrypt.gensalt(rounds=12)
    # Truncate to 72 bytes if needed to adhere to bcrypt standard specification
    password_bytes = password.encode("utf-8")[:72]
    return bcrypt.hashpw(password_bytes, salt).decode("utf-8")


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verify a plain password against the stored bcrypt hash."""
    try:
        plain_bytes = plain_password.encode("utf-8")[:72]
        hashed_bytes = hashed_password.encode("utf-8")
        return bcrypt.checkpw(plain_bytes, hashed_bytes)
    except Exception:
        return False


def create_access_token(subject: str | Dict[str, Any], expires_delta: Optional[datetime.timedelta] = None) -> str:
    """Generate a signed JWT token containing user identity, unique JTI, and tenant context claims."""
    now = datetime.datetime.now(datetime.timezone.utc)
    if expires_delta:
        expire = now + expires_delta
    else:
        expire = now + datetime.timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)

    to_encode: Dict[str, Any] = {
        "exp": expire,
        "iat": now,
        "jti": str(uuid.uuid4()),
    }
    if isinstance(subject, dict):
        to_encode.update(subject)
    else:
        to_encode["sub"] = str(subject)

    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
    return encoded_jwt


def create_refresh_token(subject: str | Dict[str, Any]) -> str:
    """Generate a long-lived signed JWT refresh token."""
    return create_access_token(
        subject=subject,
        expires_delta=datetime.timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS),
    )


def decode_access_token(token: str) -> Optional[Dict[str, Any]]:
    """Decode and validate signature of an incoming JWT token."""
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        return payload
    except jwt.PyJWTError:
        return None


class TokenRevocationStore:
    """
    In-memory thread-safe JWT revocation registry with automatic TTL cleanup.
    Guarantees immediate invalidation on server-side logout.
    """
    def __init__(self):
        self._revoked_tokens: Dict[str, float] = {}  # identifier -> expiry_timestamp
        self._lock = threading.Lock()

    def _cleanup_expired(self, current_time: float):
        """Purge expired tokens from memory to prevent unbounded memory growth."""
        expired_keys = [k for k, exp in self._revoked_tokens.items() if exp < current_time]
        for k in expired_keys:
            self._revoked_tokens.pop(k, None)

    def revoke_token(self, token_str: str, expires_at: Optional[float] = None) -> bool:
        """Revoke a token by its jti or SHA256 hash until its natural expiration."""
        if not token_str:
            return False
        now = datetime.datetime.now(datetime.timezone.utc).timestamp()
        identifier = self._get_identifier(token_str)

        if expires_at is None:
            payload = decode_access_token(token_str)
            if payload and "exp" in payload:
                expires_at = float(payload["exp"])
            else:
                expires_at = now + (settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60.0)

        with self._lock:
            self._cleanup_expired(now)
            self._revoked_tokens[identifier] = expires_at
        return True

    def is_revoked(self, token_str: str) -> bool:
        """Check if a token has been revoked."""
        if not token_str:
            return True
        now = datetime.datetime.now(datetime.timezone.utc).timestamp()
        identifier = self._get_identifier(token_str)

        with self._lock:
            exp = self._revoked_tokens.get(identifier)
            if exp is None:
                return False
            if exp < now:
                self._revoked_tokens.pop(identifier, None)
                return False
            return True

    def _get_identifier(self, token_str: str) -> str:
        """Get unique identifier from token jti or fallback to SHA-256 hash."""
        try:
            payload = jwt.decode(
                token_str,
                settings.SECRET_KEY,
                algorithms=[settings.ALGORITHM],
                options={"verify_exp": False},
            )
            if payload and "jti" in payload:
                return f"jti:{payload['jti']}"
        except Exception:
            pass
        return f"hash:{hashlib.sha256(token_str.encode('utf-8')).hexdigest()}"


# Global revocation store singleton
token_revocation_store = TokenRevocationStore()


def revoke_token(token_str: str) -> bool:
    """Revoke a token on the server."""
    return token_revocation_store.revoke_token(token_str)


def is_token_revoked(token_str: str) -> bool:
    """Check if token is revoked on the server."""
    return token_revocation_store.is_revoked(token_str)
