# Bash Script Template

See: ~/.claude/CLAUDE.d/bash-script-template.sh

## Key Points

- `set -euo pipefail`: Fail fast on errors, undefined variables, and pipe failures
- `trap onerror ERR`: Explicit error handling with clear messaging
- `DEBUG` environment variable: Enable `set -x` tracing when needed
- Structure: Constants/functions first, then main logic
