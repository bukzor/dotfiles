# Devlog: 2026-09-10 — tmux window naming: a precedence ladder, not a program list

## Focus

Twenty-five windows, and the status bar called nearly all of them `bash`
or `claude`. Root cause: `automatic-rename-format` was tmux's stock
`#{pane_current_command}` -- the one attribute every pane shares -- while
each claude pane was already publishing a meaningful `pane_title` that the
format threw away. The first fix drafted was "detect claude and use its
title"; the user rejected that shape outright: "Please don't special case
like this. Instead (help me) devise a methodology that's more
general-purpose."

## Decisions

### Name a window by a precedence ladder, not by what runs in it

**Rationale:** three rungs, in order -- a name I assigned wins, else the
program's own declared title, else an inference from the running command.
Each rung is a fact tmux already tracks, and the format names no program:

- *assigned* -- `rename-window` sets a window-local `automatic-rename off`.
  That bit already means "a human named this"; nothing else must set it.
- *declared* -- `#{pane_title}`, which is OSC 2. A fresh pane's title
  defaults to the **hostname**, so `#{==:#{pane_title},#{host_short}}`
  reads as "undeclared", alongside empty.
- *inferred* -- `#{pane_current_command}`, tmux's stock behavior and all
  it could ever offer, now the fallback rather than the whole policy.

Truncation is from the left with an elision mark
(`#{=/-24/…:...}`), because paths and conversation titles both
discriminate at their tail.

**Alternatives considered:**

- *Match `pane_current_command` against `claude`* -- the special case the
  user forbade. It also fails every other program that declares a useful
  title (vim, ssh, psql) and would need a new branch for each.
- *Fix it in `status-right` only* -- `#{=21:pane_title}` was already there.
  The window **list** is where you look to switch windows; that was the
  surface that lied.

### The shell declares its cwd (`.config/sh/rc.d/pane-title.sh`)

**Rationale:** a title outlives the program that set it, so a pane whose
program exited keeps advertising work that ended -- and an undeclared pane
reports the hostname, which names nothing. A shell only knows its
directory, but declaring that beats both alternatives. Cross-shell via
zsh's `precmd_functions` and the bash `prompt_commands` shim.

### Assert `allow-rename off` even though it is already the default

**Rationale:** the ladder's opt-out marker *is* `automatic-rename off`.
With `allow-rename on`, any OSC 2 would rename the window directly and
silently switch that same bit off -- so a program declaring a title would
be indistinguishable from a human naming the window, collapsing rungs 1
and 2. The config now asserts the invariant it depends on instead of
inheriting it.

### `alert` names its origin exactly as the status bar names it

**Rationale:** `automatic-rename-format` has already resolved "what is
this window"; re-deriving it in the alert would be a second, drifting
answer. `alert` reads `#{window_name}` back out of tmux. It also appends
to `~/.local/state/alert.jsonl` -- a notification is gone the moment it's
dismissed, and the log is what's left to ask afterward what wanted you,
from where, and whether it arrived.

### Mark claude windows with U+EC82, not U+2733

**Rationale:** claude-code prefixes its declared title with an
eight-spoked asterisk (U+2733) plus a space. In the status bar that reads
as one of tmux's own window flags (`*`, `-`, `#`, `!`, `~`, `Z`) and
spends a column on the separator. U+EC82 is `cod-claude` in Nerd Fonts
3.5.1's Codicon block -- a twelve-point mark no flag resembles. Verified
against the release's `glyphnames.json`, not by search.

## Conventions Established

- **A probe must discriminate between hypotheses**, not merely produce an
  outcome consistent with the one you expect. Testing whether a glyph
  renders, I built a probe whose expected-failure appearance (an empty
  cell) was identical to my own bug's appearance (never emitting the
  bytes) -- so its result could not move belief either way, and I read it
  as confirming a prior I had already formed from weak evidence. Two
  controls were sitting right there unused: a glyph known to render, and
  an earlier `xxd` showing the bytes were fine.
- **Verify bytes before asking a human to interpret a rendering.**
  Generate the sample with `python -c` and `chr(0x...)`, confirm with
  `xxd`, then ask. Glyphs typed into a shell command are not evidence that
  those bytes reached the terminal. hterm also renders with a
  ChromeOS-side font, so crostini's `fc-list` is not authoritative for
  what the user actually sees.
- **tmux re-derives an automatic name only on pane activity.** After
  `source-file`, idle windows keep their old names indefinitely; they look
  like they opted out. Separate "opted out" (`automatic-rename off`) from
  "stale" (inherited `on`) with data before touching live state.
- **`rename-window ''` is a trap:** tmux takes the empty name literally,
  leaving the window nameless *and* still opted out. Releasing the option
  (`set-window-option -u automatic-rename`) is what "let the program name
  this again" actually requires -- `bin/tmux-rename-window` exists for
  exactly this.

## Open Questions

- The mark sits at the head and names truncate from the tail, so any title
  over 24 columns loses it. A three-branch format that pins the glyph and
  truncates only the body would fix it; not yet asked for.
- `alert.jsonl` grows without bound and has no rotation.
- `log_alert` runs after the notification is already out, under
  `set -e` -- a logging failure would exit non-zero on an alert that
  actually reached the user.
- The 24-column budget was chosen against this terminal's width and has
  not been tuned against a narrow one.

## References

- Commits `87cb6b3` (naming policy + `pane-title.sh`), `f2b773d` (alert
  identity and log), `a90da60` (glyph substitution), `739968b`
  (`bind-key ,` releases the name).
- `man tmux` on `#{=/N/marker:...}` -- appends the marker only when the
  value was actually trimmed.
