---
requires:
  - ~/.claude/reference.kb/bash-conventions.md
---

# Shell scripting

Script-specific guidance for authoring `*.sh` files.

### Template

See `writing-bash-scripts.template.sh`. Key features:
- `set -euo pipefail` at the top
- `trap onerror ERR` for clear failure messages
- `set -x` gated on `DEBUG`
- constants/functions first, then main logic

Run `shellcheck`.
