---
cwd: /home/bukzor/repo/github.com/bukzor/bukzor-agent-skills/llm-kb
session:
  started: null
  ended: null
---
# Rename rollup: doc-level .d/ -> .kb/ references

Finish the migration started in commits 5d64413, 799eb02, d59458b
(2026-05-15). Directory renames are done; doc-level mentions remain.

## Scope

- references/pattern-guide.md (8 mentions; line 5 "Unix `.d/`" historical
  analogy stays)
- references/splitting-large-docs.md (5 mentions; title plus body)
- docs/documentation-conventions.md (1 mention, line 10 in code block)
- Flip docs/adr/2025-12-03-000-pivot-from-d-to-kb-naming-convention.md
  status from "Proposed" to "Accepted"

## Tracker

`.claude/todo.kb/2026-01-02-000-complete-d-to-kb-rename.md`

## Caution

`references/pattern-guide.md` and `references/splitting-large-docs.md`
have pre-existing de-bolding modifications in the working tree from
another in-flight session. Coordinate with `finish-debolding-cleanup`
before touching those files.
