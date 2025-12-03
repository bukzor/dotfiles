# Pivot from .d to .kb naming convention

**Date:** 2025-12-03
**Status:** Proposed

## Context

The `.d` suffix for structured knowledge directories is too generic. It's used by:
- systemd (`.conf.d/`)
- cron (`cron.d/`)
- Many other Unix tools

This makes `.d` non-selective as a trigger for loading the llm.d skill. We need a naming convention that:
1. Unambiguously identifies LLM-collaborative knowledge bases
2. Reads well in deeply nested paths
3. Reinforces helpful mental models for both human and assistant

## Decision

Use `.kb` (knowledge base) suffix:

```
refs.kb/
├── file-types.kb/
│   ├── ADRs.md
│   └── devlog.md
├── file-types.jsonschema.yaml
└── guidelines.kb/
    └── linking.md
```

Invariant: Upon finding `X.kb/` directory, check for `X.jsonschema.yaml` sibling:
- If exists: all `X.kb/*.md` frontmatter must conform
- Else: no such md may have frontmatter

## Alternatives Considered

### `@X/` prefix
- **Pros:** Very terse (1 char), visually distinctive
- **Cons:** Unusual for directories, slight shell quoting concerns

### `.hive/` suffix
- **Pros:** Evokes collective intelligence metaphor
- **Cons:** 5 chars, less conventional

### `.llm` suffix
- **Pros:** Clear meaning
- **Cons:** Implies LLM ownership; we want 50/50 human/assistant collaboration

## Consequences

**Positive:**
- Selective: `.kb` is not used by other tools
- Short: 3 chars including dot
- Neutral ownership: "knowledge base" is collaborative
- Reinforces mental model: structured for retrieval

**Negative:**
- Requires renaming existing `.d` directories
- Skill rename from `llm.d` to `llm.kb` (or just `kb`)

**Neutral:**
- Schema validation invariant unchanged, just different directory suffix
