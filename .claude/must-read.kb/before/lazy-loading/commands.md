# Lazy-Loaded Commands

Commands in `~/.claude/commands/` provide task-specific workflows.

## Loading a Command

When `Command(NAME)` appears in user request:

```bash
cat ~/.claude/commands/NAME.md
```

## Available Commands

| Command | Purpose |
|---------|---------|
| `/commit` | Commit workflow with proper triage |
| `/session-start` | Orient to project, read context |
| `/session-end` | Wrap up, handle loose ends |
| `/tdd-posthoc` | Add tests to existing code |
| `/curl` | Fetch web content (better than Fetch tool) |
| `/gdb` | Step-through debugging shorthand |
| `/eol` | Ensure files end with newlines |
| `/web-search-quality` | Quality web search patterns |

## Discovery

```bash
ls ~/.claude/commands/                  # List all commands
cat ~/.claude/commands/NAME.md          # Load a command
ls ~/.claude/commands/NAME.d/           # Companion resources (if any)
```
