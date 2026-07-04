---
requires:
  - ~/.claude/design-rules.kb/inline-trivial-wrappers.md
  - ~/.claude/design-rules.kb/comments-target-a-cold-reader.md
  - ~/.claude/design-rules.kb/double-dash-not-emdash.md
  - ~/.claude/reference.kb/bulk-edits.md
---

# Development Workflow

When completing tasks that involve code changes:

1. Find relevant docs for the area you're changing
   - Architecture docs, ADRs, README
   - If (CLAUDE.md depends on) `Skill(llm-subtask)`: todo files
   - If `Skill(llm-collab)`: recent devlog

2. If docs need updating, do that first
   - Smaller changes, easier to discuss, surfaces course corrections early
   - if `Skill(llm-collab)`: consider if changes warrant an ADR

3. Make code changes

4. Test changes

5. Commit — please read `./git/commit.md` for pre-commit checklist

6. Move to next task

Never skip ahead to the next task before completing all steps for the current task.
