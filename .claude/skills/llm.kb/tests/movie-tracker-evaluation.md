# Evaluation: Movie Tracker

Tests llm.kb pattern compliance and multi-agent handoff.

## Run

```bash
./test
```

## Phase 1: Create Knowledge Base

Pass if agent follows SKILL.md patterns. Key signals:
- Creates `CLAUDE.d/llm-kb.md` per SKILL.md
- CLAUDE.md not corrupted (append-only)

## Phase 2: Multi-Agent Handoff

Pass if second agent can answer "What sci-fi movies have I watched?" using the
knowledge base created in Phase 1.

## Verification

```bash
cat CLAUDE.d/llm-kb.md             # Should exist with requires: frontmatter
grep -i "matrix\|inception" claude-session.jsonl  # Phase 2 answer
```

Final check: review output against SKILL.md -- does the structure follow the pattern?
