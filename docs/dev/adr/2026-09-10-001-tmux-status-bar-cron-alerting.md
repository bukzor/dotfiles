# tmux status-bar cron alerting

**Date:** 2026-09-10
**Status:** Accepted

## Context

[2026-08-27-001] made `.config/sh/rc.d/cron-status.sh` warn about a failed
scheduled job "at shell start". That was read as covering ongoing use, on the
assumption that a shell starts often enough. It doesn't, here: `tmux
list-panes -a` plus `ps -o lstart,etime` on the resulting PIDs showed the
real panes in daily use are `-bash` processes 6-17+ days old. `rc.d/*` is
sourced once, by the interactive-shell init path (`.bashrc`/`.zshrc` →
`.config/sh/rc.d/*`, gated on `case $- in *i*)`), and never again for the
life of that shell. For a machine used almost entirely through long-lived
tmux panes, "at shell start" is close to "never, for any pane you're
actually working in" -- confirmed directly: during the incident this ADR
follows from ([2026-09-10-000]), the pnpm-upgrade-g cron job had been
failing nightly since 2026-09-07, and the rc.d warning did not surface it in
any pane in active use.

The gap is specifically that nothing re-checks `~/.local/state/cron/*.status`
on a timer independent of shell lifecycle. `cron-health_check.sh` is a test,
run on demand (`redo test`), not a standing alert.

## Decision

**Poll the same status files from tmux's status line**, which redraws on a
timer (`status-interval`, default 15s) regardless of what the shell in the
pane is doing:

```tmux
set -g status-right "#(~/bin/cron-status --tmux)..."
```

**The failure-scanning logic moved out of `rc.d/cron-status.sh` and into a
new `bin/cron-status`,** shared by both call sites instead of duplicated:
`bin/cron-status` (no args) prints one `<code> <job> <log>` line per failed
job; `bin/cron-status --tmux` prints a compact `#[fg=red,bold]cron:<job>[,<job>...]#[default]`
segment, or nothing when clean. `rc.d/cron-status.sh` now pipes the former
into `warn`; `.tmux.conf`'s `status-right` embeds the latter directly. One
place computes "which jobs are failing"; two places decide what to do with
that.

Both channels stay. They cover different sessions: a plain SSH shell with no
tmux still gets the rc.d warning; a pane that's been open for two weeks gets
the tmux warning the rc.d hook could never deliver to it. Neither subsumes
the other.

**Verification:** `bin/cron-status` and `bin/cron-status --tmux` were run
directly against both a clean `*.status` set and a simulated failure
(`echo 1 > pnpm-upgrade-g.status`), producing the correct output in each
case; the rewritten `rc.d/cron-status.sh` was sourced under `set -e` in both
states and confirmed not to abort the shell either way. `.tmux.conf` was
reloaded live (`tmux source-file`) with no parse errors, and `tmux show -g
status-right` confirmed the new format string is active and unshadowed by
any session- or window-level override. The live rendered status bar itself
was not screen-captured to confirm the glyph appears -- `tmux display-message
-p` cannot observe `#()` job output synchronously (confirmed empirically:
even a trivial static `#(echo x)` returns empty through it, since job output
is filled in asynchronously on the status-line's own redraw, not on-demand)
-- so this rests on `#(cmd)` in `status-right` being tmux's standard,
widely-used mechanism for exactly this (battery/git/weather status-line
plugins all use it) rather than on an end-to-end visual check.

## Alternatives Considered

### Throttled re-check in `PROMPT_COMMAND`/precmd
Would re-fire on every new prompt in a long-lived shell, using the same
alerting text as the existing warning. Rejected: still gated on the pane
actually being interacted with (an idle pane never redraws its prompt), and
adds a periodic timestamp file to avoid re-warning every single prompt --
more state and more code than a status line that already redraws itself on
a timer.

### Self-heal inside `pnpm-upgrade-g` for this specific failure mode
Considered and rejected in [2026-09-10-000] for the poisoned-corepack-cache
case specifically. Not revisited here: this ADR is about the general
delivery problem (a failed job's status not reaching a long-lived pane),
which self-healing one job's specific failure mode wouldn't address for any
other job.

### tmux hook on pane focus / window select
`set-hook -g pane-focus-in` could re-run the check only when a pane is
actually looked at. Rejected in favor of the simpler `status-right` poll:
a hook fires as code, not as a display primitive, so it would still need to
write *something* visible (right back to a status-line segment, or a
`display-message` popup) -- the poll gets the same visibility for less
mechanism, at the cost of a 15s-worst-case delay that doesn't matter for a
nightly job.

## Consequences

**Positive:**
- A failed scheduled job now reaches every attached tmux client within one
  `status-interval`, independent of how old the pane's shell is.
- The failure-scanning logic has one implementation (`bin/cron-status`)
  instead of duplicating it into the tmux segment.
- `bin/cron-status` alone is directly scriptable/testable without sourcing
  rc.d machinery.

**Negative:**
- One more `#()` job for tmux to poll every `status-interval`, server-wide.
  Trivially cheap (`for` loop over a handful of small files) but non-zero.
- A session attached over SSH without tmux gets no continuous channel,
  same as before this change -- only the once-at-start rc.d warning.

**Neutral:**
- `rc.d/cron-status.sh` now shells out to `bin/cron-status` instead of
  running inline; one extra fork per interactive shell start, negligible.

## Related

- Extends: [2026-08-27-001] -- names the delivery gap in "at shell start"
  that this closes for tmux users specifically
- Follows from: [2026-09-10-000] -- the incident (pnpm-upgrade-g cron
  failures going unseen) whose post-mortem is item 4 of the user's
  remediation list; that ADR's "no self-heal" decision and this one's
  "fortify alerting instead" are the same directive
- Implements: `bin/cron-status`, `.config/sh/rc.d/cron-status.sh`,
  `.tmux.conf`
- Generalized as: `docs/dev/user-attention.claims.md` -- the trigger/poll
  distinction this decision turned on, made a checkable claim rather than a
  one-off argument in this file

[2026-08-27-001]: 2026-08-27-001-scheduled-job-health.md
[2026-09-10-000]: 2026-09-10-000-corepack-self-hosted-via-pnpm-add-g.md
