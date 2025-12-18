<anthropic-skill-ownership llm-subtask />

# Complete Entangled Commit Separation for Naming Refactor

**Priority:** High
**Complexity:** Medium
**Context:** Session doing naming refactor found 3 entangled lines of work

## Problem Statement

Three lines of work in llm-collab/ are entangled at the line level:
1. Heredoc→skeleton refactor (other agent)
2. Ideas.d pattern (other agent)
3. Naming refactor (this session)

Need to commit each separately in correct order.

## Current Situation

- Commit 1 (heredoc) DONE: `a52bbe9`
- Backup files in `~/tmp/commit-surgery/`: llm-collab-adr, llm-collab-init, todo.md, SKILL.md
- Remaining commits need surgery to separate

## Implementation Steps

- [x] Copy entangled files to ~/tmp/commit-surgery/
- [x] Commit 1: heredoc refactor (bin scripts were clean, no surgery needed)
- [ ] Commit 2: ideas.d pattern
  - Files: SKILL.md (ideas section), skeleton/.claude/ideas.d/, bin/llm-collab-idea
  - OPEN: should ideas.d → ideas.kb? (consistency with .kb naming)
- [ ] Commit 3: naming refactor
  - Pervasive changes across all skills
  - Restore from ~/tmp/commit-surgery/ after commit 2
- [ ] Cleanup ~/tmp/commit-surgery/

## Open Questions

- Should `ideas.d/` become `ideas.kb/` for consistency with the .kb naming convention?
- The llm-collab skill uses `.d` for references.d/, ideas.d/ — should these all become `.kb`?

## Success Criteria

- [ ] Three clean commits in order: heredoc → ideas → naming
- [ ] No entangled changes between commits
- [ ] ~/tmp/commit-surgery/ cleaned up

## Notes

Commit order rationale: localized work first (heredoc, ideas), pervasive work last (naming).
Naming as final commit naturally picks up correct final state.
