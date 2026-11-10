---
managed-by: Skill(llm-subtask)
status: done
blocked-by:
  - ./2026-11-10-004-apply-wave-1-rulings.md
required-reading:
  - ./CLAUDE.md
  - ../2026-11-10-000-Fold-wsl-buck-win10-into-main.md  # the merge step's resolution list; Success Criteria
  - ../CLAUDE.md  # topology: where dotfiles--main goes
  # for each wsl commit, why it exists and whether its content already lives on svelte:
  - ./2026-11-10-000-wsl-shell-settings.md
  - ./2026-11-10-001-misc-config-review.md
  - ./2026-11-10-002-untracked-triage.md
  - ./2026-11-10-004-apply-wave-1-rulings.md
---

# Merge `wsl-buck-win10` into `main`

**Parent:** <../2026-11-10-000-Fold-wsl-buck-win10-into-main.md> (wave 3, "in `dotfiles--main`: `git merge`")

## Problem Statement

Create the `main` workspace at `~/repo/github.com/bukzor/dotfiles--main/`
(a fresh clone of `github.com/bukzor/dotfiles`, on `main`), then `git merge
origin/wsl-buck-win10` there and push. After it, main ↔ svelte is a
two-lineage problem again (task 004).

`git merge-tree` against `origin/main` at `fa3f7c7` gives 13 conflicts. The
parent's merge step rules on most. Unlisted ones, and their default:

- `.gitignore_global` (modify/delete), `.profile` (the nix hook, now svelte's
  `env.d/400-nix.sh`), `.hgignore_global`: take main's side, after
  confirming main or svelte already holds what wsl's change wanted (e.g.
  the `settings.local.json` ignore in svelte's `.config/git/ignore`).

Also read every file that *auto-merged* (`.zshrc`, `.config/gh/config.yml`,
and any others): a clean textual merge can still pull retired-structure
lines into main. The rule is the same: main keeps its structure, and wsl's
intent counts only where no `.config/sh` piece or svelte file already
carries it.

A conflict or auto-merge whose resolution is not covered by those rules:
stop before committing the merge, leave it in progress in `dotfiles--main`,
and put the path and options under Open Questions. A merge in progress in
that workspace harms nothing; a wrong merge pushed to main does.

The `.claude/` add/add conflicts take main's side here. The real `.claude/`
reconcile is the parent's next step, not this unit.

Merge commit message: names `wsl-buck-win10` as the counterpart and lists
each non-trivial resolution in one line. Push `main` right after.

Check and report: `git rev-list origin/main..origin/wsl-buck-win10` is
empty after the push; `git merge-tree` conflict count for `origin/main`
vs. `origin/svelte-crostini`, before (26 per the plan) and after.

**Scope (only these files):** the `dotfiles--main` workspace (whole tree,
for this merge only); this handoff file. Nothing in `~` or the svelte
workspace except this file.

## Steps

- [x] clone `dotfiles--main`; baseline `merge-tree` counts
- [x] `git merge --no-commit origin/wsl-buck-win10`; resolve the 13 conflicts
- [x] review auto-merged files and pure additions
- [x] commit merge; push `main`; post-push checks
- [x] Final report; `status: done`; commit this file on svelte

## Decisions

- Unlisted conflicts, main's side after confirming the intent lives
  elsewhere: `.gitignore_global` (delete) and `.hgignore_global` — the
  `settings.local.json` ignore is in main's `.gitignore` and svelte's
  `.config/git/ignore`; `.profile` — nix hook is svelte `env.d/400-nix.sh`.
- `.sh_plugins.d/command-not-found.sh` merged *clean* (wsl renamed it from
  `brew-command-not-found.sh`, which main deleted), so it was not among the
  13; removed it anyway, per the parent's ruling.
- `.zshrc` auto-merged wsl's `PNPM_HOME` block; took main's `.zshrc`. And
  `.npmrc` (wsl add) dropped. Both ruled out (000:1, "recommendations
  stand"); 004 assumed they lived only in retired files, but they did not.
- Kept as merged: `gh` `git_protocol: ssh` (ruling), kitty bump,
  `.ssh/authorized_keys` (+4 public keys, incl. buck-win10), `TODO.md`,
  `bin/brew` (exit fix + ruby26 `PATH`), `bin/yesno`, all wsl additions
  (WSL helpers, runit, Windows Terminal, `setup/alpine/`, `.claude/`).
- Merge committed with plain `git commit -F`: `commit-staged` does not
  make merge commits, and this fresh clone's index is this unit's alone.

## Open Questions

None blocking. For the main ↔ svelte convergence (not this unit):
`.envrc` and `bin/alternatives/.gitignore` are new main ↔ svelte add/add
conflicts; `bin/brew`'s ruby26 `PATH` is host-local on a shared file.

## Final report

- `main` `30895e0` (pushed, `59082f3..30895e0`): merge of
  `wsl-buck-win10` `fa3f7c7`; message lists each resolution.
- `git rev-list origin/main..origin/wsl-buck-win10`: empty (count 0).
- `merge-tree` conflicts, `origin/main` vs `origin/svelte-crostini`
  (`1e2a85b`): **28 before** (not 26: svelte moved since the plan),
  **60 after**. +31 `.claude/` add/add, +`.claude/sessions.kb` gitlink,
  +`.envrc`, +`bin/alternatives/.gitignore`; −`.config/gh/config.yml`,
  −`bin/yesno` (now identical). The `.claude/` rise is the parent's
  predicted resurfacing; its reconcile step clears it.
- Workspace: `~/repo/github.com/bukzor/dotfiles--main/` on `main`, clean.
  Scratch: `~/trash/fold-005-*`.
