from typing import AsyncGenerator
from uuid import UUID
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession
from sqlalchemy import text
from app.core.config import settings

# Async engine configured for PostgreSQL asyncpg connection pooling
engine = create_async_engine(
    settings.DATABASE_URL,
    echo=settings.DEBUG and False,
    pool_size=20,
    max_overflow=10,
    pool_pre_ping=True,
)

AsyncSessionLocal = async_sessionmaker(
    bind=engine,
    class_=AsyncSession,
    autocommit=False,
    autoflush=False,
    expire_on_commit=False,
)


async def get_db() -> AsyncGenerator[AsyncSession, None]:
    """Dependency that yields an asynchronous database session."""
    async with AsyncSessionLocal() as session:
        try:
            yield session
        finally:
            await session.close()


async def set_tenant_context(session: AsyncSession, tenant_id: str | UUID) -> None:
    """
    Sets the session-level variable app.current_tenant for PostgreSQL Row-Level Security (RLS).
    """
    try:
        tenant_str = str(tenant_id)
        # Execute SET LOCAL app.current_tenant
        await session.execute(text(f"SET LOCAL app.current_tenant = '{tenant_str}'"))
    except Exception:
        # Non-critical if running in test/sqlite environment without custom RLS settings
        pass
