# Return Result from test functions

Return `Result` instead of `.unwrap()`. Uses `?` — same as production code.

## Diagnostic

About to write `.unwrap()` / `.expect()` repeatedly, or add
`#![allow(clippy::unwrap_used)]`. Use `-> Result<...>` instead.

## Error type

- **Homogeneous** (one error type): return it directly, e.g. `-> Result<(), Errno>`
- **Heterogeneous**: `anyhow::Result<()>`

## What stays as expect

- Test infrastructure that cannot meaningfully fail (`Drop` cleanup)
- Non-`Error` results like `OsString::into_string()` (corrupted test data, not test condition)
