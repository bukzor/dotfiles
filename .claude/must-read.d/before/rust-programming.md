# Rust Programming

## Design Rules

See `~/.claude/design-rules.kb/rust.kb/` for Rust-specific API design principles,
and `~/.claude/design-rules.kb/` for language-agnostic rules.

## Dependencies

Use `cargo add` (not manual Cargo.toml edits) to add dependencies:

```bash
cargo add serde -p my-crate          # regular dependency
cargo add --dev tempfile -p my-crate  # dev-dependency
```

## Documentation Lookup

For Rust API questions, use `rustdoc-json` to fetch docs.rs JSON:

```bash
rustdoc-json CRATE [VERSION]   # outputs path to cached JSON
```

Then query with jq:

```bash
# Find item by name
jq '.index | to_entries[] | select(.value.name == "Index")' "$(rustdoc-json git2)"

# Get docs for all "write" methods
jq -r '.index | to_entries[] | select(.value.name == "write") | .value.docs // empty' "$(rustdoc-json git2)"
```

Cache: `~/.cache/rustdoc-json/`

## MCP Tools

The rust-analyzer MCP server is lazy-loaded. See `~/.claude/must-read.d/before/lazy-loading/mcp.md`

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
