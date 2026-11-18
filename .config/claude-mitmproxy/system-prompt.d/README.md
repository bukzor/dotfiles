# System Prompt Patches

Modular patches applied to the Claude Code system prompt at the proxy layer
via mitmproxy. Each subdirectory defines one patch.

## Why

Claude Code injects a hardcoded system prompt that the user cannot configure.
Some directives contradict user CLAUDE.md instructions, add bloat, or cause
overfit behavior. These patches surgically modify the prompt in transit.

As of v2.1.221, prompt shapes are model-scoped and the patches strip
~37% of the opus-5 `# Harness` shape (10.8k → 6.8k chars), ~20% of the
fable-5 one (9.9k → 7.9k), and ~18% of the sonnet-5 long-form
(27.9k → 22.8k, dominated by a session-optional `# auto memory` block).
These numbers drift as Anthropic reworks the prompt; `check_patches.py`
prints current stats, and the proxy's `_strip-rate` tripwire fires if a
live body strips far below its shape's expectation.

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

> [!@bukzor] ruled 2026-10-01, recorded sensatim. "Broad and stable" is a claim
> about *which* text, not just how much of it: "a good `match.md` will match all
> content that's relevant to the rule and _only_ content that's relevant to the
> rule _even under future revision_". Build `match` only from strata that survive
> revision and keep exact prose in `search`, where its exactness is what makes
> drift loud. Exactness in `search` is a feature; exactness in `match` is a bug.
>
> The strata, most to least durable:
>
> - **Structure** -- a section heading, the blank line between a heading and its
>   content, list nesting. Format decisions, changed on a slow clock.
> - **Identifiers** -- tool names (`Bash`, `Read`, `Edit`, `Write`). Product API,
>   so renaming one breaks everything; but a reword can route around them ("the
>   shell", "the dedicated file tools"), which makes them weaker than structure.
> - **Prose** -- wording, punctuation, whitespace, example lists such as
>   `cat, head, or sed -n`. Expected to perturb between releases, and observed
>   doing it: upstream added `find`/`grep` to the Bash avoid-list at 2.1.261 and
>   dropped both again at 2.1.267.
>
> Prose in `match` fails quietly, which is the expensive direction: the rule falls
> out of scope, the text it was stripping rides through unpatched, and the only
> detector left is a human noticing the behavior change. Prose in `search` fails
> loudly, which is what `failed-to-match` is for. Where a coarse-but-specific
> `match` is wanted, take it from structure, not from a long literal shared
> between two wordings of the target -- that literal is still prose.

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
- `$LINES` — matches zero or more non-empty lines

Placeholders are delimited by the next literal text in the template.
Same-named placeholders must match the same text (backreference); use a
unique name when you don't care. Trailing digits vary the name without
changing its type — `$LINES1` and `$LINES2` are two independent
LINES-type placeholders.

### Templates match whole lines

Every template matches whole lines: its first line must start at a line start
and its last line must run to a line end (a template that begins with `\n`
already says where it starts). A template whose edge falls mid-line
declares it with a placeholder -- `$PRE` ahead of the literal for text before
it on the line, `$PLATFORM`-style holes after it -- so the file reads the way
it matches. Without that, a rule matches a quoted or indented copy of its own
target (replayed tool results ride in `role: "system"` messages, rule files
included), and matches text its own replacement just wrote.

A hole that absorbs a mid-line edge is captured, so `replace.md` has to
re-emit it (`$PRE`) or it deletes what the hole covered.

### Files and trailing newlines

> [!@bukzor] ruled 2026-10-01, recorded sensatim. "I believe all files should
> be treated identically whether they have a trailing newline or not. The
> trailing newline behavior is too unpredictable in too many software for it to
> be load-bearing."

Every file in this dialect is read by stripping one trailing newline if there
is one, and written by appending one (`textfile`), so a file with and without
its final newline is the same file, and an editor or end-of-file fixer cannot
change what a rule means. A template therefore never ends in the line break of
its last line: that break belongs to the body, and the template matches up to
it. To make a template end in a blank line, end the file in two newlines.

Two consequences. A rule whose rewritten text is empty -- an empty `replace.md`,
or a `$PRE`-style one over nothing -- deletes lines, and a deleted line takes
one line break with it: the one that follows, or at end-of-body the one that
precedes. And a `replace.md` holding a lone newline is the empty replacement,
not a blank-line insertion; write the blank line as content if one is wanted.

The convention governs files, not wire text. A body arrives from the network
with whatever trailing newline upstream sent, and the end-of-line anchor
absorbs it; "strings in memory have no trailing newline" is true only of
strings that came from disk.

`$NAME` in `replace.md` re-emits what the search's same-named
placeholder captured — how a rewrite keeps dynamic content it can't
know ahead of time (session paths, branch names); see
`strip-scratchpad-bloat`. A name the search didn't capture is a
patch-config error and fails hard (caught by `check_patches.py`, not at
proxy time).

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
python3 check_patches.py   # newest unsuffixed capture in system-prompts.kb/
python3 check_patches.py system-prompts.kb/v2.1.221-opus.md  # a specific one
```

## Current patches

See each subdirectory. Per-patch `README.md` is optional; the directory
name plus `match.md` is usually self-evident.
