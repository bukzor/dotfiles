# Retune the auto-mode bash-first steer

Claude Code injects a steer into a `role: "system"` message whenever the
per-session assignment `bashFirst` is on, telling the model to do file work
through Bash rather than Read/Edit/Write. Two wordings ship: `strict` allows a
dedicated tool only when Bash "genuinely cannot do the job", `relaxed` keeps a
carve-out for edits a shell would botch. Which one arrives is the gate
`tengu_cozy_teapot` -- env override `CLAUDE_CODE_COZY_TEAPOT`, values `strict`
or `relaxed`, compiled default `strict`.

This patch deletes either body. Nothing replaces it: the harness prompt
already carries "Prefer the dedicated file/search tools over shell commands
when one fits" unconditionally, which is the preference we want at the
strength we want. Deleting the steer leaves that line standing alone -- which
is exactly what a session with `bashFirst` off already gets, so the patch
moves every arm of the gate onto the control arm.

The heading stays: it is part of the `match`, and it is also true -- auto mode
is active. Keeping it is also what makes a second item under that heading
survive, should upstream ever add one.

## The match is the envelope

`match.md` is the heading, a blank line, and `$STEER` -- one whole line of
steer text. The heading alone is not enough to scope it. Any session that
reads these files gets them back as line-numbered tool results, and those ride
in a `role: "system"` message too, so the heading appears quoted as often as
it appears live; a match that short hits the quotation. What separates the
two is the blank line: in a numbered copy the heading is followed by `2\t`.
The hole rather than the body verbatim keeps the match one line long.

`match` only answers "is this message in scope?" -- it does not localize the
rewrite. `search` is matched over the whole body and takes its leftmost hit,
so what keeps a quoted copy of a steer arm from being deleted in place of
the live one is that every template matches whole lines (the patch README):
a numbered, `>`-quoted or indented copy never starts at a line start. An
unnumbered verbatim copy of the arm, with the arm at a genuine line start in
both places, is not excluded by that; the leftmost one still wins.

Loudness follows from the split: `match` finds the envelope, `search` picks
the arm, so a reworded body is a search miss under a holding match -- loud. A
reworded *heading* is a match miss, which is silent, and the steer then rides
through unpatched. That is the residual exposure.

## Both arms match text served here

`search.d/strict.md` and `search.d/relaxed.md` each match, byte for byte, a
body served to this host -- `strict` throughout, `relaxed` on three sessions
of 2026-09-16 (v2.1.273). Should upstream reword either arm, the search miss
is loud -- the wanted outcome, since what it reports is that this directory
no longer matches the wire.
