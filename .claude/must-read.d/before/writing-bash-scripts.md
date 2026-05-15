---
requires:
  - ANY-shell-commands.md
---

## Shell Scripting

Guidelines for authoring bash scripts.

### Template

See: writing-bash-scripts.template.sh

**Key features:**
- `set -euo pipefail`: Fail fast on errors, undefined variables, and pipe failures
- `trap onerror ERR`: Explicit error handling with clear messaging
- `DEBUG` environment variable: Enable `set -x` tracing when needed
- Structure: Constants/functions first, then main logic

### Guidelines

Always use `set -euo pipefail` at the start of bash scripts.

Check for unset variables using `[[ "${VAR:-}" ]]` pattern.

Run `shellcheck` to catch common issues.

When continuing long pipelines across multiple lines, put `|` at the
**end** of a line, not the start of the next one. This lets you
intersperse `# comment` lines between stages, which `\` continuation
forbids (anything after `\` ends the continuation).

```bash
# good — pipe at end; comments work between stages
find . -name '*.log' |
    # filter to the slow ones
    grep -l 'slow' |
    xargs rm

# bad — pipe at start; can't comment between stages
find . -name '*.log' \
    | grep -l 'slow' \
    | xargs rm
```
