---
description: Orient to the project -- read context, propose next-task priorities
argument-hint: "[taskfile or brief -- default: @.claude/todo.md]"
---

--- # workaround: anthropics/claude-code#13003
triggers:
  - read: Skill(llm-collab)
---

# Session Start

ARGUMENTS:

> $ARGUMENTS

Default arguments (if none provided):

> @.claude/todo.md, in order

## Background

- .claude/todo.md and .claude/todo.kb/\*.md are governed by the /llm-subtask skill
- todo.md is intended to be the prioritized listing of work remaining

## Workflow

1. Bash(date -Is)

2. **Identify the session.**

   If `$ARGUMENTS` is itself a sessions.kb entry: it is the session. Read
   it, then the plan or taskfile it names; skip the lookup below.

   If `$ARGUMENTS` resolves to another existing file (taskfile, plan, brief):
   - Read it; it is the primary brief.
   - Read any files listed under its frontmatter `requires:` before
     acting (and any transitive `requires:`).

   Otherwise (no argument, or argument is not a file path):
   - Look for a .claude/todo.md

   Unless skipped above: follow start-of-session directions in skill://llm-sessions

3. **Discover and read context files.**
   ```
   Bash(find . -xtype f -name '*.md' \( -path '*/.claude/todo*' -o -path '*/devlog/*' -o -path '*/adr/*' \))
   ```
   Read or skim each.
4. **Synthesize** what you found into a brief status summary. Include an ordered listing of next-task priorities.
5. **Continue** if your confidence (that user will agree with your inference) is >95%.

## Output Format

Concise summary of project state and active work. No bullet lists of filenames.
