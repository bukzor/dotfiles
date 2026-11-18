---
managed-by: Skill(llm-subtask)
status: open
cost-benefit-sweh:
  timebox:
    '@value': 3
    rationale: home decision first, then extract convention + hoist 6 policies / 3 goals preserving force/why chains
    confidence: tentative
  benefit-2w:
    '@value': 0.3
    rationale: no second language template exists yet to consume the hoisted convention within 2w
    confidence: tentative
  cost-of-delay-2w:
    '@value': 0.1
    rationale: source artifacts are stable and validated; low decay
    confidence: unsure
---

# Hoist polyglot-monorepo architecture (convention + values) to personal-global scope

**Priority:** Medium
**Complexity:** Medium
**Context:** Surfaced during the 2026-06-24/25 design conversation captured in
`~/repo/github.com/bukzor/template.python-project/discourse.kb/` (descriptive
reasoning) and its design tower
`…/docs/dev/design/` + `…/docs/dev/technical-policy.kb/` (normative values).
Those artifacts flag themselves as **hoist candidates**.

## Problem Statement

The polyglot-monorepo architecture — a *convention* (the `apps/ lib/ packages/`
maturity ladder, the hosting contract, buck-as-unifying-spine-behind-native-
tools, compose-on-demand) plus a set of non-negotiable *values* — currently
lives only inside `template.python-project`. But it governs **all** repos, and
future per-language templates would each re-derive it. It needs a single
canonical home that every repo/template references instead of re-deriving.

## Current Situation

Captured, validated, but mis-scoped (lives in one repo):
- **Descriptive** (what's true / what follows): `template.python-project/discourse.kb/`.
- **Normative** (what we want / the rules): the design tower —
  `…/docs/dev/design/020-goals.kb/` (drive-by-friendly, disposable-components,
  uniform-polyglot-model) and `…/docs/dev/technical-policy.kb/` (self-similar,
  dependencies-stay-a-dag, no-version-lockstep, cross-repo-via-published-
  artifact, buck-behind-native-tools, homogeneity-and-robustness, each with an
  RFC-2119 `force`).

## Proposed Solution

Extract a **canonical convention artifact** + **hoist the design-tower values**
to a personal-global scope; each language-template then *implements* the
convention per-ecosystem rather than embedding its own copy.

## Implementation Steps

- [ ] **Decide the home** (see Open Questions) — `~` design scope vs a dedicated
      repo. **This may fit better under `private.bukzor-llc`** than under `~`.
- [ ] Extract the architecture **convention** (maturity ladder, hosting
      contract, buck-spine-behind-native, compose-on-demand) into a canonical
      design-kb / doc at the chosen scope.
- [ ] Hoist the design-tower **values** (the six `technical-policy` rules + three
      goals) to that scope, preserving `force` and `why:` chains.
- [ ] Repoint `template.python-project` (and future per-language templates) to
      **reference** the canonical convention rather than embedding it.

## Open Questions

- [ ] Right home: `~/.claude` design scope vs the **`private.bukzor-llc`** repo? (Flagged
      by bukzor as the likely better fit — it reads as org/business-level
      cross-cutting architecture, not just personal dotfiles.)
- [ ] One canonical artifact (a single design tower) or split (convention doc
      separate from the values)?
- [ ] How do downstream repos *reference* it — copy on scaffold, submodule,
      published doc, or lexical-scope resolution?

## Success Criteria

- [ ] A single canonical home holds the convention + values; `template.python-
      project` references it instead of owning it.
- [ ] A second repo can adopt the architecture *by reference*, without
      re-deriving the convention or re-stating the values.

## Notes

Source of record for the reasoning behind every value/decision is the
`discourse.kb` in `template.python-project`; do not re-litigate there —
extract and reference. The repo-specific next-actions (rename the repo,
Python+Node buckify proof, cell-alias spike, third-party-importer derisk) are
**not** part of this hoist; they stay in `template.python-project`.
