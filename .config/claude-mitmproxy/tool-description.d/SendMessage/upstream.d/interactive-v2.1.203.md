# SendMessage

Send a message to another agent.

```json
{"to": "researcher", "summary": "assign task 1", "message": "start on task #1"}
```

| `to` | |
|---|---|
| `"researcher"` | Teammate by name |
| `"main"` | The main conversation (background subagents only) |

Your plain text output is NOT visible to other agents — to communicate, you MUST call this tool. Messages from teammates are delivered automatically; you don't check an inbox. Refer to active teammates by name; to address a background agent that has no name (or whose name a teammate holds) — or to resume a completed one — use its `agentId` (format `a...-...`) from its spawn result. When relaying, don't quote the original — it's already rendered to the user.