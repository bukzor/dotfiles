# Cross-skill referencing via load pattern

**Date:** 2025-12-02
**Status:** Accepted

## Context

Skills often have related concerns that overlap. For example:
- The llm-collab-docs skill defines devlog structure
- The subtask skill manages task tracking that integrates with devlogs

When skills need to reference each other's domains, they can either:
1. Duplicate the content (causing drift and maintenance burden)
2. Reference the other skill's documentation

## Decision

Skills reference each other using the "load X skill" pattern:

```markdown
**For devlog structure and conventions**, load the llm-collab-docs skill.
```

This pattern:
- Names the authoritative skill explicitly
- Uses "load" verb matching Claude Code's skill invocation
- Provides enough context for the user to understand why

**Reciprocal references:** Both skills should reference each other at their integration points. For example:
- subtask skill: "For devlog conventions, load llm-collab-docs skill"
- llm-collab-docs devlog section: "For task tracking, use the subtask skill"

## Alternatives Considered

### Direct file path links
```markdown
See ~/.claude/skills/subtask/SKILL.md for task tracking.
```
- **Pros:** Direct, works without skill system
- **Cons:** Brittle paths, bypasses skill loading, doesn't trigger skill context

### Inline duplication
Copy relevant content from other skill.
- **Pros:** Self-contained, no dependencies
- **Cons:** Content drift, maintenance burden, increases file size

### Abstract interface
Define shared interface both skills implement.
- **Pros:** Clean separation
- **Cons:** Over-engineering for documentation, requires coordination

## Consequences

**Positive:**
- Single source of truth for each domain
- Explicit ownership boundaries
- Users learn to load skills for specific concerns

**Negative:**
- Requires skill to be loaded for full context
- Cross-skill dependencies less obvious without reading

**Neutral:**
- Establishes pattern for future skill interactions

## Related

- Related to: Skill ownership header convention
- Related to: Task/devlog separation (tasks = forward-looking, devlogs = historical)
