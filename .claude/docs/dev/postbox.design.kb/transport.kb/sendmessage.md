---
why:
  - ../transport.md
verdict: declined
---

# SendMessage / ListAgents (built-in)

Declined on the owner's three grounds (quoted, 2026-08-28):

1. "agents often decide they want to send messages for inane reasons, with
   zero-or-negative benefit, and substantial costs"
2. "agents recieving messages often get very distracted from their task"
3. "there's **no way** to /rewind to before a message was sent/recieved
   short of /claude-surgery"

Root cause (all three): push-into-context delivery. Objection 1 is
receive-consent missing; 2 is delivery-as-interrupt; 3 is delivery woven
into the transcript at an arbitrary point. The owner's Ask setting gates
only outbound — no permission gates receiving — so configuration cannot
rescue it. Push also structurally excludes retraction/editing of in-flight
mail (the ratified invariant).

Revisit condition: effectively none. Owner: "I doubt claude-code team will
'fix' all these aspects anytime soon. Even if they do, i don't trust they
won't add other problems (for me)."
