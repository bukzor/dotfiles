---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-008-merge-and-buck-win10-pull.md  # Open Questions 1, 3, 4, 5
  - ./2026-11-18-000-switch-buck-win10-home-to-main.md  # the preflight to reuse for the Windows home
---

# buck-win10 after the merge: the Windows home checkout, pnpm 10, orphans, CI

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (after the merge)

## Problem Statement

Tentative rulings (user, 2026-11-18: "infer intent, tentative judgments"):

1. **`/mnt/c/Users/worki`** is a third checkout of this repo, on
   `svelte-crostini`, and isn't in the topology table. Penguin's unit 009
   will rename `svelte-crostini` to `merged/` on origin, possibly while
   this unit runs.
   - Find out what that checkout serves: which tracked files Windows
     programs actually read there, its uncommitted state, and any unpushed
     commits.
   - Then move it to `main` with unit 000's preflight: back up the ignored
     files that main would overwrite, and list what the checkout deletes.
     Mind Windows filesystem semantics: case-insensitivity, symlinks, file
     modes, CRLF. If moving it would break something a Windows program
     relies on, don't switch. Record that under Open Questions with
     options.
   - Add the checkout to the topology table in `../CLAUDE.md` (the
     coordinator allows that one edit).
2. **pnpm 10** in `~/prefix/npm-global/bin`: remove it and keep `claude`.
   Show that a shell started afterwards resolves pnpm 12.
3. **Orphans:** move `~/node_modules/` and `~/pnpm-lock.yaml` (from
   2025-09) into `~/trash/merge-008/`.
4. **CI on main:** report each workflow's result on the merge commit
   (`gh run list`). For `lint-lua.yml`, which was already broken, give the
   cause. If the fix is a one-line config change, make it, using the
   normal two-branch rule. Otherwise put it under Open Questions.

**Scope (only these):** the Windows-home checkout; the `../CLAUDE.md`
topology table; `~/prefix/npm-global/`; the two orphans; CI workflow files
for item 4 only; this handoff file.

## Steps

## Decisions

## Open Questions

## Final report
