# Architecture

## System Design

```
Browser -> Next.js (Vercel) -> Connect RPC -> FastAPI (Railway) -> PostgreSQL (Supabase)
```

- Frontends are server-rendered Next.js apps deployed to Vercel
- Backend is a Python FastAPI service with Connect RPC handlers, deployed to Railway
- Database is PostgreSQL on Supabase with row-level security
- API contracts are defined in protobuf, code is generated for both TypeScript and Python

## Data Flow

1. User interacts with Next.js frontend
2. Frontend calls backend via Connect RPC (generated TypeScript client)
3. Backend handles request via Connect RPC handler (generated Python server stubs)
4. Backend queries PostgreSQL via Supabase client
5. Response flows back through the same path with typed responses
