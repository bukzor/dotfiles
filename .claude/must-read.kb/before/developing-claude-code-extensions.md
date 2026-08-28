---
triggers:
  - read: ~/.claude/reference.kb/claude-md-frontmatter.md
---

# Developing claude-code extensions (hooks, skills, commands, …)

Claude-Code-related skills are lazy loaded, from `~/.claude/skill-categories/claude-code/`.

See also: lazy-loading/skills.md

## Writing reusable agent instruction

The fleet's authorship law is a claim ledger, not prose: read
`~/repo/github.com/bukzor/bukzor-agent-skills/docs/dev/claims.kb/design.claims.kb/authorship.kb/`
before writing or rewriting a skill body — `ls` it, then the two or
three whose names bear on what you are changing. It costs tokens
nobody is paying (it is cold text) and it is where the recurring
mistakes are already named: writing a procedure where a stance is
wanted, deleting situational content in the name of portability,
delegating from hot text to cold, and a description that would not
fire on the message that created the skill.
