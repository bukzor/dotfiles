Condense `# Scratchpad Directory` to its one-sentence rule plus the
dynamic path.

The stock section spends an all-caps IMPORTANT, five example bullets,
and two trailing paragraphs on "put temp files here, not `/tmp`". The
path itself is session-generated and must survive the rewrite --
`$SCRATCHDIR` in `replace.md` re-emits what the search captured
(replace-side expansion, see the top-level README).

Gated on the section heading, so any drift in the body wording is a
loud search miss; the heading itself vanishing means the section is
gone and silence is correct.
