# Layered Git Instructions with Depends Frontmatter

**Date:** 2025-12-03
**Status:** Accepted

## Context

Git-related instructions were spread across three files with overlapping content:

- `must-read.d/before/using-git-commit.md` -- commit basics, amend safety
- `must-read.d/before/git-operations.md` -- repo targeting, path scoping, index hygiene
- `commands/commit.md` -- comprehensive commit workflow including all of the above

This created:
- Redundancy requiring multi-file updates
- Unclear precedence when content conflicted
- Eager loading of commit-specific content for non-commit git operations

## Decision

Refactor into layered structure with explicit dependencies:

```
must-read.d/before/git.md          # Universal git principles
must-read.d/before/git-commit.md   # Commit-specific (depends: ./git.md)
commands/commit.md                 # Workflow only (depends: both above)
```

Dependencies declared via YAML frontmatter:
```yaml
---
depends:
  - ./git.md
---
```

The `depends:` convention is self-documenting -- no additional documentation needed to explain that dependencies should be read first.

## Alternatives Considered

### Single comprehensive file
- **Pros:** No dependency resolution needed, single source of truth
- **Cons:** Eager loading of commit-specific content for all git operations

### Keep redundant structure with DRY extraction
- **Pros:** No behavior change
- **Cons:** Three files remain, just smaller; still unclear which to read

### Explicit documentation of depends convention
- **Pros:** Leaves nothing to interpretation
- **Cons:** Over-specification; `depends:` is self-explanatory

## Consequences

**Positive:**
- DRY: principles defined once, referenced where needed
- Lazy loading: commit-specific content only loaded for commits
- Clear hierarchy: universal -> commit-specific -> workflow
- Explicit references in workflow steps ("see git-commit.md") reinforce dependencies

**Negative:**
- Relies on Claude interpreting `depends:` frontmatter correctly
- Workflow file is thin -- fails silently if dependencies not read

**Neutral:**
- must-read.d/before/ scan still includes git-commit.md in listing (low cost)

## Related

- Supersedes: using-git-commit.md, git-operations.md
- Related to: commands/commit.md workflow
