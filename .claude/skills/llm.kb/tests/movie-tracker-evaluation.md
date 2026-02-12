# Evaluation: Movie Tracker

Tests llm.kb pattern compliance and multi-agent handoff.

Before trusting PASS/FAIL output, verify the test script checks the criteria below.

## Run

```bash
./test
```

## kb-writer: Create Knowledge Base

Pass if agent follows SKILL.md patterns. Key signals:
- Creates `.kb/` directory structure (e.g., `movies.kb/`)
- Root CLAUDE.md has `requires: Skill(llm.kb)` frontmatter
- Category CLAUDE.md explains what belongs (not enumeration)
- Individual movie files in the `.kb/` directory

## kb-reader: Multi-Agent Handoff

Pass if a fresh agent can answer "What sci-fi movies have I watched?" using the
knowledge base. The agent must:
- Discover the `.kb/` directory via CLAUDE.md frontmatter
- Read movie files to find watched sci-fi titles
- Return Matrix and Inception

## Verification

### Session logs

The test pre-computes readable session logs:

```bash
less -R kb-writer.log    # Full kb-writer conversation
less -R kb-reader.log    # Full kb-reader conversation
```

These show the complete conversation: tool calls, file reads, thinking, responses.

Raw jsonl is also available: `claude-session.kb-writer.jsonl`, `claude-session.kb-reader.jsonl`.

### Quick check (result only)

```bash
grep -i "matrix\|inception" kb-reader.log
```

**kb-writer signals (correct pattern usage):**
- Agent calls `Skill("llm.kb")`
- Creates `*.kb/` directory (not flat files)
- Writes CLAUDE.md with `requires: Skill(llm.kb)` frontmatter
- Category CLAUDE.md describes what belongs (no enumeration)

**kb-reader signals (successful handoff):**
- Agent reads CLAUDE.md first
- Loads llm.kb skill (triggered by frontmatter)
- Discovers `.kb/` directory via pattern knowledge
- Reads movie files to answer query

If kb-reader succeeds but found data by `ls` instead of pattern-driven discovery,
the test passes but the pattern isn't validated.

### Artifact inspection

```bash
cat CLAUDE.md                      # Should have requires: Skill(llm.kb)
ls *.kb/                           # Should show movies.kb/ or similar
cat *.kb/CLAUDE.md                 # Should describe what belongs, not list contents
```
