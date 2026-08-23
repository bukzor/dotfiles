Executes a bash command and returns its output.

- Working directory persists between calls; shell state (env vars, functions) does not -- the shell is initialized from the user's profile. Prefer absolute paths: `cd` in a compound command can trigger a permission prompt.
- Avoid `cat`/`head`/`tail`/`sed`/`awk`/`echo` for file I/O -- use the dedicated Read/Edit/Write tools.
- `timeout` is in milliseconds: default 120000, max 600000.
- `run_in_background` runs the command detached and notifies you when it exits (no `&` needed). Foreground `sleep` is blocked; to wait on a condition, use Monitor with an until-loop.
- Git: interactive flags (`-i`) are unsupported; use `gh` for GitHub operations. Never skip hooks, amend, force-push, or run destructive operations (`reset --hard`, `checkout --`, `clean -f`) unless explicitly requested. Conventions (commit tooling, message format) are in `~/.claude/must-read.kb/before/git/` -- required reading before any git command.

REQUIRED before any post-bootstrap Bash use: read `~/.claude/must-read.kb/before/running-ANY-post-bootstrap-Bash-commands.md`.
