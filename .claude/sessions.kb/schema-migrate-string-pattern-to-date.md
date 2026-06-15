---
cwd: /home/bukzor/repo/github.com/bukzor/bukzor-agent-skills/llm-kb
session:
  started: null
  ended: null
---
# Migrate date schemas to the new `date` / `instant` types

Commit 5d64413 added `type: date` and `type: instant` to KbValidator.
Existing `type: string` + pattern workarounds for date fields can now
be tightened.

## Files

- `SKILL.jsonschema.yaml` -- `last-updated` (currently `type: string`
  + pattern `^\d{4}-\d{2}-\d{2}$`)
- `docs/dev/case-studies.jsonschema.yaml` -- `date` (same pattern)

## Caveat

Quoted-string entries in the corpus (e.g., `last-updated: "2026-05-13"`)
will fail under `type: date` -- YAML parses them as strings, not dates.
Either:

1. Unquote the corpus entries first, then tighten the schema, or
2. Use `type: [date, string]` + pattern as a transitional compromise.

Option 2 keeps the corpus working but defers full migration; it is the
lower-risk path if there is no immediate need to enforce the type.

## Reference

`lib/python/llmd/frontmatter_validate.py` (KbValidator definition,
including the rationale for rejecting naive datetime).
