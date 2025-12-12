# ADR: CLAUDE.d/ Pattern for Idempotent Extensions

## Status

Accepted

## Context

When adding llm.d to a project, we need to update CLAUDE.md to bootstrap future
agents. The naive approach (`cat >>CLAUDE.md`) isn't idempotent -- running twice
duplicates content.

## Decision

Apply the `.d/` pattern to CLAUDE.md itself:

1. CLAUDE.md contains a directive: `## CLAUDE.d/` with `tail -n9999 CLAUDE.d/**/*.md`
2. Extensions create/overwrite files in `CLAUDE.d/` (e.g., `CLAUDE.d/llm-d.md`)
3. File overwrite is idempotent; directive is append-once

## Consequences

**Positive:**
- Idempotent updates via file overwrite
- Composable -- multiple skills can coexist in CLAUDE.d/
- Dogfooding -- uses the pattern we're teaching
- Multi-agent discovery via `requires:` frontmatter in CLAUDE.d/*.md

**Negative:**
- Two-step process: ensure directive exists, then create file
- Agents must run the tail command to get full context

## Alternatives Considered

- `cat >>CLAUDE.md`: Not idempotent
- `grep -q || cat >>`: Fragile pattern matching
- Subdirectory for knowledge base: Doesn't solve CLAUDE.md update problem
