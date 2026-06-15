---
requires:
  - Skill(llm-kb)
---

# User Preferences Collection

Cross-platform LLM interaction preferences. Each item is a preference document
for one platform, with a sibling `.kb/` containing its discourse-graph-style
breakdown.

## What belongs here

- User preference documents for LLM platforms (claude-code, claude-ai, chatgpt, etc.)
- `.kb/` breakdowns analyzing claims, definitions, and questions within each

## What does NOT belong here

- Platform-specific tooling or configuration (that's the rest of `~/.claude/`)
- Session-specific notes or devlogs
