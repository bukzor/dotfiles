# Lazy-Loaded MCP Servers

MCP servers can be enabled per-project to save token overhead (~500-800 tokens per server).

## Usage

When a project needs an MCP server, create/edit `.mcp.json` in the project root:

```json
{
  "mcpServers": {
    "server-name": {
      "type": "stdio",
      "command": "command-name",
      "args": [],
      "env": {}
    }
  }
}
```

Then tell the user: "I've enabled [server-name] MCP tools for this project. Please restart this Claude session for the changes to take effect."

## Per-Server Configuration

See specific must-read.kb/before files for server-specific configuration details (e.g., rust-programming.md for rust-analyzer).
