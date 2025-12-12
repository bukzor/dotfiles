# Linking Conventions

**Always provide context when linking:**
```markdown
Bad:  See [technical-design.md](docs/dev/technical-design.md)
Good: See [technical-design.md](docs/dev/technical-design.md) for data flow details
```

**Use relative links:**
```markdown
From CLAUDE.md: [devlog](docs/dev/devlog/2025-01-30.md)
From devlog:    [design](../technical-design.md#caching)
```

**Link to specific sections when possible:**
```markdown
See [caching strategy](technical-design/caching.md) for lazy-loading implementation.
```
