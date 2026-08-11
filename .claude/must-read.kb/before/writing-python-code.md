---
requires:
  - ~/.claude/reference.kb/python/style.md
---

# Writing Python code

Style is authoritative in the required reference (Python 3.13 target).

When writing or modifying tests, follow `writing-tests.md` — in your own code or
others', and especially in unfamiliar code where tests verify your understanding
before you change behavior.

Code a doc needs goes in a file, never inline in the doc or in a YAML scalar:
`{prefix}.py` beside the doc that cites it, or `{prefix}.d/` once that's more
than a file or two. Then it is runnable by hand, `black`-clean and
`pyright`-clean, and reviewable as a diff. See `editing-documentation.md`.
