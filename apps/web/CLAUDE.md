# Web App

Next.js App Router, TypeScript. Runs on localhost:3000 in dev.

## Patterns
- Components in src/components/ (PascalCase)
- Pages in src/app/ following Next.js App Router conventions
- API calls use generated Connect RPC client from @repo/generated-*
- Shared utils from @repo/shared-ts
- Tests next to source: Component.tsx -> Component.test.tsx

## Commands
pnpm dev     # Start dev server on :3000
pnpm test    # Run vitest
pnpm build   # Production build
pnpm lint    # Run biome
