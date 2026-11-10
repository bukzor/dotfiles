# requires vs depends frontmatter semantics

**Date:** 2025-12-05
**Status:** Accepted

## Context

Claude ignored `depends:` declarations in the /commit command frontmatter,
treating them as informational metadata rather than mandatory prerequisites.

Observed failure (session db2681f2-3209-469c-8f49-fc7f3d641b6d):
- /commit command listed `depends:` on both git.md and git-commit.md
- Claude read only git-commit.md, skipping git.md
- This led to `git add .` violating index hygiene rules in the unread file
- Claude then attempted `git reset HEAD` which would have destroyed the index

The word "depends" describes a relationship but doesn't convey obligation.

## Decision

Introduce two frontmatter keywords with distinct semantics:

- `requires:` — **strict**, must read listed files before proceeding
- `depends:` — **informational**, related context that may be helpful

This acknowledges Claude's natural tendency to treat `depends:` as optional
while providing a stronger keyword for truly mandatory prerequisites.

## Alternatives Considered

### Rename depends: to requires: everywhere
- **Pros:** Simple, single keyword
- **Cons:** Loses the useful "related but optional" semantics

### Keep depends: only, add documentation
- **Pros:** No changes to existing files
- **Cons:** Doesn't address the semantic weakness that led to the failure

## Consequences

**Positive:**
- Clear distinction between mandatory and optional prerequisites
- Works with Claude's natural behavior rather than against it
- `requires:` signals obligation; `depends:` signals "FYI"

**Negative:**
- Two keywords to understand instead of one

**Neutral:**
- No enforcement mechanism; relies on Claude respecting `requires:`
- Existing `depends:` usages should be audited for which need `requires:`

## Related

- Extends: 2025-12-03-000-layered-git-instructions-with-depends.md
- Related to: git/ANY-git-command.md, git/commit.md, commands/commit.md
