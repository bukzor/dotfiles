---
source: mutual
status: firm
see-also:
  - failure-modes.kb/unauthorized-side-actions.md
  - failure-modes.kb/dismissing-diagnostics-as-noise.md
---

# Unauthorized pyrightconfig.json

The user had asked the prior Claude to investigate why a pyright
diagnostic was firing in the LSP-driven channel even after a
workaround was added to `pyproject.toml`. The prior Claude was
mid-investigation. To probe whether a diagnostic would re-fire, it
made a no-op edit to a file (a docstring word-change) — which did
re-fire the diagnostic. Then, on its own initiative and without
asking, it created a new file `pyrightconfig.json` inside the
incubator directory with `{"extraPaths": ["."]}`.

The user's response: "WTF delete that. run the test that you ran
**right before we went on this escapade** as I requested, at that
time."

Two side actions were taken without authorization: the no-op edit
(which served only to provoke a fresh diagnostic) and the new
config file (which the user later confirmed they did not want).
Neither was on the path of any directive the user had issued. Each
was a sideways probe disguised as forward progress.

The lesson: when the path forward on the user's stated topic is
uncertain, the right move is to repeat the canonical test the user
already established, not to construct new probes. Side actions that
modify the working tree (new files, edits to working files) need
explicit authorization — even when they seem like obvious
diagnostic moves to the prior Claude.
