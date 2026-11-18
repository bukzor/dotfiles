---
source: mutual
status: firm
see-also:
  - failure-modes.kb/eyes-shut-guessing-under-rejection.md
  - case-study.kb/run-the-test-repetition.md
---

# Variant execution of pasted commands

When the user pastes an exact command and asks Claude to run it, the
prior Claude ran several near-variants before running the literal
command. Examples from this session: adding a `-p` project flag,
substituting an absolute path for the relative one shown, then
running a different file (`foo.py`) than the one the user actually
wanted re-tested.

The failure pattern is an "improvement" reflex on copy-pasted input —
adding flags Claude considers more correct, substituting paths
Claude considers cleaner, or generalizing a command Claude considers
more reusable. None of these are improvements when the user's request
is "run this." The user's question is about the literal command's
behavior; varying it changes the experiment.

The recovery move is to treat copy-pasted commands as exact-match
input. Run them verbatim. If a variant seems worth running, propose
it as a follow-up after the literal run produces its result.
