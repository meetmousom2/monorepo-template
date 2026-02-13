# Supabase / Database

PostgreSQL on Supabase. Local dev runs in Docker via `supabase start`.

## Conventions
- Migrations are sequential SQL files in supabase/migrations/
- Seed data in supabase/seed.sql — keep in sync with schema
- Never create parallel migration branches (merge conflicts are painful)
- Use `just db-reset` to replay all migrations + seed from scratch

## Commands
supabase start          # Start local Postgres + Studio (Docker)
supabase stop           # Stop containers
just migrate-create X   # Create new migration file
just migrate            # Apply pending migrations
just db-reset           # Wipe + replay all migrations + seed
just seed               # Re-seed without resetting
