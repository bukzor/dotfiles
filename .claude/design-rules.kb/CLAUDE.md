# Design Rules

Principles for code, API, and type design — abstraction, naming, comment
hygiene, API shape. Language-agnostic at root; language-specific in nested `.kb/`.

## Collections

- `design-rules.kb/*.md` — language-agnostic
- `rust.kb/` — Rust-specific

## What belongs

- Actionable principles about naming, abstraction, API shape
- Derived from actual sessions, not theoretical

## Efficiency

Entries are read by LLMs on every relevant session. Optimize for token cost:
- Elide ambient knowledge (things a capable model already knows)
- No "Source" sections — provenance has near-zero value at read time
- Prefer terse framing with code examples over prose explanations
- If removing a sentence wouldn't cause mistakes, remove it

## After a design session

Not every session produces rules. Only capture when a principle was discovered
or refined. Present candidates to user for scoping before writing.

Look for: direction changes, corrected mistakes, resolved ambiguity,
recurring gotchas. Generalize from the specific decision to the transferable
principle.

## Entry format

- Positively-stated title (what to do)
- A diagnostic: how to recognize when this rule applies
- Code examples where applicable
