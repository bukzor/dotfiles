Strip the AgentTool/workflows prohibition lines (opus-5 shape,
v2.1.221+).

Two floating lines between the `# Corrections` prose and the gitStatus
block forbid agent and workflow use unless requested -- while the same
conversations carry an injected agent-types listing (a user-turn
system-reminder, outside syspatch's reach) that instructs the model when
TO delegate. Of the two contradicting halves only this one is in the
system-prompt body, so this is the one that goes; it also contradicts a
multi-agent workflow that is requested, standingly, by user config.

`match.md` gates on the first line with its tail as `$REST`, so the
whole block vanishing upstream (the real fix) is a silent no-op, while
partial rewording -- first line intact, rest drifted -- is a loud search
miss.

`search.d/`, tried in filename order: `0-with-tail.md` eats one trailing
blank line to leave clean spacing when more body follows; `1-eof.md` (no
trailing blank line) covers the block landing at the literal end of the
prompt -- a subagent/CLI-auxiliary body with no gitStatus after it, which
has nothing for a blank-line search to eat. `0-` must sort first: its text
is a strict superset of `1-`'s, so trying `1-` first would always win and
leave a stray blank line behind on the common mid-body case
(2026-08-21 incident, digest `2dc946a4090a`).
