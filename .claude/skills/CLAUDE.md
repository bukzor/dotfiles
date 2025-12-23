--- # workaround: anthropics/claude-code#13003
depends:
    - skills/llm-subtask
---

# Skills Directory

User-maintained skills loaded via `Skill("name")` tool.

## Current Work

Check `.claude/todo.md` and `.claude/todo.kb/` for active efforts. Load `Skill("llm-subtask")` for maintenance.

## Organization

Each skill directory contains:
- `SKILL.md` - Frontmatter (name, description, setup) + skill content
- `.claude/todo.md` - Active tasks for the skill
- `.claude/todo.kb/` - Strategic task breakdowns

Browse this directory for available skills.
