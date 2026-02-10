# Devlog: 2026-02-09 — Design Knowledge Pattern Development

## Focus

Design and validate a living design documentation pattern for llm-collab, replacing
the removed static templates (design-rationale.md, technical-design.md, development-plan.md).

## Decisions

### Numbered abstraction levels with OKR framing

**Rationale:** Five-whys framework gives natural hierarchy. OKR terminology (objectives/key results)
is well-known and clarifies goals vs requirements distinction.

**Structure:**
- 010-mission.kb/ → 020-goals.kb/ → 030-requirements.kb/ → 040-design.kb/ → 050-components.kb/ → 060-deliverables.kb/
- background.kb/ outside the chain (foundational context)
- technical-policy.kb/ cross-cutting (means, not ends)

### Requirements as acceptance criteria

**Rationale:** Initial experiments produced technical implementation choices in requirements.
Reframing as "verifiable by end-users" and "acceptance criteria" fixed this.

**Key test:** Could a stakeholder verify this without reading code?

### Minimal skeleton, authoritative pattern doc

**Rationale:** Avoid stale templates. Skeleton creates breadcrumb CLAUDE.md files that
point to the pattern doc. Pattern doc is single source of truth.

### Remove examples from pattern doc

**Rationale:** Project-specific examples biased agents toward copying rather than thinking.
Removing examples forced agents to synthesize from principles.

## Conventions Established

- why[] frontmatter links each item to its parent level
- Each .kb/ directory gets its own CLAUDE.md explaining what belongs there
- Requirements must trace to goals; if they don't, they're probably policies
- Pause after each layer when creating design "from whole cloth" for user review

## Validation

Three rounds of agent experiments on sttt-engine:
- Round 1: Flat files, no structure (pattern doc not followed)
- Round 2: Structure correct, but requirements were technical choices
- Round 3: Full correct implementation after OKR/acceptance criteria refinements

## Completion

Freshness hooks added:
- session-end.md: key question about design.kb freshness
- llm-collab-adr: reminder when docs/dev/design/ exists

## References

- todo.kb/2026-02-09-000 — the tracking item for this work
- ChatGPT conversation on sttt-engine — source of concrete test material
- Diátaxis framework — informed doc type distinctions
- Five-whys / OKR — informed level structure
