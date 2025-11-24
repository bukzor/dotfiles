# Rust Programming

## MCP Tools

The rust-analyzer MCP server is lazy-loaded. See `~/.claude/must-read-before.d/lazy-loading/mcp.md`

Configuration for `.mcp.json`:

```json
{
  "mcpServers": {
    "rust-analyzer": {
      "type": "stdio",
      "command": "rust-analyzer-mcp",
      "args": [],
      "env": {}
    }
  }
}
```
