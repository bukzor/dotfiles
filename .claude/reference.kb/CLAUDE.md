# Reference

Authoritative reference knowledge, kept out of the trigger system. Each file is
the single authority on one clearly-scoped topic, pulled in on demand via
`requires:` from a `must-read.kb/before/` trigger.

Distinct from its neighbors:
- `design-rules.kb` — API & type *design* principles
- `user-preferences.kb` — how Claude communicates with the user
- `must-read.kb/before/` — trigger-shaped "read before X" docs

## File naming

A file's name states its **authoritative scope** — what it is the authority on.
`bash-conventions.md` is authoritative on bash conventions; a bare `bash.md`
would wrongly claim all of bash.

## Entry format

- Positive titles — what to do
- Elide ambient knowledge: a capable model knows the basics; write only what it
  wouldn't already do
- Terse framing + code examples over prose
- If deleting a sentence wouldn't cause a mistake, delete it
