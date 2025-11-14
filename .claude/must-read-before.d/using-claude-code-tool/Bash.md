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
