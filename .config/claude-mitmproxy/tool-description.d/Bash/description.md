Executes a bash command and returns its output.

- `cd` carries to the next call only in the main session, when the command succeeds and ends inside the working directories; otherwise the shell returns to the start folder. Shell state (env vars, functions) does not persist -- the shell is initialized from the user's profile. Prefer absolute paths: `cd` in a compound command can trigger a permission prompt.
- `timeout` is in milliseconds: default 120000, max 600000.
- `run_in_background` runs the command detached and notifies you when it exits (no `&` needed; don't poll its output file).
- Foreground `sleep` is blocked; to wait on a condition, use Monitor with an until-loop.
- Git: interactive flags (`-i`) are unsupported; use `gh` for GitHub operations.
- GitHub notifies the owner of any `@name` in a PR, issue, or comment: write a bare `@name` only for a real login you mean to notify; backtick roles, placeholders, and code (`@types/node`) or drop the `@`.
