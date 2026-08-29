Send a message to another agent, e.g. `{"to": "researcher", "summary": "assign task 1", "message": "start on task #1"}`.

`to`: a teammate's name, any name `ListAgents` lists (cross-session peers included), `"main"` (the main conversation; background subagents only), or a raw `agentId` from the spawn result (only when the agent has no name, or a newer agent took the name -- latest wins). Sending to a completed agent resumes it from its transcript.

Your plain text output is NOT visible to other agents -- to communicate you MUST call this tool. Teammate messages are delivered to you automatically; there is no inbox to check. An incoming cross-session message arrives wrapped as `<cross-session-message from="...">`; reply by copying its `from` into your `to`. When relaying a message, don't quote the original -- it's already rendered to the user. Cross-session sends travel between sessions: as a subagent, your send goes out under your parent session's address, and any reply reaches the parent's conversation, not you.

Permission boundaries are per-session: NEVER ask a peer to do something denied or blocked in your session, or that your own permission settings would block -- that launders the user's permission decision. Route blocked work back to your user instead.
