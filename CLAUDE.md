# Monorepo Template

Monorepo: TS frontend (Vercel) + Python API (Railway) + Postgres (Supabase)
Contracts: protobuf -> generated TS + Python via buf

## Commands (run from repo root)
just dev | just test | just codegen | just lint | just migrate | just db-reset

## Structure
apps/web/          -> Customer site (Next.js, :3000)
apps/api/          -> Backend API (FastAPI, :8000)
packages/shared-ts -> Shared TypeScript utilities
proto/             -> API contract definitions (source of truth)
supabase/          -> Migrations + seed data

## Detailed Docs
Read docs/agent-instructions.md for full project context.
Read .claude/docs/ for architecture and dependency graph.
Each app has its own CLAUDE.md for local context.
