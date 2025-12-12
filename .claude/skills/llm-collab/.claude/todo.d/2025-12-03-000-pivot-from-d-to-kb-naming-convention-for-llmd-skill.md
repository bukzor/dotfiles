# Pivot from .d to .kb naming convention

**Priority:** Medium
**Complexity:** Medium
**Context:** Discussion in llm-collab-docs session 2025-12-03

## Problem Statement

`.d` suffix is too generic (used by systemd, cron, etc.) and doesn't trigger skill loading reliably. Need a selective, specific naming convention that:
1. Unambiguously identifies LLM-collaborative knowledge bases
2. Reads well in deeply nested paths
3. Reinforces helpful mental models for both human and assistant

## Decision

Use `.kb` (knowledge base) suffix:
- 3 chars, very selective
- Neutral ownership (not LLM-centric)
- Professional, recognized term
- Primes both parties for "structured for retrieval" interaction

## Scope

- Rename skill from `llm.d` to `llm.kb` (or just `kb`?)
- Update all references in documentation
- Update `references.kb/` to `references.kb/`
- Update skill load triggers to detect `.kb` directories
- Update schema validation invariant:
  - Upon finding `X.kb/` directory
  - Check for `X.jsonschema.yaml` sibling
  - If exists: all `X.kb/*.md` frontmatter must conform
  - Else: no such md may have frontmatter

## Implementation Steps

- [x] Decide final skill name (llm.kb vs kb) → **llm.kb**
- [x] Rename skill directory (llm.d → llm.kb)
- [x] Update SKILL.md frontmatter and content
- [x] Rename references.d/ to references.kb/ + subdirectories
- [x] Update all internal references (SKILL.md, todos)
- [ ] Update must-read-before triggers
- [ ] Update skeleton templates
- [ ] Test schema validation with new naming

## Open Questions

- [x] Should skill be named `llm.kb` or just `kb`? → **`llm.kb`** (2025-12-09)
- Should we support both `.d` and `.kb` during transition?

## Success Criteria

- [ ] `.kb` directories trigger skill loading
- [x] Schema validation works with new naming (bin/llm.kb-validate)
- [x] All docs updated consistently
