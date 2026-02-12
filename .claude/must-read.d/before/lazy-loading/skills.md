# Lazy-Loaded Skills

Skills in `~/.claude/skills/` are not loaded by default to save token overhead.

## Loading a Skill

When `Skill(NAME)` appears in frontmatter or user request:

```bash
cat ~/.claude/skills/NAME/SKILL.md
```

## Available Skills

| Skill | Trigger |
|-------|---------|
| `llm.kb` | Creating `.kb/` directories, organizing structured knowledge |
| `llm-collab` | ADRs, devlogs, multi-session coordination |
| `llm-subtask` | `subtask` command, managing multiple tasks |
| `struggle-bus` | User frustration, repeated misunderstanding |
| `artifacts-builder` | Complex claude.ai HTML artifacts |
| `webapp-testing` | Playwright testing of web apps |

## Discovery

```bash
ls ~/.claude/skills/                    # List all skills
cat ~/.claude/skills/NAME/SKILL.md      # Load a skill
ls -R ~/.claude/skills/NAME/            # Explore skill structure
```
