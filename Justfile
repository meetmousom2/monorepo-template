# Agent-optimized monorepo commands
# Run all commands from the repo root

# Start all services locally
dev:
    supabase start || true
    just codegen
    turbo dev &
    cd apps/api && uv run uvicorn main:app --reload --port 8000 &

# Run all tests
test: test-unit test-integration

# Unit tests only (fast, no deps)
test-unit:
    turbo test
    cd apps/api && uv run pytest tests/unit/

# Integration tests (needs local Supabase)
test-integration:
    supabase db reset --local
    cd apps/api && uv run pytest tests/integration/

# E2E tests (needs full stack running)
test-e2e:
    pnpm playwright test

# Regenerate types from proto files
codegen:
    buf generate proto/

# Lint everything
lint:
    buf lint proto/
    turbo lint
    cd apps/api && uv run ruff check .

# Apply pending DB migrations locally
migrate:
    supabase db push --local

# Create a new migration file
migrate-create name:
    supabase migration new {{name}}

# Wipe local DB and replay all migrations + seed
db-reset:
    supabase db reset --local

# Seed local DB with test data
seed:
    psql $DATABASE_URL -f supabase/seed.sql

# Stop all services
stop:
    supabase stop || true
    pkill -f "uvicorn" || true
    pkill -f "next-server" || true

# Check CI status on current PR
ci-status:
    gh pr checks $(gh pr view --json number -q .number)

# Read CI failure logs
ci-logs:
    gh run view $(gh run list --limit 1 --json databaseId -q '.[0].databaseId') --log-failed

# Check service health
health:
    @echo "--- API ---"
    curl -sf http://localhost:8000/health | jq . || echo "API not running"
