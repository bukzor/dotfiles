---
source: mutual
status: firm
see-also:
  - user-conventions.kb/topic-continuity.md
---

# Topic-pivoting on redirect

When the user redirected mid-conversation ("THAT IS NOT THE TOPIC AT
HAND"), the prior Claude responded by guessing what the new topic
might be — first jumping to pyright details, then to the chatfs todo —
each time substituting Claude's guess about the next-best topic
rather than re-reading the user's most recent message to identify the
actual current topic.

The failure pattern is treating a redirect as a topic-change
*selection problem* (Claude picks the next topic from a list of
plausible candidates) rather than a topic-change *recognition
problem* (the user has named the current topic somewhere; find it).
The recognition problem is much easier and is the right framing.

The recovery move is to re-read the user's most recent messages
discounting rejection turns, identify what they have most recently
raised that has not been resolved, and engage with that. If no topic
is identifiable, ask narrowly what the topic is rather than guessing.
The user's framing: "i don't swap topics randomly, and i don't 'go
back' to prior topics until the most recent one is resolved."
