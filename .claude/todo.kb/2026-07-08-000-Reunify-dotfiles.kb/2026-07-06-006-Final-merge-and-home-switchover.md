---
managed-by: Skill(llm-subtask)
status: open
---

# Final merge and home switchover

**Priority:** Low now, High once 000-005 complete (strictly last)
**Complexity:** Low (if the identical-content ideal held)
**Branch:** main (merge commit), then live `~`
**Context:** disjoint histories (no merge base) — main 625 commits, svelte 329

## Problem Statement

Merge svelte-crostini into main with zero conflicts, make main the living branch on
this machine, retire svelte-crostini.

## Implementation Steps

- [ ] unit tests first (vague reminder): codify the preflight as a runnable check —
      merge-tree conflict count == 0, plus the accumulated invariant suites from
      000/001/005 all green on the merged tree before switchover
      (shape: run-once `X_check.sh` for merge-tree; the merged-tree suite
      run is `./.local/share/redo/do test` in a scratch checkout — zero
      installs — see ../2026-07-07-000)
- [ ] preflight: `git merge-tree main svelte-crostini` (or a scratch worktree merge)
      shows zero conflicts; `git diff main svelte-crostini --stat` shows only
      expected one-sided paths
- [ ] commit/park any uncommitted state in live `~` (gh/config.yml, etc.)
- [ ] in the clone (~/repo/github.com/bukzor/dotfiles):
      `git merge --allow-unrelated-histories svelte-crostini` on main
- [ ] review merged tree vs live `~` (`git diff main svelte-crostini` empty;
      spot-check resurrected main-only survivors)
- [ ] push main
- [ ] in live `~` repo: fetch, `git checkout main`, working-tree diff review
- [ ] smoke test: new login shell, bash -i, zsh -i, vim, tmux
- [ ] set origin default branch = main (already is); delete/archive svelte-crostini
      after a comfort period

## Success Criteria

- [ ] `~` is on main; `git -C ~ status` clean; all daily tools work
- [ ] one lineage; no orphan branches carrying unique content

## Notes

The switchover changes live dotfiles in place — do it at a low-stakes moment and
keep the pre-switch commit id noted for instant rollback
(`git checkout svelte-crostini` restores everything).
