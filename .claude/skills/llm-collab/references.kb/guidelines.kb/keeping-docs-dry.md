# Keeping Docs DRY (Tiered Detail)

**Hierarchy of detail:**
1. CLAUDE.md: 1-2 sentence summary + link
2. Design layer: 1 paragraph per entry
3. Component docs: Full details

**Example:**
```markdown
# CLAUDE.md
Plumbing tools use JSONL for stdin/stdout. See [design](docs/dev/design/).

# docs/dev/design/040-design.kb/data-format.md
Plumbing tools communicate via JSONL (one JSON object per line). This enables:
- Streaming processing
- Easy composition with jq
- Future capnproto migration

# docs/dev/design/050-components.kb/jsonl-parser.md
## JSONL Parser
[Full schema, examples, edge cases, 200+ lines]
```

**Never duplicate content across files.** Summarize and link instead.
