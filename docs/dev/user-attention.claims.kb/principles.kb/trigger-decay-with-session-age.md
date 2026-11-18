---
label: TRIGGER_DECAY
standing: agent
why:
  - long-lived-panes-are-the-population.md
  - user-saw-only-at-new-tmux.md
---

# A Trigger Channel's Coverage Decays With Session Age

A trigger channel's chance of reporting a true-at-the-moment condition
falls toward zero as the population's typical session lifetime grows
past the interval between changes in what it reports. Shell-start
fires once, at the birth of a shell process; a nightly cron job's exit
status can flip the next day. For a population whose sessions live
6-17+ days (`LONG_LIVED_PANES`), the channel is truthful only in the
instant of birth and silent for nearly the entire life of the session
-- which is why the user saw the warning exactly once, at a brand-new
tmux session, and nowhere else (`USER_SAW_NEW_TMUX_ONLY`).

This isn't a flaw in the trigger code (`.config/sh/rc.d/cron-status.sh`
correctly warned on every value it was asked about); it's a mismatch
between the channel's firing rate and the population's session
lifetime, invisible from reading the trigger alone.
