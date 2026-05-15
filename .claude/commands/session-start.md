--- # workaround: anthropics/claude-code#13003
depends:
  - Skill(llm-collab)
---

# Session Start

ARGUMENTS: $ARGUMENTS

Default (no arguments): orient by heuristic matching only.

## Workflow

1. Bash(date -Is)

2. **Identify the session.**

   If `$ARGUMENTS` resolves to an existing file (taskfile, plan, brief):
   - Read it; it is the primary brief.
   - Read any files listed under its frontmatter `requires:` before
     acting.
   - Grep `~/.claude/sessions.kb/*.md` for the file's basename.
     - 1 match: read that entry; continue the session.
     - 0 matches: create a new entry following
       `~/.claude/sessions.kb/.template.md` (substitute the
       `$(...)` placeholders). Filename: a kebab-case slug
       describing the work; prefer exact match with the taskfile's
       slug (strip `CLAUDE.`/`.Task.`/`.md` affixes) — exact-match
       ids across files with the same referent make
       cross-reference cheap.
     - 2+ matches: ask the user which to use.

   Otherwise (no argument, or argument is not a file path):
   - Look for an existing sessions.kb entry. Search recipes:
     - `grep -rl "uuid: $CLAUDE_CODE_SESSION_ID" ~/.claude/sessions.kb/`
     - `grep -rl "^cwd: $PWD" ~/.claude/sessions.kb/`
     - Or scan filenames for topic match.
     If found, read it and any files listed under `focus:`.
   - Consider creating a new entry (same template) when any apply:
     - Complex or nuanced task
     - Will take more than a couple hours
     - Has already been more than a day
     - Context already > 100k tokens (plan a separate session)

   See `~/.claude/sessions.kb/CLAUDE.md` for what belongs.
3. **Discover and read context files.**
   ```
   Bash(find . -xtype f -name '*.md' \( -path '*/.claude/todo*' -o -path '*/devlog/*' -o -path '*/adr/*' \))
   ```
   Read or skim each.
4. **Synthesize** what you found into a brief status summary.

## Output Format

Concise summary of project state and active work. No bullet lists of filenames.
