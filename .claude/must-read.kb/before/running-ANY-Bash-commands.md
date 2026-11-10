---
triggers:
  - read: ~/.claude/reference.kb/bash-conventions.md
---

# Running Bash commands

The Bash() tool runs every command under `set -euo pipefail`, `shopt -s
failglob`, and `set -x` — so each is traced as `+ $ <cmd>` (PS4 `+ $ `).
The trace is your label: never `echo` a filename before reading it. Dump files
with headers in one command — `tail -n +1 -- f1 f2`.

## Bash() tool quirks

- Enclose any `cd` in a subshell — `(cd a/b && ls)` — cwd changes *sometimes*
  persist to later invocations.
- Prefer GNU `parallel` over `run_in_background`: blocks once, labeled output,
  fail-fast — `parallel --tag --halt now,fail=1 ::: 'cmd1' 'cmd2'`. Reserve
  `run_in_background` for truly async work checked much later.
