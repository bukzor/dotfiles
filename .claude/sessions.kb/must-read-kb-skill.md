---
cwd: /home/bukzor/repo/github.com/bukzor/bukzor-agent-skills
color: yellow
session:
  started: null
  ended: null
---
# must-read.kb-skill (2026-05-15)

Designed and shipped `llm-must-read-kb` — a `Skill(llm-kb)` extension
that prescribes a triggered-conditional-read access pattern over
`must-read.kb/` directories. The skill formalizes a convention already
in use at two homes; the personal-home rename is the live follow-up.

## Completed

- `llm-must-read-kb/SKILL.md` + `CLAUDE.md` shipped
  (commit `b81c4b2` in bukzor-agent-skills, pushed).
- `.claude/todo.md` closed for the corresponding open item.
- **Personal-home rename executed.** Procedure at
  `~/.claude/CLAUDE.rename-must-read-d-to-must-read-kb.Task.md`
  (kept as record). Renamed `~/.claude/must-read.d/` → `must-read.kb/`,
  updated 8 operational references. Landed in commits `21f8179`
  (rename + reference updates) and `d9d7617` (deletion-half completion;
  see commit message for why it split).

## Live Follow-Ups

- Skill-level `llm-kb/SKILL.kb/must-read/` migration — user handling
  separately.

- `/must-read` slash-command UX — needs
  `references/create-new-trigger.md` in `llm-must-read-kb` first, so
  the manual creation procedure and the command share one method.

## Delete When

The Task.md is executed and absorbed, and the two deferred follow-ups
are either tracked elsewhere or no longer relevant.
