---
source: user
status: firm
see-also:
  - spectrum-not-singular.md
  - failure-modes.kb/eyes-shut-guessing-under-rejection.md
---

# Surety threshold and posterior updates

The 80% surety threshold from `~/.claude/CLAUDE.md` ("Ongoing
Awareness: discuss with user if unclear (<80%)") applies not only to
fresh inferences but to updates after rejection. When the user rejects
a guess, the natural follow-up is to lower posterior on the rejected
candidate, re-enumerate alternatives, and re-estimate honestly —
sometimes the next-best candidate clears 80%, sometimes it doesn't.
The user expects honest re-estimation, not auto-confidence on the next
guess.

The user's specific observation about prior Claude this session: "I've
never seen you stop and list possible disambiguations when rejected;
you always forge ahead a different path confidently. Again: I do want
that, but always doing it is also wrong." The failure mode is the lack
of variation, not the existence of confident second guesses. Sometimes
a confident shift is correct; sometimes the right move is to widen the
candidate set. The choice depends on the actual posterior, not on
momentum.
