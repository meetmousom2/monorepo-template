# Proto Contracts

API contracts defined in protobuf. Source of truth for all service types.

## Conventions
- One directory per domain: proto/<domain>/v1/<domain>.proto
- Shared types in proto/common/v1/common.proto
- Always import common types for pagination and timestamps
- Use `buf lint` before committing, `buf breaking` before merging

## Commands
buf lint proto/                              # Lint schemas
buf build proto/                             # Verify compilation
buf generate proto/                          # Generate TS + Python
buf breaking --against '.git#branch=main'    # Check for breaking changes
