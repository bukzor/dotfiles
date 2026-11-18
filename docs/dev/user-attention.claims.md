---
label: ATTENTION
standing: agent
ontology:
  - attention channel
  - trigger channel
  - polling channel
  - demand channel
  - push channel
  - session population
  - coverage gap
  - always-on surface
non-claim-tokens:
  - ADR
  - TTY
  - SSH
  - PS1
  - PROMPT_COMMAND
stale-when: a channel inventory (channels.kb/) that no longer matches what .config/sh/rc.d/, .tmux.conf, and .config/anacron/ actually wire up
---

# User attention, as a ledger

Twice now -- pnpm 10 -> 11 ([2026-08-27-000]) and pnpm 11 -> 12
([2026-09-10-000]) -- a scheduled job broke, the code responsible for
reporting that ran exactly as written, and the report still didn't
reach anyone for months or weeks. Both times the bug wasn't in the
reporting code; it was in an unexamined belief about how often the
reporting code's trigger actually fires for the sessions that matter.
The second time, the belief was mine, stated as fact ("cron-status.sh
should have been warning at every shell start"), and the user's
correction is what this ledger starts from. This makes that class of
belief a checkable claim instead of a fresh discovery each incident.

## Theories

```
principles ──► channels
```

| Theory | Holds | Stale when |
|---|---|---|
| `principles` | what makes a channel reach real sessions, or fail to | a session-lifetime distribution unlike tmux panes open for days |
| `channels` | the attention channels actually wired up on this machine, and which population each covers | a channel added, removed, or rewired without this file updating |

The direction is the point: `principles` states what makes a channel
work before `channels` judges any particular one against it -- a
channel claim cites the principle it satisfies or fails, rather than
re-arguing the general case each time.

## Standing

```bash
grep -rl 'standing: user' user-attention.claims.kb/    # the user said this directly
grep -rl 'standing: agent' user-attention.claims.kb/   # my generalization, veto invited
grep -rl 'standing: open' user-attention.claims.kb/    # genuinely unresolved
```

Most of `principles.kb/` is `agent`: generalized from one incident, by
me, immediately after living through it -- exactly the judgment this
ledger exists to expose for veto rather than let quietly calcify into
the next ADR's unstated assumption. The two claims it rests on are not
`agent`, though: one is the user's own words, one is a direct
measurement, neither is my inference. `channels.kb/`'s population
claims are checkable (`verify:`) against what's actually configured,
not asserted from memory.

[2026-08-27-000]: adr/2026-08-27-000-pnpm-11-global-tooling-mechanism.md
[2026-09-10-000]: adr/2026-09-10-000-corepack-self-hosted-via-pnpm-add-g.md
