# channels.kb -- maintenance guide

## What belongs here

One claim per attention channel actually wired up on this machine:
what fires it, what population it can reach, and a `verify:` that
re-checks the wiring is still what's claimed. A channel proposed but
not built carries `todo:` instead of a fresh claim once it lands.

## What does NOT belong here

- The general case a channel is judged against -> `../principles.kb/`.
  cite it in `why:`, don't restate it.
- The decision to add or change a channel -> an ADR, cited in prose.

## Standing

These should stay `bare` with a `verify:` wherever possible -- what a
channel covers is a fact about running configuration, checkable
without asking anyone. `open` is honest where the covered population
is genuinely unknown (`ssh-without-tmux-gap.md`); don't round an open
question up to `bare` to make the ledger look more finished than it is.
