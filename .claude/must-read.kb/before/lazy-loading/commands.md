# Lazy-Loaded Commands

Commands in `~/.claude/commands/` provide task-specific workflows.

## Loading a Command

When `Command(NAME)` appears in user request:

```bash
cat ~/.claude/commands/NAME.md
```

## Discovery

```bash
md-frontmatter ~/.claude/commands/*.md  # List commands: description per file
cat ~/.claude/commands/NAME.md          # Load a command
ls ~/.claude/commands/NAME.d/           # Companion resources (if any)
```
