# Postbox — inter-session agent collaboration

House convention for agent-to-agent communication using files instead of
SendMessage/ListAgents. Status: **design converged and fully
ruled 2026-08-28; nothing implemented.** No open rulings; grep
`[!TODO]` in `convention.md` for the implementation surface.

Placement: `~/.claude/docs/dev/` by owner ruling (2026-08-28); `~/.claude`
is the governing project — triggers, hooks, and permission rules land here.

## Re-entry (reading order for a cold agent)

1. `convention.md` — the design. `[!TODO]` = decided, unimplemented.
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
