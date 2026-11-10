---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-11-10-000-Fold-wsl-buck-win10-into-main.md  # "commit or park"; the `.claude/` reconcile step
  - ~/.claude/sessions.kb/CLAUDE.md  # "Push / pointer-bump cadence"
  - ~/.claude/sessions.kb/buck-win10.kb/subagent-handoffs-one-home-per-fact.md  # left the skill symlinks uncommitted
---

# `~/.claude/` uncommitted state: commit on wsl-buck-win10

**Parent:** <../2026-11-10-000-Fold-wsl-buck-win10-into-main.md> (wave 1, "commit or park")

## Problem Statement

Commit `~/.claude/`'s live uncommitted state on `wsl-buck-win10`, so the
merge into main carries it. The svelte-side reconcile is a later step of the
parent; don't do it here, but do report, per path, whether svelte already
has the change, lacks it, or has diverged (feeds that step).

- `settings.json`: the parent says wsl's diff vs. svelte is mostly lag.
  Commit the live file on wsl as-is (it is what runs here); list which keys
  are real local intent vs. lag.
- `reference.kb/python/style.md`: a genuine addition (parent names it).
- `sessions.jsonschema.yaml`: check the diff matches what the
  `sessions.kb` submodule switch (`4795ca9`) intended.
- `sessions.kb` gitlink: bump it to the submodule's pushed HEAD (verify it
  is pushed).
- `design-rules.kb/mirror-the-sources-distinctions.md`: untracked, written on
  user request by a session that crashed (see `~/.claude/todo.md`). Commit
  it, unless it is incomplete or contradicts a tracked rule (then Open
  Questions).
- `skills/llm-sessions`, `skills/subagent-handoffs`: symlinks into
  `~/repo/github.com/bukzor/bukzor-agent-skills/`; commit them the way the
  sibling skill symlinks are tracked.

**Scope (only these files):** in `~`: the six `.claude/` paths above and
`~/.claude/todo.md` (tick its design-rule item); this handoff file.

## Steps

## Decisions

## Open Questions

## Final report
