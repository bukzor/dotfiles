Start a background monitor that streams events from a long-running script: each stdout line (or each text frame of a `ws` WebSocket source) becomes a chat notification while you keep working; script exit ends the watch. For a single "done when X" notification, prefer Bash `run_in_background` with an until-loop instead.

REQUIRED before arming any monitor: read `~/.claude/must-read.kb/before/using-claude-code-tool/Monitor.md` -- buffering, terminal-state coverage, and output-volume pitfalls there make the difference between a working monitor and a silently useless one.
