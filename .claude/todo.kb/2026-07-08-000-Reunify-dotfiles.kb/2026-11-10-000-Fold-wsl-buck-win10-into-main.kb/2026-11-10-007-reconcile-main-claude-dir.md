---
managed-by: Skill(llm-subtask)
status: open
blocked-by:
  - ./2026-11-10-006-claude-additions-to-svelte.md
required-reading:
  - ./CLAUDE.md
  - ../2026-11-10-000-Fold-wsl-buck-win10-into-main.md  # the `.claude/` reconcile step
  - ../2026-07-06-004-Hand-merge-true-divergences.md  # "claude config" item: the four paths this unit leaves alone
  - ./2026-11-10-005-merge-into-main.md  # Final report: merge-tree counts to compare against
---

# Make main's merged-in `.claude/` match svelte-crostini's

**Parent:** <../2026-11-10-000-Fold-wsl-buck-win10-into-main.md> (wave 5, `.claude/` reconcile)

## Problem Statement

The fold merge (`30895e0`) brought `wsl-buck-win10`'s `.claude/` onto main:
a 2026-06 copy of svelte's, plus additions that unit 006 has now landed on
svelte. Left alone, it is 31+ main ↔ svelte conflicts at 006. On main, in
`dotfiles--main`, for every `.claude/` path the merge introduced:

- the same path exists on svelte → take svelte's content (stale copy, or an
  addition 006 just landed);
- svelte deleted or renamed it (count renames as deletions) → delete it on
  main;
- svelte never had it and 006 didn't add it → stop on that path: Open
  Questions, with what it is. The parent says there should be none.

Also on main: drop the per-directory `.gitignore` opt-ins from wsl `0d5ea82`
(svelte's allow-by-default scheme won in 004), and take svelte's
`skills/llm-chat-librarian` symlink.

Leave alone the paths main already had before the merge
(`.claude/{CLAUDE.md,settings.json,commands/curl.md,.gitignore}`): 004's
"claude config" item reconciles them.

Classify with a script over `git diff --name-status --no-renames
59082f3 30895e0 -- .claude`, and let it print the counts per class; don't
classify by hand. One commit per class is enough, each naming
`svelte-crostini` as the counterpart. Push main after each commit.

Check and report: `git merge-tree` conflict count, `origin/main` vs.
`origin/svelte-crostini`, before (60 per unit 005) and after, and every
remaining `.claude/` conflict with its owner (004's four, or unexplained).

**Scope (only these files):** `.claude/` in the `dotfiles--main`
workspace, except the four paths above; this handoff file.

## Steps

## Decisions

## Open Questions

## Final report
