import pytest
from httpx import ASGITransport, AsyncClient

from main import app


@pytest.fixture
async def client():
    async with AsyncClient(
        transport=ASGITransport(app=app), base_url="http://test"
    ) as client:
        yield client


@pytest.fixture(autouse=True)
async def reset_db():
    """Reset database to clean state before each test."""
    # TODO: Add TRUNCATE + re-seed once Supabase connection is wired
    yield
