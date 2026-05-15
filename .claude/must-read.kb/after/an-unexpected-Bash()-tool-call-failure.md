# Before fixing a failed Bash() call

Claude Code's Bash tool has known parsing bugs that mangle shell syntax.
Before assuming your command is wrong, check whether the error matches a
known `shell-quote` bug.

## Known symptoms

- `{: command not found` or `}: command not found`
- Variables unexpectedly empty in piped commands
- `syntax error near unexpected token '<'` with heredocs
- `2>&1` treated as a separate argument

These only manifest when pipes (`|`) are present. The same command without
pipes typically works fine.

## Current mitigation

`~/.claude/hooks/bash-preamble.py` wraps every command in a heredoc to
bypass `shell-quote`. If you're seeing these errors, the hook may not be
active or may need updating.

## Tracking

- https://github.com/anthropics/claude-code/issues/4711 (closed — `2>&1`)
- https://github.com/anthropics/claude-code/issues/32879 (open — `{ }`, heredocs, `$`)
