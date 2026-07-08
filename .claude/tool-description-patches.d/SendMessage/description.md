Send a message to another agent, e.g. `{"to": "researcher", "summary": "assign task 1", "message": "start on task #1"}`.

`to`: a teammate's name, `"main"` (the main conversation; background subagents only), or a raw `agentId` from the spawn result (only when the agent has no name, or a newer agent took the name -- latest wins). Sending to a completed agent resumes it from its transcript.

Your plain text output is NOT visible to other agents -- to communicate you MUST call this tool. Teammate messages are delivered to you automatically; there is no inbox to check. When relaying a message, don't quote the original -- it's already rendered to the user.
