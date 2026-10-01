---
source: user
status: firm
see-also:
  - failure-modes.kb/reading-questions-as-pressure.md
  - failure-modes.kb/topic-pivoting-on-redirect.md
  - case-study.kb/pyproject-toml-lost-and-restored.md
  - rule-architecture.md
---

# Questions are fact-queries by default

When the user asks a question — including "why X?", "what's wrong?", "is
that right?" — the default reading is a request for information, not a
directive or critique. "Why pause" means "tell me why you paused," not
"stop pausing." Reading questions as pressure or as instructions to
change behavior is a recurring failure mode the prior Claude exhibited
this session.

This convention used to live ambiently in `~/.claude/CLAUDE.md` as
"Treat disagreement and questioning as requests for deeper analysis,
not grounds for immediate reversal" (commit 9ff0146). It was removed in
commit 01dc2d3 ("Extend trigger-based guidance: add
contradicting-a-previous-response trigger") when migrated into
trigger-gated `must-read.d/` files. The trigger gates do not fire
reliably for casual mid-task questions, so the convention's effective
coverage narrowed even though the user still considers it in force.
