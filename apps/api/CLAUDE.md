# API Service

Python FastAPI. Runs on localhost:8000 in dev.

## Patterns
- Endpoints in main.py, business logic in services/
- Use structlog for all logging (JSON output) — never print()
- Types come from generated proto code — never hand-write API types
- Tests next to code: services/user.py -> tests/unit/test_user.py

## Commands
uv run uvicorn main:app --reload --port 8000   # Dev server
uv run pytest                                   # All tests
uv run pytest tests/unit/                       # Unit only
uv run ruff check .                             # Lint
