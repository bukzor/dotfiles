---
label: TURNS_OVER_MINUTES
standing: bare
why:
  - ./clean-agent-time-is-output-tokens-restated.md
verify: "claude-tokens | claude-tokens-cost | claude-tokens-params --estimators"
---

# Turn count beats wall-clock as the input to estimate

Both legs of the comparison favour turns, and comparing only the second
leg is how wall-clock looks competitive:

| | turns | wall-clock minutes |
|---|---|---|
| spread (p90/p10) | 103x | 1337x |
| predictable from history | 60.6% | 71.9% |
| oracle accuracy | 27.2% | 31.7% |
| **end-to-end** | **71.0%** | 75.2% |

Wall-clock absorbs variance that is not work: stalls, tool waits, and the
operator's own thinking time. Only about **70% of a session's elapsed
minutes are the API generating** — the rest is somebody typing, which is
the very human time the estimate exists to trade against, so counting it
double-counts.

The measurement above already truncates idle gaps at 120 seconds, which
flatters wall-clock; uncapped it is worse. The conclusion survives a
treatment biased in its favour.

Wall-clock keeps one job, in `HOURLY_COMPARISON`: it is the only
coordinate in which agent and operator can be quoted side by side.
