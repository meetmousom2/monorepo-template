# Dependency Graph

## Package Dependencies

```
proto/common/        -> packages/generated-ts/common  -> apps/web
                     -> libs/generated-py/common      -> apps/api

proto/user/          -> packages/generated-ts/user     -> apps/web
                     -> libs/generated-py/user         -> apps/api

packages/shared-ts/  -> apps/web

supabase/migrations/ -> apps/api (DB schema must match)
                     -> supabase/seed.sql (must match schema)
```

## CI Blast Radius

| What Changed | Triggers |
|---|---|
| proto/** | check-proto + test-web + test-api |
| apps/web/** or packages/** | test-web |
| apps/api/** or libs/** | test-api |
| supabase/migrations/** | test-migrations |
| CLAUDE.md, docs/ | freshness-checks |

## Adding a New Domain

When adding a new proto domain (e.g., billing):
1. Add proto/billing/v1/billing.proto
2. Run `just codegen` to generate packages/generated-ts/billing/ and libs/generated-py/billing/
3. Add @repo/generated-billing to consuming apps' package.json
4. Update this file with the new dependency edges
5. Update CI path filters if using per-domain granularity
