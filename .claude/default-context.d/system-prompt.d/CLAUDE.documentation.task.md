# System Prompt Documentation Task

Extract system prompt sections to fill stub files.

## Key Requirements

1. **Source**: Use system prompt from conversation start (NOT files on disk)
2. **Find section**: Use `BOUNDARY_MARKER` comments in target file 
3. **XML escaping**: Replace `<tag>` with `{tag}`
4. **Replace**: `[STUB - ...]` → extracted content

## Example

For `01-identity-and-purpose.md`:
- Read boundary marker: `"You are Claude Code" through "IMPORTANT: Assist"`  
- Find that section in conversation's system prompt
- Escape XML tags, replace stub