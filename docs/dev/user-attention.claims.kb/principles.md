---
label: PRINCIPLES
standing: agent
ontology:
  - trigger channel
  - polling channel
  - demand channel
  - push channel
  - coverage gap
  - session population
---

# Principles

What decides whether a mechanism meant to notify the user actually
does, for the population of sessions this machine really runs -- not
for the population its author pictured while writing it.

Four kinds of channel appear in `channels.kb/`, and the words are
introduced here because a channel claim needs them without re-deriving
them: a **trigger channel** fires once when some event happens (a
shell starting) and is silent for the rest of that session's life; a
**polling channel** re-renders on its own timer, independent of
anything the session does; a **demand channel** fires only when
something explicitly *pulls* it (a test suite run asking "is
everything OK?"); a **push channel** fires when the event source
itself calls out, at the moment of the event (a command invoking
`bin/alert`) -- the same "fires on demand" shape as a demand channel,
inverted: pulled vs. pushed. A **session population**
is the set of live sessions of some kind, characterized by how long
they typically run before being replaced. A **coverage gap** is an
interval during which a real condition holds but no channel currently
surfaces it to anyone.
