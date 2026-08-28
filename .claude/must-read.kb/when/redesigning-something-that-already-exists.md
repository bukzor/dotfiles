---
triggers:
    - read: ~/repo/github.com/bukzor/ideation.epistemics/preservation-audit.md
---

# When redesigning something that already exists

Triggers on the incumbent, not the request: any shipped schema, working
convention, or live system your answer could change.

## The incumbent is evidence, not canon

Admissible as **prior art** (design moves worth taking on their merits)
and as **evidence of past intent** (which problems were felt worth
solving, in what order). Both defeasible — a policy can be wrong, and
an old policy can be wrong about a situation that has since changed.

Inadmissible: incumbency itself, and **adoption statistics**. How often
a feature is used is caused in part by how good the design is, so
reading usage as a signal of what to build is circular. Nobody drinks
from the fountain behind the gym -- because nobody is thirsty, or
because it is behind the gym? Counting drinkers cannot tell you which.
If you catch yourself counting instances to justify a design decision,
stop.

## Discarding canon converts its virtues into debt

The new design owes a side-by-side. For each aspect of the incumbent
worth keeping: **improves**, **preserves**, or **obviates**, argued.
"Obviates" is legitimate — an aspect can stop being needed once the
principles are applied — but it must be stated and defended. Silence is
not a verdict, and an aspect lost without one is a regression, not a
simplification.

## A verdict has four cells

Grain first: decompose the incumbent at the finest grain that moves
independently — a field, a file, a capability, a concept — not the
grain its packaging suggests. The moves that matter most are the ones
packaging hides: a capability migrating between skills, a column
between tables.

Then the side-by-side names each part's fate, and a fate has four
cells, none left silently empty:

- **Placement** — where it lives in the successor: moved, split,
  merged, or nowhere (that's "obviates", argued as above).
- **Name** — kept or changed.
- **Route** — how a holder of the old address, name, or habit reaches
  the new one: stub, alias, redirect, dual-read, migration guide.
  "No route needed" is a finding (you looked, and there are no
  readers) — never a default.
- **Schedule** — now, later, or on-tripwire; a punt is a ruling and
  goes on the record.

The treatment of the whole incumbent — adjust, reform, replace,
retire — is derived from the filled cells, never chosen first. The
worst misses concentrate in the cells most often skipped: route
(readers stranded) and schedule (lifecycles never written). Silence
is not a verdict, cell-wise too.

## A binary design question usually names the wrong variable

This is the highest-yield move here. When a choice arrives as two
options, suspect the framing before choosing between them.

- *Fix up the old treehouse vs. build a fresh one* -- both branches
  measure distance from the old treehouse, which smuggles in the
  authority the question was meant to test. The real question was what
  makes a good treehouse.
- *Give the class rabbit away vs. keep it* -- the argument is over
  whether the **rabbit** stays. But every actual complaint traces to
  the cage sitting **by the door**, where it startles everyone coming
  in. Rabbit and cage-spot are independent variables, so the trade was
  fake: keep the rabbit, move the cage, and both objections cancel.

The tell is a choice that feels like a forced trade-off where each
option loses something you want. That usually means two independent
variables have been fused into one. Separate them and the trade often
dissolves entirely.

## Check reality before building on it

- **Verify the premise the design rests on.** A field trip planned
  around "the zoo is open on Mondays" is worth one phone call before
  the bus is booked. The same call is how you learn nobody ever
  collected the permission slips.
- **Prefer the mechanism that already exists and already runs.** Before
  hiring a new keeper to count the penguins, ask what the feeding log
  the keepers already fill out would show if the pens were labeled
  differently. Reshaping the data so an existing tool fires beats
  building a new tool.
- **Dogfood before proposing.** Try the new rule on your own game
  first. A rule that sends you off the playground is evidence it
  bites.

## Be explicit about what is not derived

When a design claims to follow from principles, state what the
principles do *not* imply. "The principles demand a sandbox" -- no, the
sandbox stays because kids like sand; say so. Ergonomic keeps are
legitimate; smuggling them in as derivations is not. Name them and mark
them as needing a decision.

## Receipts

Real executions, kept as evidence that the rules bite -- not as
templates to imitate:

- `ideation.epistemics/preservation-audit.md` -- the side-by-side
  against a shipped schema, with a verdict per aspect;
  `repo-weight-derivation.md` beside it has the "what the axioms do
  not imply" section.
- The rabbit and the phone call both happened, less charmingly: a
  keep-vs-delete debate dissolved once content and path were separated
  as variables, and a 30-second probe of an assumed tool behavior
  reversed a design and surfaced 16 references nothing had ever
  checked.
- The four cells, filled in the wild (bukzor-agent-skills): the
  llm-discourse-graph reform grew one open question per cell
  (`extension.kb/`: what-becomes-of… / what-the-successor-is-called /
  where-the-migration-guide-and-its-trigger-live /
  when-does-the-reform-execute), and "delete it outright" lost on
  route; the verdict-schema batch's route cell was one sentence —
  "absent means accepted, so no claim on file needs migration" — that
  made the change free for every old reader; the 2026-08-18 census
  retirement deleted without a stub only after `grep` returned zero
  readers — an empty route cell filled by looking, not by default.
