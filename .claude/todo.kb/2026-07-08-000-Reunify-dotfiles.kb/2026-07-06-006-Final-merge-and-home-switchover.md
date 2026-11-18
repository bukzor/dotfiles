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
- [x] buck-win10, brought ahead of the merge: [switch `~` to main, retire `wsl-buck-win10`](2026-07-06-006-Final-merge-and-home-switchover.kb/2026-11-18-000-switch-buck-win10-home-to-main.md) — done 2026-11-18 (pre-switch `fa3f7c7`); open questions there
- [ ] per host (penguin, buck-win10), in live `~`: note the pre-switch commit id,
      fetch, `git checkout main`, working-tree diff review
- [ ] smoke test on each host: new login shell, bash -i, zsh -i, vim, tmux,
      and `~/bin/has` + `~/bin/bootstamp` (they need `.sh_lib/functions-cli.sh`,
      which only main carries)
- [ ] CI: `fetch-depth: 0` (the deferred 2026-07-07-000 item), if the merge-tree
      check runs in CI
- [ ] once no host's `~` checks it out: rename svelte-crostini and
      wsl-buck-win10 to `merged/…`, locally and on origin (rule in
      [CLAUDE.md](CLAUDE.md); origin's default branch is already main)
- [x] `arch-svelte` (2022, one unique commit) archived as tag
      `archive/arch-svelte`, branch deleted — 2026-11-10

Fallout from buck-win10's switch (units 2026-11-18-000/001/002):

> [!@bukzor] 2026-11-18: mitmproxy `binpatch.py` hook: skip it where absent,
> *and visibly warn*. The rest: infer intent, tentative judgments, unblock.

- [x] [`settings.json`: guard the mitmproxy hook](2026-07-06-006-Final-merge-and-home-switchover.kb/2026-11-18-003-guard-mitmproxy-hook.md)
- [x] [ignores: `private-dotfiles/`, untracked noise; `.gitmodules` for the private gitlinks](2026-07-06-006-Final-merge-and-home-switchover.kb/2026-11-18-004-ignores-and-gitmodules.md)
- [x] [host fixes: ssh pin, Nix, `init.templateDir`, prettier, rust-analyzer](2026-07-06-006-Final-merge-and-home-switchover.kb/2026-11-18-005-buck-win10-host-fixes.md)
- [x] [`claude-tokens-cost` prices; `breakdown.md` frontmatter](2026-07-06-006-Final-merge-and-home-switchover.kb/2026-11-18-006-claude-tokens-prices-and-breakdown.md) — [!DRAFT] keep main-only `breakdown.md` (works now, merges clean)
- [ ] [pre-merge follow-ups: dead vim autoloads, `<C-K>`, penguin's key name, gcloud-private, pnpm, junk in `~`](2026-07-06-006-Final-merge-and-home-switchover.kb/2026-11-18-007-pre-merge-followups.md)
- [ ] [the merge, and buck-win10's `~` taking it](2026-07-06-006-Final-merge-and-home-switchover.kb/2026-11-18-008-merge-and-buck-win10-pull.md)
- [ ] penguin, before its switch: check scratch `b45a792` for unpushed work,
      push it to `bukzor/scratch`, then `git submodule sync repo/scratch` (unit 004/005)
- [ ] [!DRAFT] keep `dotfiles--main` on buck-win10 until 006 closes: units
      editing live `~` would expose half-finished edits to every session

## Success Criteria

- [ ] every host's `~` is on main; `git -C ~ status` clean; all daily tools work
- [ ] one lineage; no branches carrying unique content

## Notes

The switchover changes live dotfiles in place — do it at a low-stakes moment.
Rollback is `git checkout <pre-switch branch>` in that host's `~`.
