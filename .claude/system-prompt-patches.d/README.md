# System Prompt Patches

Modular patches applied to the Claude Code system prompt at the proxy layer
via mitmproxy. Each subdirectory defines one patch.

## Why

Claude Code injects a hardcoded system prompt that the user cannot configure.
Some directives contradict user CLAUDE.md instructions, add bloat, or cause
overfit behavior. These patches surgically modify the prompt in transit.

As of v2.1.199, the patches strip ~32% of the long-form prompt
(15.0k → 10.2k chars) and ~12% of the shorter `# Harness` variant served
to Fable-class models (9.5k → 8.3k). These numbers drift as Anthropic
reworks the prompt (v2.1.186 was down to 6.8k before growing back);
`check_patches.py` prints current stats.

## Patch format

Each patch is a directory containing:

| File                   | Required  | Description                                            |
|------------------------|-----------|--------------------------------------------------------|
| `match.md`             | one of    | Detects whether this patch applies here at all         |
| `match.d/*.md`         | one of    | Multiple alternative detection templates; first wins   |
| `search.md`            | no        | The exact text to replace (default: same as the hit `match` template) |
| `search.d/*.md`        | no        | Multiple alternative replace-target templates; first wins |
| `replace.md`           | yes\*     | Replacement text (empty file = deletion)               |
| `upstream-removed.bool`| no        | If `true`, patch becomes a regression assertion (\*)   |
| `README.md`            | no        | Why this patch exists                                  |

`match.md` and `match.d/` are mutually exclusive — exactly one must be
present. Likewise `search.md` and `search.d/` (both optional; at most one).
`replace.md` is required unless `upstream-removed.bool` is set.

### `match` vs `search`

`match` (`match.md` or `match.d/`) answers "does this patch apply here at
all?" A miss is always silent — no warning, no incident. Not matching just
means this prompt doesn't have what the patch is looking for (wrong prompt
shape, session-optional content that's absent this time, whatever); that's
expected, not an error.

`search` (`search.md` or `search.d/`) answers "where's the exact text to
replace?" — tried only after `match` already hit. Omit it and the patch
searches-and-replaces in one step, using whichever `match` template hit as
the target too (the common case). A `search` miss is always **loud**
(`WARNING: patch 'name' failed-to-match`) — there's no flag to silence it,
because `match` already proved the patch is in scope; the precise target
vanishing on top of that is a real regression.

Split the two when you want a patch scoped to specific prompt content (e.g.
only present under a given section heading, or only in one of several
concurrently-served prompt shapes — see `system-prompts.kb/CLAUDE.md`) while
still catching drift within that scope: write `match.md` broad and stable
(e.g. the enclosing section heading) and `search.md`/`search.d/` narrow and
precise (the literal text to strip).

Use `search.d/` (mirroring `match.d/`) when the precise target itself has
worn multiple wordings across cc_versions you still want one patch to
recognize — e.g. `strip-doing-tasks-bloat` anchors on the stable `# Doing
tasks` heading via `match.md`, then tries two known whole-section wordings
via `search.d/{v2.1.76,v2.1.128}.md`. A wording search.d doesn't recognize is
a loud failure, not a silent no-op — that's the point of separating "are we
in scope" from "does the known text still match."

### Placeholders in match/search templates

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

`upstream-removed.bool` is mutually exclusive with `replace.md` and
`search.md` — the patch no longer replaces anything, so there's nothing
for a separate search target to narrow down.

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
