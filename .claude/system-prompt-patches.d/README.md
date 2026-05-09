# System Prompt Patches

Modular patches applied to the Claude Code system prompt at the proxy layer
via mitmproxy. Each subdirectory defines one patch.

## Why

Claude Code injects a hardcoded system prompt that the user cannot configure.
Some directives contradict user CLAUDE.md instructions, add bloat, or cause
overfit behavior. These patches surgically modify the prompt in transit.

As of v2.1.76, all patches applied reduces the system prompt by ~60%
(14.3k → 5.7k chars).

## Patch format

Each patch is a directory containing:

| File              | Required | Description                                       |
|-------------------|----------|---------------------------------------------------|
| `match.md`        | yes      | Text to find in the system prompt                 |
| `replace.md`      | yes      | Replacement text (empty file = deletion)          |
| `conditional.bool`| no       | If `true`, skip warning when match fails          |
| `README.md`       | no       | Why this patch exists                             |

### Placeholders in `match.md`

`$ALLCAPS` tokens act as placeholders, matching dynamic content:

- `$NAME` — matches the rest of the line (`[^\n]*`)
- `$LINES` — matches one or more non-empty lines

Placeholders are delimited by the next literal text in the template.
Same-named placeholders match independently (no backreference).

## Running

Patches are applied by `~/claude/mitmproxy/syspatch.py`, loaded as a
mitmproxy addon via `~/claude/mitmproxy/proxy.sh`:

```bash
# Start the patching proxy
~/claude/mitmproxy/proxy.sh

# In another terminal
ANTHROPIC_BASE_URL=http://localhost:8080 claude
```

## Testing

Verify patches against a captured system prompt:

```bash
cd ~/claude/mitmproxy
python3 check_patches.py          # prints patched result to stdout, stats to stderr
python3 check_patches.py system.md  # test against a specific capture
```

## Current patches

- **fix-tone-conciseness** — Replace bare "short and concise" with principled token-cost framing
- **strip-additional-dirs** — Remove additional working directories list (conditional)
- **strip-backwards-compat** — Remove backwards-compatibility hack advice
- **strip-colon-before-tools** — Remove "no colon before tool calls" directive
- **strip-doing-tasks-bloat** — Remove entire "Doing tasks" section
- **strip-fast-mode-info** — Remove fast mode info block (conditional)
- **strip-git-status** — Remove stale git status snapshot (conditional)
- **strip-help-feedback** — Remove /help and feedback URL
- **strip-model-family** — Remove model family/ID listing
- **strip-output-efficiency** — Remove "Output efficiency" section (contradicts CLAUDE.md)
- **strip-over-engineering** — Remove over-engineering advice
- **strip-security-bloat** — Remove overwrought security policy
- **strip-tool-preference** — Remove "use dedicated tools not Bash" section
- **strip-url-restriction** — Remove URL generation restriction
