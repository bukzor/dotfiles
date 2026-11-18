---
label: PUSH_BOUNDED_BY_CALLSITES
standing: agent
why:
  - no-channel-covers-every-population.md
---

# A Push Channel's Population Is Its Call Sites

A **push channel** fires when the event source itself calls out, at
the moment of the event -- `bin/alert`, invoked by whatever command
wants attention, rather than polled or triggered by session
lifecycle. Its population is exactly its call sites: a trigger or
polling channel covers a session merely by that session existing; a
push channel covers only what was explicitly wired to invoke it. A
cron job that never calls `alert` on failure gets none of its
coverage, however reliable `alert` itself is.

`NO_SINGLE_CHANNEL` said no channel covers every population; this is
the same fact at the instance level, for a channel kind whose gap
isn't structural (a population it can't reach) but instrumentational
(a caller nobody wired in yet) -- closed by adding a call site, not by
adding a new channel kind.
