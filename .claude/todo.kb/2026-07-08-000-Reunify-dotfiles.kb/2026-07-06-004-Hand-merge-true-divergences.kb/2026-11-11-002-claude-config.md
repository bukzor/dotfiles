---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-07-06-004-Hand-merge-true-divergences.md  # "claude config"
  - ../2026-11-10-000-Fold-wsl-buck-win10-into-main.md  # [!@bukzor] ruling on settings.json
  - ../2026-11-10-000-Fold-wsl-buck-win10-into-main.kb/2026-11-10-007-reconcile-main-claude-dir.md  # main's `.claude/` is otherwise svelte's now
---

# Claude config: the four `.claude/` files main had before the fold

**Parent:** <../2026-07-06-004-Hand-merge-true-divergences.md> (wave 1, "claude config")

## Problem Statement

`.claude/{CLAUDE.md,settings.json,commands/curl.md,.gitignore}` are the
only `.claude/` paths left differing (fold unit 007). Main's copies are its
own lineage's, older than svelte's actively maintained ones. For each,
diff main's against svelte's, carry over anything main has that is real
intent svelte lacks, and land the result on both. Expect most of each file
to be svelte's.

Decided: `settings.json` is svelte's (fold ruling: the only wsl intent,
`Bash(sudo:*)` in `ask`, is already on svelte); check main's own copy for
intent the same way. `CLAUDE.md` is the user's global instructions: treat
any main-only rule as an Open Question unless svelte plainly superseded
it.

**Scope (only these files):** the four paths, in both workspaces; this
handoff file.

## Steps

## Decisions

## Open Questions

## Final report
