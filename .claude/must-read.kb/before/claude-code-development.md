# Claude Code Development

Claude-Code-related skills are lazy loaded, from `~/.claude/skill-categories/claude-code/`.

See also: lazy-loading/skills.md

## CLAUDE.md Frontmatter Stripping (anthropics/claude-code#13003)

YAML frontmatter in CLAUDE.md files is parsed and stripped before being shown to the model. Only `paths:` is consumed (for unreleased `.claude/rules/` feature); all other fields are discarded.

**Workaround**: Add an empty frontmatter block first:

```yaml
--- # workaround: anthropics/claude-code#13003
depends:
    - Skill(llm-subtask)
---
```

The comment after `---` prevents the parser from treating the block as frontmatter, so the content passes through to the model as regular markdown.
