# Editing Documentation

- **80% confidence threshold** — edit when reasonably confident; discuss first only when genuinely uncertain.
- **Discussion over speculation** — for uncertain concepts or design decisions, discuss with the user before writing. Don't guess.
- **Breadth-first validation** — review higher-level docs before diving into subdocs; a subdoc may prove unnecessary if the main doc already covers it.
- **Code lives in files, not in docs** — default policy. A doc *names* a runnable path (`{prefix}.py` beside the thing it checks, or `{prefix}.d/` once that's more than a file or two); it does not carry the program inline. Same for a program smuggled into a YAML scalar. Reason: code in prose can't be run by the user, `black`ed, `pyright`ed, or reviewed as a diff — and it silently forks from the copy that actually runs. Illustrative fragments, signatures, and command transcripts stay welcome; an implementation does not.
- **Write for the reader, not the author** — delete internal vocabulary, disambiguation against alternatives the reader never sees, and generic-skill tutoring (shell/editor mechanics) they already have. Keep mechanism only when it backs a guarantee the reader relies on. Fix by subtracting, not clarifying.
- **No revision scarring** — a doc whose purpose is current state carries no account of past-but-moot states: what it used to say, what was wrong before, which draft was rejected. State what is. Where a superseded thing must stay reachable, it is because a reader still acts on it — a constraint that stops a future simplification, a fact that stops a false claim returning — so write that constraint or fact in the present tense, not its history. The history belongs in the commit message or a session narrative.

  > [!@bukzor] ruled 2026-09-17, recorded sensatim — the substance is the
  > ruling, the wording is the agent's.
- **Markdown links: reference-style with a footer** — `[label]` inline, `[label]: target` in a block at the end of the doc, not inline `[label](target)`. DRY when a target is linked more than once (one definition serves every use), and keeps prose free of URL clutter.

Workflow: **discuss** the concept with the user → **read** existing content → **evaluate** its accuracy/completeness → **correct or rewrite** with confidence. Not mechanical fill-in-the-blanks — reach certainty before changing anything.
