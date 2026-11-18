---
source: agent
status: exploratory
see-also:
  - spectrum-not-singular.md
---

# Candidate: multi-location

A short ambient rule in `~/.claude/CLAUDE.md` references spectrum-
not-singular as a foundational principle, with one or two sentences
of operational guidance. Detail and worked examples live in a
trigger-gated `must-read.d/` entry and/or in the
`claude-realignment` skill.

The fit addresses both the universal-applicability concern (CLAUDE.md
ensures the principle is loaded every turn) and the
worked-detail concern (the longer treatment doesn't bloat ambient
context).

The cost is split-source maintenance. Two or three locations have
to stay in sync. Future drift between them is likely without an
explicit cross-reference convention. The kb's `see-also` frontmatter
is one mechanism that can help; another is a "canonical-location"
pointer in each location indicating where the authoritative version
lives.

A specific instantiation worth considering: ~50 words in CLAUDE.md
under Behavioral Posture ("In the face of uncertainty, treat answers
as a spectrum; collapse to a single answer only above 80% posterior;
under rejection, recompute the distribution before committing"),
with longer treatment as a `must-read.d/before/` entry whose trigger
is "before producing an inference under uncertainty" — accepting
that this trigger is ambient-flavored and that the longer entry
mostly serves as the authoritative reference rather than as a
gated lazy-load.
