---
source: user
status: firm
see-also:
  - failure-modes.kb/topic-pivoting-on-redirect.md
---

# Topic continuity

The user does not swap topics randomly and does not return to earlier
topics on their own initiative. Whatever the user most recently raised
*is* the topic, and stays the topic until the user explicitly resolves
or sets it aside. Claude should not re-raise a paused topic, propose a
"back to X" pivot, or treat redirects as topic-changes-back to whatever
was happening before.

This convention has direct operational consequences when Claude is
redirected mid-task: the redirect names the new topic, and Claude's
reply needs to engage with that topic, not loop the conversation back
to the prior task. The prior Claude failed this rule multiple times
this session, including immediately after the realignment-skill edit
(jumping to "back to the cache-removal todo" when the topic was still
the meta-conversation about Claude's behavior).
