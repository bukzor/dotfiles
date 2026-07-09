---
managed-by: Skill(llm-subtask)
status: open
---

# Stale-seed adjudication

**Priority:** Medium
**Complexity:** Low-Medium
**Branch:** svelte-crostini (expected to take main's version after eyeball)
**Context:** classifier "diverged" verdicts where svelte's copy is untouched since import

## Problem Statement

9 "diverged" files have svelte-side content dating to the initial import (2025-10-22)
or the 2023 seed — svelte never touched them, but their blobs match no main ancestor
(the seed likely came from an arch-svelte-lineage working tree with uncommitted
changes). main's 2025-08-20 pass is presumptively ahead, but each needs an eyeball
to confirm the svelte seed holds nothing unique before taking main's side.

## Implementation Steps

- [ ] unit tests first, where appropriate (vague reminder): the adjudicated files are
      mostly config — for any with observable behavior (kitty, pnpm, gh) note a
      one-liner check that the tool still starts/answers after taking main's side
      (shape: run-once `X_check.sh`, skip-if-absent — see ../2026-07-07-000)
- [ ] eyeball diff and adjudicate each (commit on svelte in live `~` if main wins;
      escalate to todo 004 if genuinely mixed):
    - [ ] .config/kitty/kitty.conf (svelte = 2250-line default dump? main trimmed)
    - [ ] .vimrc
    - [ ] .vim/init.lua
    - [ ] .config/pnpm/rc
    - [ ] .gitmodules (submodule set — cross-check `git submodule status` both sides)
    - [ ] .config/gh/config.yml
    - [ ] .config/gh/.gitignore
    - [ ] .config/gcloud/.gitignore
    - [ ] .ssh/.gitignore

## Success Criteria

- [ ] each file either byte-identical across branches or moved to todo 004 with a note

## Notes

Caution: `.gitmodules` and gh/gcloud configs may encode crostini-vs-macos differences
that are *correct* per-machine — if so, the merged version needs guards or a
machine-local mechanism, which is a todo-004-style resolution.
