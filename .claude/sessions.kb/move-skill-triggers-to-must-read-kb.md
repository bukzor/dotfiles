---
cwd: /home/bukzor
---
# Move skill auto-load triggers from SKILL.md descriptions to must-read.kb

Collapse the dual trigger surfaces (skill `description:` imperatives +
`must-read.kb/` filenames) into a single source of truth at
`~/.claude/must-read.kb/`. Skill descriptions revert to descriptive
prose; auto-load wiring lives in must-read.kb. Extend
`~/.claude/CLAUDE.md` Required Reading step 3 with one clause noting
that must-read.kb entries can direct skill invocation.

## Tracker

`~/.claude/CLAUDE.move-skill-triggers-to-must-read-kb.Task.md`
(untracked at session-end of `must-read-kb--sessions-archeology`)

## Caution

- Depends on the sister `must-read-kb` session's CLAUDE.md edits
  landing first (or in coordination). The Task.md's step 4 appends
  to Required Reading; concurrent edits race.
- Depends on the `must-read.d → must-read.kb` rename being committed
  (currently staged but uncommitted in the sister session).
- Plugin-skill descriptions are upstream-controlled and out of scope.
  Only the user-owned half (`~/repo/.../bukzor-agent-skills/<skill>/`)
  is achievable from the host side.
