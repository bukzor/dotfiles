---
managed-by: Skill(llm-subtask)
status: open
---

# Final merge and home switchover

**Priority:** Low now, High once everything else is done (strictly last)
**Complexity:** Low (if the identical-content ideal held)
**Branch:** main (merge commit), then each host's live `~`
**Context:** disjoint histories (no merge base) — main 640 commits, svelte 615 (2026-11-10)

## Problem Statement

Merge svelte-crostini into main with zero conflicts, make main the living branch on
every host, retire svelte-crostini and wsl-buck-win10.

## Implementation Steps

- [ ] unit tests first (vague reminder): codify the preflight as a runnable check —
      merge-tree conflict count == 0, plus the accumulated invariant suites from
      000/001/005 all green on the merged tree before switchover
      (shape: run-once `X_check.sh` for merge-tree; the merged-tree suite
      run is `./.local/share/redo/do test` in a scratch checkout — zero
      installs — see ../2026-07-07-000)
- [ ] preflight: `git merge-tree main svelte-crostini` shows zero conflicts;
      `git diff main svelte-crostini --stat` shows only expected one-sided paths
- [ ] commit/park uncommitted state in each host's live `~` (penguin: see
      `../2026-06-03-001-commit-accumulated-dotfiles-changes.md`)
- [ ] in `dotfiles--main`: `git merge --allow-unrelated-histories svelte-crostini`
- [ ] review the merged tree (`git diff main svelte-crostini` empty;
      spot-check resurrected main-only survivors)
- [ ] push main
- [ ] per host (penguin, buck-win10), in live `~`: note the pre-switch commit id,
      fetch, `git checkout main`, working-tree diff review
- [ ] smoke test on each host: new login shell, bash -i, zsh -i, vim, tmux,
      and `~/bin/has` + `~/bin/bootstamp` (they need `.sh_lib/functions-cli.sh`,
      which only main carries)
- [ ] CI: `fetch-depth: 0` (the deferred 2026-07-07-000 item), if the merge-tree
      check runs in CI
- [ ] after a comfort period: delete svelte-crostini and wsl-buck-win10 (origin
      default branch is already main)
- [x] `arch-svelte` (2022, one unique commit) archived as tag
      `archive/arch-svelte`, branch deleted — 2026-11-10

## Success Criteria

- [ ] every host's `~` is on main; `git -C ~ status` clean; all daily tools work
- [ ] one lineage; no branches carrying unique content

## Notes

The switchover changes live dotfiles in place — do it at a low-stakes moment.
Rollback is `git checkout <pre-switch branch>` in that host's `~`.
