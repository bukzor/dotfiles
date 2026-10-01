# Scope of confidence-level frontmatter

The `source` and `status` frontmatter convention introduced in this
kb proved useful for capturing how settled each item is. The open
question is how widely the convention should propagate. Each file
in this collection is one candidate scope.

## What belongs here

A file per candidate scope. Each describes (a) which files would
get the frontmatter convention, (b) what the convention adds in
that scope, and (c) what it costs (maintenance, file size,
ceremony for content authors).

## What does NOT belong

- Variants of the schema itself (different field names, different
  enums) — those are independent design questions and should not
  conflate with the scope question
- Tooling decisions about how to validate or query the frontmatter
- Application of the convention to non-Claude documentation outside
  the alignment scope
