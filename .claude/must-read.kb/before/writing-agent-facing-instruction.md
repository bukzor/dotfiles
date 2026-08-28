---
triggers:
  - read: ~/.claude/reference.kb/claude-md-frontmatter.md
---

# Writing agent-facing instruction

Triggers on the artifact, not the request: any text an agent will load
as instruction rather than read as prose — a `CLAUDE.md`, an entry in
this bank, a `~/.claude/reference.kb/` page, a `SKILL.md` body or
description, a hook, a command. Human-facing docs are
`editing-documentation.md`; its rules still apply on top of these.

## The law is a ledger, not this file

`~/repo/github.com/bukzor/bukzor-agent-skills/docs/dev/claims.kb/design.claims.kb/authorship.kb/`
— `ls` it, then read the two or three whose names bear on what you are
changing. It is cold text: cheap to read, and it is where the
recurring mistakes are already named and argued.

Most of it governs any agent-facing text, whatever the surface:

- what the reader pays, and how price varies by how often the text
  loads — a `CLAUDE.md` is the hottest text you will ever write;
- stating a stance rather than a procedure, so the instruction still
  works in a setting you did not picture;
- naming situational content under one heading instead of deleting it
  for portability;
- writing trigger text — a description, a filename in this bank — for
  retrieval alone, and testing it against the message that would need
  it;
- knowing which side of the author/reader fence a rule belongs on.

Four entries are about skills specifically — naming, instance
citation, operator composition, the description surface — and are
skippable when the artifact is not a skill.

## Extension mechanics

Claude-Code-related skills are lazy loaded, from
`~/.claude/skill-categories/claude-code/`. See also:
`lazy-loading/skills.md`.
