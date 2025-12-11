## Shell Scripting

Please follow these guidelines when writing bash scripts.
They may not be (or may be) equally applicable to simple commands.

### Template

See: writing-bash-scripts.template.sh

**Key features:**
- `set -euo pipefail`: Fail fast on errors, undefined variables, and pipe failures
- `trap onerror ERR`: Explicit error handling with clear messaging
- `DEBUG` environment variable: Enable `set -x` tracing when needed
- Structure: Constants/functions first, then main logic

### Guidelines

Always use `set -euo pipefail` at the start of bash scripts.

Or better, use a similar command that doesn't need `cd``: `ls a/b`

Long pipelines: newline-indent after pipe operators. Example: `find . -print0 |
  xargs -r0 command`

Never use globbing for file operations - use `find -print0 | xargs -r0` instead.

Avoid supressing errors wherever possible. Some examples to avoid:
`2>/dev/null` `|| true`

Check for unset variables using `[[ "${VAR:-}" ]]` pattern.

Avoid `head` (causes SIGPIPE) - use `sed -n` instead.

Avoid `grep` for control flow (returns failure on no match) - use `sed -n` instead.

Prefer bash parameter expansion over sed when possible:
- Use `${var//search/replace}` instead of `sed` for simple substitutions
- Run `shellcheck` to catch these and other issues
