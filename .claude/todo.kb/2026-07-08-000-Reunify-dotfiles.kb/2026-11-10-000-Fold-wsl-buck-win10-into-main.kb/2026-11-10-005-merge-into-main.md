---
managed-by: Skill(llm-subtask)
status: open
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

## Decisions

## Open Questions

## Final report
