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

| File                   | Required  | Description                                            |
|------------------------|-----------|--------------------------------------------------------|
| `match.md`             | one of    | Text to find in the system prompt                      |
| `match.d/*.md`         | one of    | Multiple alternative templates; first match wins       |
| `replace.md`           | yes\*     | Replacement text (empty file = deletion)               |
| `upstream-removed.bool`| no        | If `true`, patch becomes a regression assertion (\*)   |
| `conditional.bool`     | no        | If `true`, skip warning when match fails               |
| `README.md`            | no        | Why this patch exists                                  |

`match.md` and `match.d/` are mutually exclusive — exactly one must be present.
`replace.md` is required unless `upstream-removed.bool` is set.

### Placeholders in match templates

`$ALLCAPS` tokens act as placeholders, matching dynamic content:

- `$NAME` — matches the rest of the line (`[^\n]*`)
- `$LINES` — matches one or more non-empty lines

Placeholders are delimited by the next literal text in the template.
Same-named placeholders match independently (no backreference).

### Multiple match templates: `match.d/*.md`

A patch can target multiple Claude Code prompt versions by providing
several alternative templates inside `match.d/`. Filename is arbitrary
(used only for sort order); each `*.md` file is one alternative. At
apply time, alternatives are tried in sorted-filename order and the
first match wins.

Use this when Anthropic reworded a section between versions and you
want one patch to handle both.

### Upstream-removed: regression assertion

When Anthropic deletes the text a patch was targeting, the patch can
be sunset rather than deleted by adding `upstream-removed.bool: true`
and removing `replace.md`. The patch becomes an assertion:

- match found → loud `WARNING: ... marked upstream-removed but matched body`
  (regression: text returned upstream)
- no match → silent (good, still removed)

`upstream-removed.bool` is mutually exclusive with `replace.md` (the
patch no longer replaces anything) and with `conditional.bool` (the
semantics are inverted).

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

See each subdirectory. Per-patch `README.md` is optional; the directory
name plus `match.md` is usually self-evident.
