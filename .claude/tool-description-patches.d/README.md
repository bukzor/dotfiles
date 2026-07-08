# Tool Description Patches

Slim replacements for built-in Claude Code tool descriptions, applied in
transit by `~/claude/mitmproxy/toolpatch.py`. Each subdirectory is named for
the tool it patches (exact tool name, e.g. `Monitor/`).

## Why

Built-in tool descriptions are hardcoded in the CLI and some run to thousands
of tokens, paid on every request. Denying a tool (`permissions.deny`) removes
its schema but loses the capability. This layer keeps the tool available while
replacing its description with a short stub; durable guidance the description
carried moves to `~/.claude/must-read.kb/`, loaded only when relevant.

## Patch format

| File             | Required | Description                                            |
|------------------|----------|--------------------------------------------------------|
| `description.md` | yes      | Replacement description (the slim stub)                |
| `upstream.md`    | one of   | Last-reviewed upstream description (drift tripwire)    |
| `upstream.d/*.md`| one of   | Multiple accepted upstream wordings (variants coexist) |
| `README.md`      | no       | Why / what moved where                                 |

At apply time the tool's live description is compared to the accepted
upstream texts (modulo trailing newline). On mismatch the stub is still
applied, but a `changed-upstream` incident is captured under
`~/claude/mitmproxy/patch-failures/` -- loud once per distinct upstream text,
like a syspatch drift. Triage: diff the captured body against the accepted
upstreams, fold anything worth keeping into `description.md` or the
must-read entry, then add the captured body to `upstream.d/` (or replace
`upstream.md` if the old wording is gone for good).

Wordings vary concurrently -- by interface variant and model family, not
just cc_version -- so prefer accumulating in `upstream.d/` over replacing.

A tool absent from a request (denied, restricted subagent toolset) is silently
skipped -- absence is not drift.

## Refreshing upstream.md

Descriptions ride in `request.tools[]`; extract from a `traffic.jsonl` capture:

    jq -rn 'first(inputs
      | select(.phase=="request" and (.data.path | startswith("/v1/messages")))
      | .data.content.tools // empty | .[]
      | select(.name=="Monitor")) | .description' traffic.jsonl

## Testing

    cd ~/claude/mitmproxy && ./check_tool_patches.py

applies every patch to its own `upstream.md` (as if live) and prints per-tool
size stats; expect zero warnings.
