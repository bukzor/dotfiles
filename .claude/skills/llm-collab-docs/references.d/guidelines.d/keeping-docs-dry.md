# Keeping Docs DRY (Tiered Detail)

**Hierarchy of detail:**
1. CLAUDE.md: 1-2 sentence summary + link
2. Main doc: 1 paragraph + link to subdirectory
3. Subdirectory doc: Full details

**Example:**
```markdown
# CLAUDE.md
Plumbing tools use JSONL for stdin/stdout. See [technical-design.md#data-format].

# technical-design.md
## Data Format
Plumbing tools communicate via JSONL (one JSON object per line). This enables:
- Streaming processing
- Easy composition with jq
- Future capnproto migration

See [technical-design/jsonl-format.md] for schema details.

# technical-design/jsonl-format.md
## JSONL Format Specification
[Full schema, examples, edge cases, 200+ lines]
```

**Never duplicate content across files.** Summarize and link instead.
