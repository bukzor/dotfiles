---
requires:
  - shell-commands.md
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
