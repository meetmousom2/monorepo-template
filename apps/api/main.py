import os

import structlog
from fastapi import FastAPI

structlog.configure(
    processors=[
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.add_log_level,
        structlog.processors.JSONRenderer(),
    ],
)
logger = structlog.get_logger()

app = FastAPI(title="API")


@app.get("/health")
async def health():
    return {
        "status": "ok",
        "service": "api",
        "version": os.getenv("VERSION", "dev"),
    }


@app.get("/users")
async def list_users():
    # TODO: Replace with actual Supabase query
    return {"users": [], "message": "Connect to Supabase to return real data"}
