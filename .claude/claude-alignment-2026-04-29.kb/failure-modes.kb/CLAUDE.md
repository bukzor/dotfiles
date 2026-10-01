# Failure Modes

Patterns the prior Claude diagnosed in its own behavior during the
session. Each item is one failure mode, described with enough detail
that a future Claude can recognize the same pattern in itself.

## What belongs here

A failure mode belongs here when it is a recognizable behavioral
pattern that recurred or could recur, not a one-off mistake. Each
file should describe the pattern, name a triggering condition, and —
where possible — point to a specific session moment that exhibits it.

## What does NOT belong

- User conventions (those go in `../user-conventions.kb/`)
- Generic advice ("be careful") without behavioral specificity
- Failure modes that are already covered by ambient rules in
  `~/.claude/CLAUDE.md` and reliably caught — those don't need
  recapitulation
