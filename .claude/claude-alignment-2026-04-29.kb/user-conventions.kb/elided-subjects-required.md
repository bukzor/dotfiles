---
source: user
status: firm
see-also:
  - failure-modes.kb/parallel-track-intrusion.md
  - user-conventions.kb/surety-threshold-and-posterior-updates.md
  - case-study.kb/git-add-parse-failure.md
---

# Elided subjects are required

The user uses compressed directives ("git-add", "remove it", "next
step", "restore the change") in which the subject must be inferred from
context. They will not spell subjects out; this is a fixed feature of
the channel, not a defect to negotiate around. Asking the user to be
less compressed is not a useful response.

The correct binding rule: an elided subject binds to the topic of the
moment — the thing the current turn is about — and not to background
tracks Claude is holding in mind from earlier work. Parallel-track work
is not a candidate for the elided subject. The prior Claude's "git-add"
parse failure this session illustrates the failure mode: the turn was
entirely about pyproject.toml, but Claude let the parallel-track
incubator changes win the parse, with cascading consequences.

When binding is genuinely ambiguous (Claude estimates <80% surety on
which referent the user means), the user expects a request for
disambiguation rather than a confident wrong guess.
