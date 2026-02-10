<anthropic-skill-ownership llm-subtask />

---
required-reading:
  - ~/.claude/skills/llm.kb/references/schema-design.md
  - ~/.claude/skills/llm.kb/lib/python/llmd/frontmatter_validate.py
suggested-reading:
  - https://json-schema.org/understanding-json-schema/structuring.html
related-effort: ~/.claude/skills/llm-collab/.claude/todo.kb/2026-02-09-000-design-kb-pattern-for-living-design-docs.md
---

# Schema Reuse with $ref

**Priority:** Medium
**Complexity:** Medium
**Context:** Emerged from design.kb pattern work; needed for shared `why[]` field across abstraction levels

## Problem Statement

llm.kb lacks support for reusable schema definitions. Projects with multiple `.kb/` directories that share common fields (e.g., `why[]` for traceability) must duplicate schema definitions. This causes:
1. Inconsistency risk when updating shared fields
2. Verbose schemas
3. No single source of truth for cross-cutting frontmatter

## Current Situation

- `references/schema-design.md` covers `oneOf`, constraints, evolution — no `$ref`
- `frontmatter_validate.py` does basic validation, doesn't resolve `$ref`
- `complete-example/` shows duplication (status+budget in both decorations and food schemas)
- No documented pattern for shared schema directory

## Proposed Solution

### Directory Pattern

Place shared schemas at a level encompassing all usages:

```
docs/dev/
├── jsonschema/
│   └── common.yaml           # Shared definitions
├── design/
│   ├── 020-goals.jsonschema.yaml    # $ref: ../jsonschema/common.yaml
│   └── 030-requirements.jsonschema.yaml
└── technical-policy.jsonschema.yaml  # $ref: jsonschema/common.yaml
```

### Schema Structure

```yaml
# jsonschema/common.yaml
$schema: "http://json-schema.org/draft-07/schema#"
definitions:
  why:
    description: Links to parent items in abstraction stack
    type: array
    items:
      type: string
```

```yaml
# design/020-goals.jsonschema.yaml
$schema: "http://json-schema.org/draft-07/schema#"
type: object
properties:
  why:
    $ref: "../jsonschema/common.yaml#/definitions/why"
```

### Tool Compatibility

Design for yaml-language-server compatibility:
- File-relative `$ref` paths
- Standard Draft-07 `$schema`
- Inline directive support: `# yaml-language-server: $schema=...`

## Implementation Steps

### Documentation

- [ ] Add `references/schema-reuse.md` covering:
  - `$ref` syntax and file-relative paths
  - `definitions` block for reusable fragments
  - Directory placement pattern (`jsonschema/` at encompassing level)
  - yaml-language-server compatibility
- [ ] Update `references/schema-design.md` to reference new doc
- [ ] Add cross-reference in SKILL.md references section

### Validator Enhancement

- [ ] Add `$ref` resolution to `frontmatter_validate.py`
  - Resolve file-relative paths
  - Support `#/definitions/...` fragment syntax
  - Cache loaded schemas to avoid re-parsing
- [ ] Add tests for `$ref` resolution
- [ ] Handle circular reference detection (or document as unsupported)

### Example Update

- [ ] Refactor `complete-example/` to demonstrate schema reuse
  - Extract shared `status`+`budget` to common schema
  - Update food and decorations schemas to use `$ref`

## Open Questions

- Should validator support remote `$ref` (http URLs) or only file-relative?
- How to handle `$ref` in `oneOf` blocks?
- Should we support `allOf` for schema composition?

## Success Criteria

- [ ] `references/schema-reuse.md` exists and is comprehensive
- [ ] Validator resolves file-relative `$ref`
- [ ] `complete-example/` demonstrates the pattern
- [ ] yaml-language-server works with the pattern (manual verification)
