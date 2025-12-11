---
requires:
  - ../shell-commands.md
---

## Bash Tool Guidelines

Please follow these instructions when using the Bash tool.

### heredocs

All commands should have this form:

```bash
Bash(bash <<'BASH'
...
BASH)
```

Rationale: this avoids several known escaping bugs in the claude-code
subsystems.

### subshells

Always enclose a command containing `cd` in a subshell.

`(cd a/b && ls)`

Rationale: this avoids a confusing misfeature that *sometimes* persists
changes in cwd to subsequent Bash invocations.

### Parallel execution

Prefer GNU `parallel` over `run_in_background`:

```bash
# Run commands in parallel, wait for all, labeled output
parallel --tag ::: 'cmd1' 'cmd2' 'cmd3'

# Same command over multiple inputs
parallel --tag 'process {}' ::: input1 input2 input3

# Fail fast if any task fails
parallel --tag --halt now,fail=1 ::: 'cmd1' 'cmd2'
```

Rationale: `run_in_background` requires polling via BashOutput (wastes tokens)
or user intervention (wastes time). `parallel` blocks once and returns all
results together, with labeling and error handling built in.

See `man parallel` for advanced options (retries, timeouts, remote execution).

Use `run_in_background` only for truly async work checked much later.
