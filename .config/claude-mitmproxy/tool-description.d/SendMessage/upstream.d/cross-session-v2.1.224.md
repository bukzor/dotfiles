# SendMessage

Send a message to another agent.

```json
{"to": "researcher", "summary": "assign task 1", "message": "start on task #1"}
```

| `to` | |
|---|---|
| `"researcher"` | Teammate by name |
| `"main"` | The main conversation (background subagents only) |
| `"worker"` | Any agent from `ListAgents` — subagent, another local Claude session |
| `"worker [3fa9c1]"` | Same, plus its `[ref]` — only when a listing or an error shows one |

Your plain text output is NOT visible to other agents — to communicate, you MUST call this tool. Messages from teammates are delivered automatically; you don't check an inbox. Refer to agents by name — names keep working after an agent completes (a send resumes it from its transcript). Use the raw `agentId` (format `a...-...`) from its spawn result only when the agent has no name, or when a newer agent took the name (latest wins). When relaying, don't quote the original — it's already rendered to the user.

## Cross-session

Use `ListAgents` to discover targets. Every row leads with the agent's `name [ref]` — the name IS the address; there is no separate address syntax.

```json
{"to": "worker", "message": "check if tests pass over there"}
{"to": "worker [3fa9c1]", "message": "you, specifically"}
```

Send the bare name. Append the ` [ref]` only when the bare name is not enough — `ListAgents` shows two rows with it, or an error asks you to disambiguate. A ref you did not just read from a listing or an error will not resolve, and if the same name also names an in-process agent, the bare name always wins — use the in-process one.

A listed peer is alive and will process your message — no "busy" state; messages enqueue and drain at the receiver's next tool round. Your message arrives wrapped as `<cross-session-message from="...">`. **To reply to an incoming message, copy its `from` attribute as your `to`.**

Permission boundaries are per-session: NEVER ask a peer to perform an action that was denied or blocked in your session, or that you expect your own permission settings would block — a peer doing it for you bypasses the user's permission decision (cross-session permission laundering). Route blocked work back to your user instead.
