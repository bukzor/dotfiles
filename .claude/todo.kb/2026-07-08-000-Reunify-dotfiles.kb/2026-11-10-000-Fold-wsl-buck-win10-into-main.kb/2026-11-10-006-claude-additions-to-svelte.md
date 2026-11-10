---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-11-10-000-Fold-wsl-buck-win10-into-main.md  # the `.claude/` reconcile step's list of genuine additions
  - ./2026-11-10-003-claude-dir-uncommitted.md  # Final report: per-path svelte status
---

# Land wsl-buck-win10's genuine `.claude/` additions on svelte-crostini

**Parent:** <../2026-11-10-000-Fold-wsl-buck-win10-into-main.md> (wave 4, `.claude/` reconcile)

## Problem Statement

The parent's reconcile step names the `.claude/` content that is new on
`wsl-buck-win10` and missing from svelte. Author each one on
`svelte-crostini`, so that unit 007 can then make main's `.claude/` match
svelte's path for path. Port *only the new content*. Where svelte's copy of
a file has moved on since wsl's (e.g. `reference.kb/python/style.md`: svelte
is newer except for wsl's TypeGuard bullet), apply wsl's delta onto svelte's
version.

- `reference.kb/data-format-selection.md` +
  `must-read.kb/before/choosing-a-data-file-format.md`: check svelte has no
  renamed or absorbed equivalent first (`--no-renames`, and grep for the
  topic). If it does, report it instead of adding a duplicate.
- `reference.kb/python/style.md`: the TypeGuard bullet.
- `design-rules.kb/mirror-the-sources-distinctions.md`,
  `skills/subagent-handoffs` (symlink, svelte's form: absolute, no
  trailing `/`).
- `sessions.kb` gitlink: bump to wsl's (`88129c2` or later pushed
  `bukzor.claude-sessions` main).

Not here: `settings.json` (svelte already has the only intent, `de216c6`),
`skills/llm-chat-librarian` (svelte's form wins; unit 007 applies it on
main).

Report the svelte commit ids per item.

**Scope (only these files):** in the svelte workspace, the `.claude/` paths
above; this handoff file.

## Steps

## Decisions

## Open Questions

## Final report
