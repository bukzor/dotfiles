---
label: GROUND_TRUTH_OVER_CODE
standing: agent
why:
  - user-saw-only-at-new-tmux.md
---

# Ground Truth Over Code Reading

Whether a channel reaches its intended population is an empirical
question about session lifetimes, answered by measuring the population
(`tmux list-panes -a` + `ps -o lstart,etime`, or equivalent), not
something readable off the trigger code by inspection. The trigger
code only says when it fires; it says nothing about how long the
sessions it fires into actually live.

Grounds: this claim exists because it was violated first. Before
`USER_SAW_NEW_TMUX_ONLY`, the agent asserted "cron-status.sh should
have been warning at every shell start" -- true of the code, read in
isolation, and wrong as a claim about coverage, because "shell start"
was silently standing in for "now," an assumption never checked
against how long a shell actually runs here.
