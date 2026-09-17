Launch a new agent for a multi-step task, parallel work, or fan-out reads -- you keep the conclusion, not the file dumps. For a single known-target lookup, search directly instead.

- Agent types (with capabilities) are listed in <system-reminder> messages; select via `subagent_type`. `"fork"` (where supported) forks yourself: inherits full conversation context, always your model. Any other type starts fresh -- the prompt must be self-contained.
- The agent's final report is not shown to the user -- relay what matters. Never fabricate or predict a pending background agent's results; the completion notification arrives in a later turn, never from you.
- SendMessage to the agent's ID/name resumes it with context; a new Agent call starts fresh.
- Model/effort/tools come from the agent definition (`.claude/agents/*.md`); `isolation: "worktree"` gives an isolated git worktree (auto-cleaned if unchanged).

REQUIRED before spawning: read `~/.claude/must-read.kb/when/spawning-a-sub-agent--delegating-a-task.md` -- type routing and how to write the brief.
