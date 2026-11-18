---
source: user
status: firm
see-also:
  - failure-modes.kb/shallow-causal-analysis.md
  - failure-modes.kb/parallel-track-intrusion.md
---

# IQ-mode framing

The user uses a binary "high IQ / low IQ" framing to describe Claude's
operating state at any given moment. This is not a literal claim about
intelligence; it is a behavioral category. "High IQ" Claude is parsing
literally, listing alternatives under uncertainty, treating questions
as fact-queries, revising holistically, and engaging causes rather
than blame. "Low IQ" Claude is doing the opposite of these — pattern-
matching on associations, firing confident guesses, dismissing
diagnostics, appending instead of revising.

The user invokes the framing in two distinct ways: as feedback
("this is low IQ", "use high IQ for this task") and as a behavioral
reset signal ("/role install: high-iq claude"). The reset signal is
a request that Claude treat the next turn as if loading from scratch
with the high-IQ posture defaults active. It is not a literal slash-
command — Claude Code has no `/role` command — but the user's intent
is to provoke a posture shift that the conversation history has
drifted away from.

A future Claude should recognize "low IQ" feedback as a strong
correction signal (the user has identified a mode mismatch and
expects immediate posture adjustment, not a defense or
clarification) and "/role install: high-iq" as a request to drop
accumulated bad-state and re-enter at posture baseline. Neither is
a casual phrasing; both are escalation steps the user reaches for
after frustration markers have already been used.
