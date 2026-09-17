Strip the in-prompt parallel-tool-calls guidance.

The API server appends its own tool-use preamble (generated from the
`tools` param, never present in the request body, so unpatchable) whose
closing line already states the whole policy: parallel when independent,
sequential when dependent. The in-prompt copy is a pure duplicate of
text the model receives anyway.

Two shapes carry it, so the match/search pairs are per-shape:

- harness (opus-5/fable-5 since v2.1.221, fable-class since v2.1.186):
  a trailing sentence on the "Prefer the dedicated file/search tools"
  bullet. `search.d/harness.md` has no trailing newline on purpose --
  the deletion must keep the bullet's first sentence and its newline.
- long-form (sonnet-5): a whole ~380-char bullet under `# Using your
  tools`, byte-identical v2.1.76 through v2.1.221; its tail rides on
  `$REST` so wording churn there stays in scope.

Gates are the enclosing headings (`# Harness`, `# Using your tools`),
so the duplicate vanishing upstream -- the fix we actually want -- is a
loud search miss, not a silent one.
