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
it appears live; a match that short hits the quotation and deletes the steer
body out of the transcript a reader is looking at. What separates the two is
the blank line: in a quoted copy the heading is followed by `2\t`. The hole
rather than the body verbatim keeps the match one line long and keeps a single
trailing newline at the end of the file, where an end-of-file fixer cannot
quietly change what it means. This is the collision
`.claude/ideas.kb/2026-08-20-000-Audit-heading-anchored-match-md-templates-for-self-referential-collision-risk.md`
describes.

Loudness follows from the split: `match` finds the envelope, `search` picks
the arm, so a reworded body is a search miss under a holding match -- loud. A
reworded *heading* is a match miss, which is silent, and the steer then rides
through unpatched. That is the residual exposure.

## The relaxed arm is reconstructed

`search.d/relaxed.md` comes from the CLI's compiled template, not from the
wire; only `strict` has been served here. Should the relaxed arm arrive and
the reconstruction be off by a character, the search miss is loud -- the
wanted outcome, since what it reports is that the reconstruction was wrong.
