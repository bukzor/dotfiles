# Claude Code Startup Token Cost Optimization

## Problem

Claude Code loads all function definitions into the system prompt at startup, which can consume significant tokens. Some tools have extremely verbose documentation that adds unnecessary startup cost:

- TodoWrite: 143 lines / ~9k characters
- Task: 51 lines / ~3.6k characters  
- Bash: 112 lines / ~7.8k characters
- MultiEdit: 42 lines / ~2.5k characters

These descriptions are loaded on every session regardless of whether the tools are used.

## Solution: Custom Tool Overrides

**Discovery**: Custom tools in `.claude/tools/` completely override built-in tools with the same name, eliminating the verbose function definitions from `<functions>` while preserving full functionality.

### Implementation

1. **Create minimal override** in `.claude/tools/[ToolName].json`:
```json
{
  "name": "TodoWrite",
  "description": "Minimal override - manages todo lists", 
  "parameters": {
    "type": "object",
    "properties": {
      "todos": {
        "type": "array",
        "description": "Todo items"
      }
    },
    "required": ["todos"]
  }
}
```

2. **Results**:
   - ✅ Verbose built-in description completely removed from `<functions>`
   - ✅ Underlying tool implementation works perfectly
   - ✅ Massive token savings (9k → 100 characters for TodoWrite)
   - ✅ Zero functionality loss

### Trade-offs

**Pros**:
- Dramatic startup token cost reduction
- Full tool functionality preserved
- Easy to implement

**Cons**: 
- Fresh Claude sessions may struggle to use tools properly without the detailed documentation
- Must maintain minimal schemas that don't break the underlying implementation
- Loses helpful usage examples and guidelines

### Recommended Targets

Tools with high documentation-to-complexity ratios:
1. **TodoWrite** - 143 lines for task management
2. **Task** - 51 lines with extensive examples  
3. **MultiEdit** - 42 lines for "multiple Edit operations"

**Don't override**:
- **Bash** - Complexity justifies the documentation
- **Read/Write/Edit** - Core tools with reasonable descriptions

### Testing

Verified that TodoWrite override works perfectly:
- Minimal schema in `<functions>`
- Full object structure (`id`, `content`, `status`) still accepted
- Proper todo list management functionality intact

## Usage Pattern

For each verbose tool:
1. Analyze if documentation length is justified by complexity
2. Create minimal `.claude/tools/[Name].json` with essential schema only
3. Test that underlying functionality still works
4. Monitor for any breakage in tool usage