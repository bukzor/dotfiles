# attention-costs.kb — maintenance guide

The four theories of `../attention-costs.md`, each `X.md` beside `X.kb/`.
The defining claim carries the ontology and the priors; read it before
adding under it.

## Where a new claim goes

By the words it needs, not the topic it touches:

- needs a number reproduced from the corpus, and nothing else -> `measurement.kb/`
- about how billing responds to *when* a token arrives -> `cost-structure.kb/`
- about what can be known before acting, or how accurately -> `estimation.kb/`
- about choosing between agent attention and the operator's -> `decision.kb/`

A claim needing words from two theories belongs in the outermost one that
coins all of them, which is usually `../attention-costs.md` itself.

## Standing discipline

- `bare` requires either a `verify:` naming a command that runs today, or
  `why:` premises that settle it. Bare with neither is a hidden judge.
- `agent` is the operator's review queue and only grows until reviewed.
  Use it where a real judgment remains, not as caution.
- Numbers go in claims that name the `claude-tokens-params` section
  producing them. A number quoted with no route back to a command is the
  failure this collection is shaped to prevent.
