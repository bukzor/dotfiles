# Mutation file format

**Date:** 2025-12-15
**Status:** Accepted

## Context

Mutation tracking files in `mutation-testing.kb/` need structure for both human and LLM consumption. Format evolved through use in git-partial.prototyping project.

## Decision

Frontmatter:
```yaml
status: todo | done | gap
attempts: N  # required for gap
```

Body sections:
- Description paragraph (what the bug causes)
- `## Injection` (specific code change)
- `## Test Coverage` (done: which tests catch it)
- `## Test Result` (gap: why tests couldn't catch it)

## Alternatives Considered

### Minimal frontmatter only
- **Pros:** Simpler
- **Cons:** Loses context about what was tried, which tests catch it

### Structured YAML throughout
- **Pros:** Machine-parseable
- **Cons:** Harder to write, less natural for explanations

## Consequences

**Positive:**
- `attempts` tracks effort before gap
- Body sections guide documentation
- Format matches observed real-world usage

**Negative:**
- More structure to learn

**Neutral:**
- Schema validates frontmatter only, body is freeform

## Related

- Related to: tdd-posthoc.md Tracking section
- Related to: git-partial.prototyping/docs/dev/mutation-testing.kb/
