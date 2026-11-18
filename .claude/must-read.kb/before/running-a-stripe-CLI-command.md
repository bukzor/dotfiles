# Before running a stripe CLI command

> [!DRAFT] agent-authored 2026-09-02, vetoable.

**Name the mode.** Sandbox and live are separate object graphs and the CLI
binds to one context at a time; `--live` is refused outright until
`stripe switch context` selects a live account. Never inherit whatever the
CLI last pointed at — a prior session queried the sandbox and reported the
answer as the account's.

**Nested API fields take bracket flags:** `--parent[child]=value`, never
dotted.
