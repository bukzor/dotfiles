# Separate user-facing and developer-facing documentation

**Date:** 2025-12-11
**Status:** Accepted

## Context

Projects accumulate documentation serving two distinct audiences:
- **Users:** Need installation guides, usage examples, API references for using the software
- **Developers:** Need design rationale, architecture docs, ADRs, devlogs, technical internals

When both types live at the same level in `docs/`, the structure becomes unclear:
- Users encounter implementation details they don't need (ADRs, devlogs, design.kb/)
- Developers wade through user-facing content to find technical docs
- Agents can't easily target the right documentation for the task
- The organizing principle isn't explicit, leading to inconsistent placement

The skeleton and references already reference `docs/dev/` for some content but never explain the distinction.

## Decision

**Reserve `docs/` for user-facing documentation, place developer documentation under `docs/dev/`.**

**User-facing (`docs/`):**
- `examples/` - Usage recipes, tutorials
- API documentation (when applicable)
- User guides, how-to docs

**Developer-facing (`docs/dev/`):**
- `adr/` - Architecture Decision Records
- `devlog/` - Development session history
- `design.kb/` - Design knowledge (constraints, patterns, choices)
- `milestones.kb/` - Project milestones and phases
- Technical design documents, architecture internals

**Migration strategy:**
- Helper scripts (llm-collab-adr, llm-collab-devlog) auto-migrate old `docs/adr/` to `docs/dev/adr/` on first use
- Try `git mv` first (for tracked files), fall back to `mv` for untracked/non-git projects
- Error if both old and new locations exist (manual resolution required)

## Alternatives Considered

### Flat `docs/` with all content
- **Pros:** Simpler structure, fewer directories
- **Cons:** Mixes audiences, unclear what belongs where, scales poorly
- **Rejected:** Already experiencing confusion with this approach

### Separate top-level directories (`dev-docs/`, `internal/`)
- **Pros:** Very clear separation, no nesting
- **Cons:** Breaks convention (most projects use `docs/`), harder to reserve `docs/` for users if some docs are elsewhere
- **Rejected:** Unconventional, doesn't clearly signal `docs/` is for users

### Audience-based subdirectories (`docs/users/`, `docs/developers/`)
- **Pros:** Explicit audience labeling
- **Cons:** Redundant naming ("`docs/users/`" → just "`docs/`"), `docs/developers/` is verbose
- **Rejected:** `docs/dev/` is shorter, convention-aligned

## Consequences

**Positive:**
- Clear organizing principle: "Is this for users or developers?"
- Users find what they need without wading through internals
- Agents can be directed to appropriate documentation subset
- Skeleton now has explicit guidance for where docs belong
- Helper scripts enforce structure automatically

**Negative:**
- Migration required for existing projects (mitigated by auto-migration in scripts)
- One additional level of nesting for developer docs

**Neutral:**
- File paths change (docs/adr/ → docs/dev/adr/)
- References need updating during migration

## Related

- Related to: [2025-12-02-002-skeleton-directory-pattern-for-file-templates.md](2025-12-02-002-skeleton-directory-pattern-for-file-templates.md) - Skeleton provides templates
- Implements: Pattern established in git-partial.prototyping project
