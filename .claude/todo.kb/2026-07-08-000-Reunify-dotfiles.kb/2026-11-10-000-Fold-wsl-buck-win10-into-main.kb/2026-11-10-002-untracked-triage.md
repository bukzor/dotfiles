---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-11-10-000-Fold-wsl-buck-win10-into-main.md  # "commit or park", "triage untracked"
---

# Untracked non-config paths in `~`: ignore, or propose a home

**Parent:** <../2026-11-10-000-Fold-wsl-buck-win10-into-main.md> (wave 1, "commit or park")

## Problem Statement

Success for the parent is "`~` has no uncommitted or unparked state". These
untracked paths are mostly not dotfiles. For each, find out what it is
(size, file types, whether it is its own git repo, last mtime, what
references it) and classify:

- **machine-local state** (caches, editor servers, credentials): ignore it.
  Add the entry to root `.gitignore` on `wsl-buck-win10`; also on svelte if
  the path can occur on penguin.
- **content that belongs elsewhere** (a project, notes, data): don't move or
  delete. Record a proposed home in Open Questions; the user decides.

Known context: `claude/` holds live working dirs of other sessions (e.g.
`claude/deadlock/`, where a peer session may be working now);
`.local/share/bukzor.deadlock-data/` relates to the repo
`~/repo/github.com/bukzor/bukzor.deadlock-data`. Read only; touch nothing
inside either. `.config/anthropic/` likely holds a credential: list
filenames only.

Root `.gitignore` already has an uncommitted 1-line edit in `~`; review and
commit it with yours.

**Scope (only these files):**
- read-only: `.config/anthropic/`, `.vscode-server/`,
  `.local/share/bukzor.deadlock-data/`, `docs/games/`, `project/`,
  `router-debug/`, `claude/`
- write: root `.gitignore` in `~` and in the svelte workspace
- this handoff file

## Steps

## Decisions

## Open Questions

## Final report
