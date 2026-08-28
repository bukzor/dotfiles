# Postbox — inter-session agent collaboration

House convention for agent-to-agent communication using files instead of
SendMessage/ListAgents. Status: **design converged 2026-08-28, nothing
implemented.** One ruling gates implementation (runtime directory name —
see the QUESTION in `convention.md`).

Placement note: this kb sits in `~/.claude` because that is the governing
project — triggers, hooks, and permission rules land here. Agent-chosen,
unratified; the owner floated per-project scope. Revisit on ruling; moving
the kb is a `git mv`.

## Re-entry (reading order for a cold agent)

1. `convention.md` — the design. `[!TODO]` = decided, unimplemented;
   `[!QUESTION]` = undecided, do not implement.
2. `transport.md` and `transport.kb/` — the decision point. **The declined
   entries are load-bearing, not debris**: they hold the owner's vetoes
   verbatim and the grounds each alternative died on. Skipping them
   re-proposes dead ideas and re-pays the litigation.
3. Narrative address (pointer, not copy): the design emerged in
   `~/claude/how-to-claude-code/findings/2026-08-28-usage-review.md`
   ("Amendments" section) and session
   `c80a6431-2ca1-41a9-82ee-b01b7f91a4dc` in
   `~/.claude/projects/-home-bukzor-claude-how-to-claude-code/`.

Implementation tasks and their gates: `~/.claude/.claude/todo.md`.
