--- # workaround: anthropics/claude-code#13003
depends:
  - skills/llm-collab
---

# Session Start

Orient to the current project by reading key context files.

## Workflow

1. Bash(date -Is)
2. **Find** context files:
   - TODOs:
    - tactical: `**/.claude/todo*.md`
    - strategic: `**/.claude/todo*/**/*.md`
   - Devlogs: `**/devlog/**/*.md`
   - ADRs: `**/adr/**/*.md`
   - All at once:
     ```
     Bash(find . -xtype f -name '*.md' \( -path '*/.claude/todo*' -o -path '*/devlog/*' -o -path '*/adr/*' \))
     ```
3. **Read and Skim** to build up context
4. **Synthesize** what you found into a brief status summary

## Output Format

Concise summary of project state and active work. No bullet lists of filenames.
