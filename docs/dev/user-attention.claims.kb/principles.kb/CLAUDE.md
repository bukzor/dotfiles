# principles.kb -- maintenance guide

## What belongs here

A claim about attention channels in general -- what makes one reach
its intended population, stated so it applies to a channel not yet
built. Ground facts this machine's channels are judged against also
belong here (a measurement, a direct user statement), since a
`channels.kb/` claim cites them as premises.

## What does NOT belong here

- A specific channel on this machine and what it covers ->
  `../channels.kb/`. These state the test; that applies it.
- The decision to add, remove, or rewire a specific channel -> an ADR,
  cited in prose from the relevant `channels.kb/` claim.

## Standing

`agent` is the honest default: these are generalized from one
incident (the 2026-09-10 cron-alerting fix), by the agent that lived
it, and have not yet been tested against a second one. The two ground
facts (`long-lived-panes-are-the-population.md`,
`user-saw-only-at-new-tmux.md`) are not `agent` -- one is a re-runnable
measurement, one is the user's own words -- and every other claim here
should bottom out at one of those two, not at a third unstated
assumption.
