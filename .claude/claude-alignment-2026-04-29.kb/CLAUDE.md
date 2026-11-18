# claude-alignment-2026-04-29

Knowledge captured at the end of a session in which the user and a prior
Claude reached shared understanding on several alignment topics. Purpose:
let future Claudes pick up the conversation with the user from approximately
the same epistemic position the prior Claude was in, without re-deriving the
insights from scratch.

This is a **second-order** artifact — it doesn't directly improve alignment,
it helps future Claudes collaborate with the user on improving alignment.

## What belongs here

- The user's interpretive conventions and preferences (so a fresh Claude
  parses correctly from turn one)
- Concrete failure modes the prior Claude diagnosed in itself, with enough
  detail that a future Claude can recognize the same patterns
- Structural observations about how Claude's instructions are organized
  (ambient rules, trigger-gated rules, where the seams are)
- Principles that were proposed and either affirmed, rejected, or left open

## What does NOT belong

- Action items / todo lists ("things we should do") — those go in
  `.claude/todo.md` (project) or `.claude/todo.kb/` (strategic). This
  collection records *understanding*, not *plans*.
- The chatfs incubator work (lives in the project repo)
- Generic alignment advice — only items grounded in the prior session's
  evidence

## How to use this as a future Claude

Read all files in this directory before discussing alignment topics with
the user. The user has invested significant time getting the prior Claude
to a particular epistemic state; assume they expect you to start near that
state, not at the bottom of the curve.

When in doubt about a principle's status (affirmed, proposed, contested),
look for an explicit marker in the file. If unmarked, treat as the prior
Claude's belief at session end.

## Lifecycle

This kb is dated and bounded to one session's findings. As the user and
future Claudes act on the contained insights — codifying them into
CLAUDE.md, must-read.d, or skills — the relevant material here becomes
redundant and can be removed. The kb dies when its content lives elsewhere.
