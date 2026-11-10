# Mirror the source's distinctions — no more, no fewer

Whatever owns the domain — the data, the engine, the protocol, the business —
already decides what is the same and what differs. Your model's special cases
should be exactly the source's.

## Diagnostic

For every special case in your model, point to where the source makes the same
distinction. Can't? Delete it. For every place the source branches, check that
your model branches there too.

- **Added a distinction** the source lacks: a sentinel or placeholder value, a
  flag standing in for a category, two fields that move in lockstep, a branch on
  a condition the source never tests.
- **Erased a distinction** the source makes: one field or formula that's right
  for most cases and quietly wrong for a few.

## Examples

- Guns modeled apart from abilities, with a `(gun)` sentinel and a `weapon`
  column only it filled — but the engine binds guns to slots like any ability.
  Keyed by the engine's own `slot`, the sentinel and the lockstep column vanished
  and secondary guns stopped being misfiled.
- `is_admin: bool` beside a `role` enum: a second encoding of a distinction the
  domain already makes once.
- One DPS formula for all guns was quietly wrong for burst guns, where the game
  branches. The fix branches exactly there — and normalizes a raw field the game
  ignores off that branch, rather than special-casing more widely.

## Corollaries

- Table and type boundaries follow the source's kinds, not sparsity patterns:
  two structures the source keeps separate stay separate even when their rows
  look alike; one kind stays together even when its fields are sparse.
- Keep inert raw values in the output; normalize them at one point in code, so
  the derived logic needs only the source's own branches.

## Finding the source's distinctions

Where the data is ambiguous, ask ground truth (observed behavior, the reference
implementation's output) — and believe it over elegance. `(burst − 1) × intra`
was the tidier formula; four in-game readings refuted it, and the game's
`burst × intra` stood.
