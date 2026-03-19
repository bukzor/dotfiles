# Design Rules

Principles for API and type design, learned from hands-on sessions.
Language-agnostic rules live at root; language-specific rules in nested `.kb/` collections.

## Collections

- Root (`design-rules.kb/*.md`) — language-agnostic design principles
- `rust.kb/` — Rust-specific rules, patterns, and known limitations

## What belongs here

- Principles about naming, abstraction boundaries, API shape
- Derived from actual design sessions, not theoretical
- Actionable during design and code review

## What does NOT belong

- Language syntax or tooling notes
- Implementation details or how-tos
- Known limitations or gotchas (those go in language-specific `.kb/` collections)

## After a design session

Review the session with the user for learnings worth capturing. Not every
session produces design rules — only add entries when a principle was
discovered or refined. Present candidates to the user for scoping and
refinement before writing entries.

### What to capture

Look for moments where:

- The design changed direction — what principle drove the change?
- A mistake was made and corrected — what rule would have prevented it?
- A decision felt arbitrary until a tiebreaker resolved it
- A language-specific gotcha caused confusion — is it likely to recur?

Known limitations go in `{language}.kb/`, clearly framed as limitations.

### Generalizing

Session learnings are specific: "we should have used closures by default."
Design rules are transferable: "design for the primary use case." Generalize
from the specific decision to the underlying principle. The session is
evidence for the rule, not the rule itself.

### Validating

Mentally replay the session with the notes available. Would these rules have
gotten us to the final design more directly? Missing detour coverage →
missing entries.

### Entry format

- Positively-stated title (what to do, not what to avoid)
- A diagnostic: how to recognize when this rule applies
- A `## Source` section citing the session and date
