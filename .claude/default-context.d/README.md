# Claude Code Startup Context Analysis

**Total tokens consumed: 21,730**

## Token Breakdown by Category

| Category                  | Estimated Tokens | Percentage | Location         |
| ------------------------- | ---------------- | ---------- | ---------------- |
| Context Files (CLAUDE.md) | 8,000+           | 40%        | `context-files/` |
| System Prompt & Tools     | 8,000+           | 37%        | `system-prompt/` |
| Environment & Git Status  | 3,000+           | 14%        | `environment/`   |
| Conversation Overhead     | 2,000+           | 9%         | `conversation/`  |

## Directory Structure

```
claude-startup-context.d/
├── context-files/           # Symlinks to actual CLAUDE.md files (40% of tokens)
│   ├── global-CLAUDE.md -> /Users/buck/.claude/CLAUDE.md
│   ├── project-CLAUDE.md -> .../thread-leak-annotation/CLAUDE.md
│   ├── hamilton-CLAUDE.md -> .../thread-leak-data.hamilton/CLAUDE.md
│   └── hamilton-CLAUDE.local.md -> .../CLAUDE.local.md
├── system-prompt/           # Claude Code system setup (37% of tokens)
│   ├── main-prompt.md       # Core Claude Code system prompt
│   └── tool-definitions.json # All 17 available tools with schemas
├── environment/             # Environment context (14% of tokens)
│   ├── context.txt          # Working directory, platform, model info
│   └── git-status.txt       # Git branch, commits, file status
└── conversation/            # User messages and system reminders (9% of tokens)
    ├── user-messages.txt    # The 3 user messages in this session
    └── system-reminders.txt # System-generated reminder messages
```

## Optimization Opportunities

### High Impact (40% reduction potential)

- **Context file loading**: CLAUDE.md files are loaded regardless of relevance
- **System prompt bloat**: Full tool definitions sent even for simple queries
- **Environment verbosity**: Git status and environment context always included

### Medium Impact (20% reduction potential)

- **System reminders**: Repetitive todo list updates and plan mode messages
- **Tool schema redundancy**: Complete JSON schemas for all tools

### Low Impact (5% reduction potential)

- **Conversation overhead**: User message formatting and system tags

## Token Sources Detail

### Context Files (8,000+ tokens)

- **Global CLAUDE.md**: ~3,000 tokens of user preferences and file operation
  rules
- **Project CLAUDE.md**: ~2,500 tokens of thread leak annotation instructions
- **Hamilton CLAUDE.md**: ~1,500 tokens of Hamilton pipeline documentation
- **Local CLAUDE.md**: ~1,000+ tokens of h_redo implementation project details

### System Prompt (8,000+ tokens)

- **Main prompt**: ~4,000 tokens of Claude Code behavioral instructions
- **Tool definitions**: ~4,000 tokens of 17 tool schemas with full parameter
  specs

### Environment (3,000+ tokens)

- **Git context**: Branch status, recent commits, file changes
- **System context**: Working directories, platform info, model details
- **Capability context**: Available tools, security constraints

### Conversation (2,000+ tokens)

- **User messages**: 3 messages with system tags and overrides
- **System reminders**: Plan mode, todo list updates, context loading
  notifications
