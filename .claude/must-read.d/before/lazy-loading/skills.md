# Lazy-Loaded Skills

Skills in `~/.claude/skills/` are not loaded by default to save token overhead.

## Loading a Skill

When `Skill(NAME)` appears in frontmatter or user request:

```bash
cat ~/.claude/skills/NAME/SKILL.md
```

## Discovery

```bash
ls ~/.claude/skills/                    # List available skills
cat ~/.claude/skills/NAME/SKILL.md      # Load a skill
```
