# Skill ownership header convention

**Date:** 2025-12-02
**Status:** Accepted

## Context

When documentation and configuration files are managed by Claude Code skills, there's potential for confusion about which skill owns which file. This becomes a "split-brain" problem when:
- Multiple skills could plausibly manage a file
- Users read documentation that doesn't indicate its source
- Agents make edits without knowing the authoritative skill

## Decision

Files managed by skills include an XML ownership header at the top:

```xml
<anthropic-skill-ownership subtask />
```

Where `subtask` is replaced with the owning skill name.

**Placement:** First line of file, before any content.

**Format:** XML chosen for:
- Unambiguous, parseable syntax
- Self-closing tag is minimal
- Works in markdown, comments, anywhere
- Extensible if needed (e.g., `<anthropic-skill-ownership subtask version="1.0" />`)

## Alternatives Considered

### Markdown comment
```markdown
<!-- Managed by subtask skill -->
```
- **Pros:** Familiar syntax, invisible in rendered markdown
- **Cons:** Not parseable, varies by file type, easy to confuse with regular comments

### YAML frontmatter
```yaml
---
skill: subtask
---
```
- **Pros:** Standard in many tools
- **Cons:** Only works in markdown, verbose, conflicts with other frontmatter uses

### Filename convention
```
.subtask-managed/todo.md
```
- **Pros:** Visible in filesystem
- **Cons:** Changes file paths, awkward nested directories

## Consequences

**Positive:**
- Clear ownership signaling across all file types
- Machine-parseable for tooling
- Agent can immediately identify authoritative skill for a file

**Negative:**
- Slightly verbose header line
- Requires all skeleton templates to include header

**Neutral:**
- Establishes precedent for skill-level metadata in files

## Related

- Related to: skeleton/ directory pattern for file templates
- Related to: Cross-skill referencing via "load X skill" pattern
