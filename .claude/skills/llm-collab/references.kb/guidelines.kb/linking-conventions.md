# Linking Conventions

**Always provide context when linking:**
```markdown
Bad:  See [design](docs/dev/design/)
Good: See [design](docs/dev/design/) for data flow details
```

**Use relative links:**
```markdown
From CLAUDE.md: [devlog](docs/dev/devlog/2025-01-30.md)
From devlog:    [caching](../design/050-components.kb/caching.md)
```

**Link to specific sections when possible:**
```markdown
See [caching component](docs/dev/design/050-components.kb/caching.md) for lazy-loading.
```
