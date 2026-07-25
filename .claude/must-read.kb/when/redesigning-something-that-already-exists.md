---
depends:
    - ~/repo/github.com/bukzor/ideation.epistemics/preservation-audit.md
---

# When redesigning something that already exists

Triggers when there is an incumbent: a shipped schema, a working
convention, a system you are being asked to improve, replace, patch, or
decide about.

## The incumbent is evidence, not canon

Admissible as **prior art** (design moves worth taking on their merits)
and as **evidence of past intent** (which problems were felt worth
solving, in what order). Both defeasible — a policy can be wrong, and
an old policy can be wrong about a situation that has since changed.

Inadmissible: incumbency itself, and **adoption statistics**. How often
a feature is used is caused in part by how good the design is, so
reading usage as a signal of what to build is circular. Rarity cannot
distinguish "not needed" from "too much friction to record." If you
catch yourself counting instances to justify a design decision, stop.

## Discarding canon converts its virtues into debt

The new design owes a side-by-side. For each aspect of the incumbent
worth keeping: **improves**, **preserves**, or **obviates**, argued.
"Obviates" is legitimate — an aspect can stop being needed once the
principles are applied — but it must be stated and defended. Silence is
not a verdict, and an aspect lost without one is a regression, not a
simplification.

## A binary design question usually names the wrong variable

This is the highest-yield move here. When a choice arrives as two
options, suspect the framing before choosing between them.

- *Patch vs. rewrite* — both branches measure edit distance from the
  incumbent, which smuggles in the authority the question was meant to
  test. The real question was what the principles imply.
- *Tombstone vs. delete a retracted node* — both ask whether the
  **content** survives. What the tooling tested was the **path**. Those
  are independent, so the trade was fake: keep the body, break the
  path, and both objections cancel.

The tell is a choice that feels like a forced trade-off where each
option loses something you want. That usually means two independent
variables have been fused into one. Separate them and the trade often
dissolves entirely.

## Check reality before building on it

- **Verify the premise the design rests on.** A design justified by
  "tool X behaves like Y" is worth a 30-second probe. Doing this once
  reversed a design decision *and* surfaced 16 references that had
  never been checked by anything.
- **Prefer the mechanism that already exists and already runs.** Before
  specifying a new walker/checker/daemon, ask what the existing tools
  would report if the data were shaped differently. A naming convention
  that makes an existing tool fire beats a new tool.
- **Dogfood before proposing.** Run the change on your own artifact
  first. A rule that rejects your own work is evidence it bites.

## Be explicit about what is not derived

When a design claims to follow from principles, state what the
principles do *not* imply. Ergonomic keeps are legitimate; smuggling
them in as derivations is not. Name them and mark them as needing a
decision.

## Worked example

`ideation.epistemics/preservation-audit.md` — the side-by-side against
a shipped schema, with a verdict per aspect. `repo-weight-derivation.md`
beside it has the "what the axioms do not imply" section.
