---
managed-by: Skill(llm-subtask)
status: done
---

# Mechanical file fast-forwards

**Priority:** High (cheap, big conflict-surface reduction: 26 of 58 differing files)
**Complexity:** Low
**Branch:** both — each file has exactly one "ahead" side; copy that blob to the behind branch
**Context:** classifier verdicts, 2026-07-06 session (`classify-divergence.sh`)

## Problem Statement

26 shared paths differ between main and svelte-crostini, but one side's current blob
appears verbatim in the other side's history — a file-level fast-forward. No human
merge judgment needed beyond a sanity skim.

## Current Situation

Verified by blob-in-history check (not dates). main's last real pass was 2025-08-20;
svelte's 2025-10-22 import was seeded from an older snapshot, so main leads 19:7.

## Implementation Steps

- [x] unit tests first: `mechanical-fast-forwards_check.sh` (root, both
      branches), a cross-branch identity check over the 26 paths via
      `redo-always` + `git diff HEAD origin/<other-branch>`. CI's
      `fetch-depth: 0` added to `check-sh.yml` (both branches) so
      `origin/main`/`origin/svelte-crostini` are reachable. Landed red first
      (commits `7ba94f2` svelte-crostini, `661e5ae` main).
- [x] svelte-crostini takes main's version (19 files) — commit in live `~`,
      thematic commits (bin tools / gcloud tools / misc):
      bin/alert-slack, bin/deinterlace, bin/gcloud-dump-roles, bin/gcloud-logging-cat,
      bin/gcloud-python, bin/gcpenv, bin/git-main, bin/git-prune-branches,
      bin/git-upstream, bin/groupby, bin/json-to-jq, bin/mangrep, bin/strace-defaults,
      bin/tf-graph, bin/tmux-color, bin/unescape, bin/vimmerge, .pythonrc.py,
      .vim/lua/bukzor/aerial.lua. Commits `fad2951`, `4e80e78`, `7111ed5`.
- [x] main takes svelte's version (7 files) — commit in the clone
      (~/repo/github.com/bukzor/dotfiles--main-reunify):
      bin/brew-handle-gnubin, bin/terminal, bin/tmux-cd, bin/uncolor, Brewfile,
      .inputrc, .vim/lua/bukzor/unload.lua. Commit `d84c30e`.
- [x] skim each diff during application; anything surprising gets bounced to todo 004.
      One finding, bounced to todo 003 instead (main-only-path triage owns it,
      not a same-path divergence): main's fast-forwarded `.pythonrc.py` imports
      `bukzor.readline` from main-only `lib/python/bukzor/`, a separate
      namespace package from svelte's existing `lib/pythonpath/bukzor/` (no
      filename overlap). Currently inert — `PYTHONSTARTUP` unset on svelte.
      Noted in 003's task file (commit `d54fc9a`).

## Success Criteria

- [x] all 26 paths byte-identical across branches — verified via
      `mechanical-fast-forwards.checked`, green on both branches after both
      fast-forward commits were pushed (`redo -c test` clean end to end).

## Notes

Mechanic: `git checkout <ahead-branch> -- <path>` in the behind branch's checkout.
Execution: the two directions are independent — run them as two parallel subagents
(one per branch, respecting the single-writer rule in ./CLAUDE.md).
Some main-ahead files are work-era tools (gcloud-*); take main's version anyway —
keep/delete decisions belong to todo 003, not here.
