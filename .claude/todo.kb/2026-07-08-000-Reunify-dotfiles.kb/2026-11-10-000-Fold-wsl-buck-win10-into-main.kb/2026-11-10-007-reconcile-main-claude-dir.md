---
managed-by: Skill(llm-subtask)
status: done
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

- [x] classify with `~/trash/fold-007/classify.sh` (257 paths, all adds):
      80 same, 32 take-svelte, 133 svelte-deleted, 12 opt-in `.gitignore`,
      0 never-on-svelte
- [x] main commit: take svelte's content (32)
- [x] main commit: delete svelte-deleted (133)
- [x] main commit: drop opt-in `.gitignore`s (12)
- [x] checks; Final report; `status: done`; commit this file on svelte

## Decisions

- Opt-in `.gitignore`s are their own class, checked before the others: none
  of the 12 was ever on svelte, so they'd otherwise have read as
  never-on-svelte. Their `skills/synced/` ignore is in svelte's root
  `.gitignore`.
- Provenance check beyond the brief: main's blob for all 133 deleted paths,
  and 28 of the 32 taken ones, is a blob svelte once had at that path, so
  nothing wsl-local was lost. The 4 others are svelte's newer form:
  `python/style.md` (006's TypeGuard port), `sessions.kb`
  (`88129c2 -> 8e94206`), `llm-chat-librarian` and `llm-discourse-graph`
  (trailing `/`). The one wsl-local edit, `todo.md`'s orphaned-design-rule
  item, was `[x]` and its goal met by 006, so svelte's copy is taken.
- Took svelte's mode and object with `update-index --cacheinfo` (a
  symlink, a `100755` hook, and a gitlink are among them).

## Open Questions

None.

## Final report

`main`, pushed after each (`30895e0..937c97d`), counterpart
`svelte-crostini` `083c6d9`:

| class | count | main commit |
|---|---|---|
| take svelte's content | 32 | `88b457a` |
| svelte deleted/renamed | 133 | `3a137d2` |
| wsl `0d5ea82` opt-in `.gitignore`s | 12 | `937c97d` |
| already svelte's | 80 | none needed |

Checks:
- Every merge-added `.claude/` path is now absent from main or identical
  (mode and object) to svelte's.
- `merge-tree`, `origin/main` vs `origin/svelte-crostini` (`083c6d9`):
  **60 before, 28 after** (61 and 29 output lines: `bin/alert` prints a
  second `bin/alert~<rev>` entry). `.claude/` conflicts: 36 to 4. The
  other 24 are unchanged, path for path.
- Remaining `.claude/` conflicts are exactly 004's four: `.gitignore`,
  `CLAUDE.md`, `commands/curl.md`, `settings.json`. None unexplained.

No deviations from the brief. Scratch: `~/trash/fold-007/`.
