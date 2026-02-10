# Documentation Anti-Patterns

## Don't Do This

**Redundant duplication:**
```markdown
# CLAUDE.md
Plumbing tools use JSONL. One object per line. This enables streaming...
[30 lines of explanation]

# docs/dev/design/050-components.kb/plumbing.md
[Exact same 30 lines]
```

**Broken links with no context:**
```markdown
See [this](design.md)
```

**Hidden information:**
```markdown
# README.md
This project does things. See docs/ for more.
[No indication of what things or where to start]
```

**Stale documentation:**
```markdown
# .claude/todo.md
- [x] Task completed 6 months ago (still marked as pending)
[Never updated]
```

**Design docs in wrong place:**
```python
# Some random .py file
# DESIGN NOTE: We chose this approach because of X, Y, Z considerations
# and evaluated alternatives A, B, C before deciding...
[300 line comment that should be in docs/dev/design/ or an ADR]
```

## Do This Instead

**Tiered detail:**
```markdown
# CLAUDE.md
Plumbing uses JSONL (one object/line) for streaming and jq compatibility.
See [design](docs/dev/design/).

# docs/dev/design/050-components.kb/plumbing.md
## JSONL Format
One JSON object per line enables streaming, composition, future migration.
```

**Contextual links:**
```markdown
See [caching component](docs/dev/design/050-components.kb/caching.md) for lazy-loading.
```

**Progressive disclosure:**
```markdown
# README.md
claifs provides lazy filesystem access to claude.ai conversations.

**Status:** Alpha (not ready for use)

Install: [Quick steps]
Usage: [Basic example]

For development: See [HACKING.md]
For architecture: See [docs/dev/design/]
```

**Extracted design docs:**
```python
# In code:
# Data format: See docs/dev/technical-design/jsonl-format.md
def parse_jsonl(line):
    ...
```
