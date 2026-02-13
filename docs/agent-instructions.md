# Agent Instructions

Comprehensive guide for AI coding agents working in this monorepo.

## Architecture

Polyglot monorepo with TypeScript frontends and a Python backend, connected by protobuf contracts.

```
Frontend (Next.js)  <--Connect RPC-->  Backend (FastAPI)  <-->  PostgreSQL (Supabase)
     |                                      |
     +--- imports generated TS types        +--- imports generated Python types
                    |                                      |
                    +---------- proto/ (source of truth) --+
```

## Tooling

| Layer | Tool | Purpose |
|-------|------|---------|
| Commands | just | Universal task runner (Justfile) |
| JS/TS orchestration | Turborepo | Build ordering + caching |
| JS/TS packages | pnpm | Package management |
| Python packages | uv | Package management + virtual envs |
| Proto codegen | buf | Lint, build, generate from .proto files |
| Database | Supabase | Local Postgres via Docker |

## Workflow: Adding a New Feature

1. If it touches the API contract: edit proto/ first, run `just codegen`
2. Implement the backend in apps/api/
3. Implement the frontend in apps/web/
4. Add tests at each layer
5. Run `just test` to verify everything
6. DB changes go in supabase/migrations/ — use `just migrate-create <name>`

## Workflow: Changing the Database Schema

1. Create migration: `just migrate-create add_X_table`
2. Edit the generated SQL in supabase/migrations/
3. Apply locally: `just migrate`
4. Update seed data if needed: supabase/seed.sql
5. If the API needs to know: update proto/ and regenerate

## Code Conventions

- **Python**: ruff for formatting, structlog for logging (never print), pydantic for data models
- **TypeScript**: biome for formatting/linting
- **API types**: always from generated proto code — never hand-write request/response types
- **Tests**: live next to the code they test (user.py -> user_test.py, Page.tsx -> Page.test.tsx)
- **Commits**: conventional commits (feat:, fix:, chore:, docs:)

## Local Development

Prerequisite: `brew install just pnpm uv bufbuild/buf/buf supabase/tap/supabase docker`

```
localhost:3000   -> apps/web (Next.js, hot reload)
localhost:8000   -> apps/api (FastAPI, --reload)
localhost:54322  -> Supabase Postgres (Docker)
localhost:54323  -> Supabase Studio (DB GUI)
```

Start: `just dev` | Stop: `just stop` | Reset DB: `just db-reset`

## Environment Variables

- `.env.example` — committed, documents all required vars
- `.env.local` — gitignored, local dev values
- Staging/prod env vars are set in Vercel/Railway dashboards, never in git

## Testing

| Layer | Runner | Command | Speed |
|-------|--------|---------|-------|
| Unit (TS) | vitest | `turbo test` | Seconds |
| Unit (Python) | pytest | `cd apps/api && uv run pytest tests/unit/` | Seconds |
| Integration | pytest + Supabase | `just test-integration` | ~30s |
| E2E | Playwright | `just test-e2e` | Minutes |

## Important Gotchas

- Never edit generated code in packages/generated-ts/ or libs/generated-py/ — overwritten by `just codegen`
- Supabase migrations must be sequential — don't create parallel migration branches
- The API runs on port 8000, Supabase on 54322
- Run `just codegen` after any proto/ change
- Run `just db-reset` after any migration change

## Dependency Graph

```
proto/common/        -> packages/generated-ts/common  -> apps/web
                     -> libs/generated-py/common      -> apps/api
proto/user/          -> packages/generated-ts/user     -> apps/web
                     -> libs/generated-py/user         -> apps/api
packages/shared-ts/  -> apps/web
supabase/migrations/ -> apps/api (DB schema must match), seed data
```

## Blast Radius

| Changed | What to test |
|---------|-------------|
| proto/ | Everything (codegen affects all) |
| apps/web/ | Frontend only |
| apps/api/ | Backend only |
| packages/shared-ts/ | All frontends |
| supabase/ | Migrations + backend |
