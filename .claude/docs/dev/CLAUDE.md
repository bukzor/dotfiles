# docs/dev — maintenance guide

Development records for `~/.claude` itself: why it is shaped the way it
is, what was tried, and what is currently held true.

## The collections

- `adr/` — decisions, dated. One file per decision, kept after it lands so
  the reasoning outlives the memory of it.
- `devlog/` — session narratives, dated. What happened, in order.
- `claims.kb/` — commitments that outlive one session and one project,
  each carrying its own standing and reasons (`Skill(llm-claims-kb)`).
  `claims.md` is the entry point.

## Which one

The three differ by what a reader wants from them, and confusing them is
the common failure:

- a **narrative** of what happened, at a time -> `devlog/`
- a **choice** and its alternatives, at a time -> `adr/`
- a **belief** held now, with its warrant and its judge -> `claims.kb/`

A claim is not dated, because it is asserted until revised; an ADR and a
devlog entry are, because they record acts. When a claim changes, the git
diff is the record — the file is edited in place, never appended to.

## What does not belong

Instructions for an agent. Those are skills, `must-read.kb/` entries, or
`CLAUDE.md` text — directives rather than records, and nothing about them
is contestable in the way a claim or a decision is.
