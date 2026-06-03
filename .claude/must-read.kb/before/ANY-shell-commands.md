---
requires:
  - ~/.claude/reference.kb/bash-conventions.md
---

# Shell commands

The Bash() tool runs every command under `set -euo pipefail`, `shopt -s
failglob`, and `set -x` — so each is traced as `+ $ <cmd>` (PS4 `+ $ `).
