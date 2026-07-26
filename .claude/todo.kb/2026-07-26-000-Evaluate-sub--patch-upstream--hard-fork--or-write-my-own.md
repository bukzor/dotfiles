---
managed-by: Skill(llm-subtask)
status: open
---

# Evaluate sub: patch upstream, hard-fork, or write my own

**Priority:** Medium
**Complexity:** Low per step; the decision needs dogfood evidence first
**Context:** [juanibiapina/sub](https://github.com/juanibiapina/sub) -- Rust
dispatcher turning a script tree into a polished sub-CLI (nested help,
completions, validation). Candidate chassis for the general "sub-cli gizmo"
and for the chatfs CLI specifically.

## Problem Statement

sub is a near-exact fit for the sub-cli gizmo, but upstream is quiet (last
substantive commit 2026-01; 24 stars; zero open issues/PRs -- "finished and
small" or "abandoned", can't yet tell). Policy: only depend on it to the
extent I'm willing to fully own a fork. Decide the relationship: thin
patches upstream, hard fork, or a similar-but-different package of my own.

## Current Situation

- Installed via cargo-built formula in `~/repo/github.com/bukzor/tap`
  (upstream tap ships mac-only binaries), pinned to v2.3.0 by source sha.
  Flipping the formula `url` to a fork is a one-line change.
- Local clone at `~/repo/github.com/juanibiapina/sub`.
- Measured fork price: 1,282 lines of Rust, integration tests, nix flake.
- Known wart: trailing `--help` at group level errors ("no such sub
  command"); bare-dir and prefix forms work.
- Verified fit for chatfs: see
  `~/repo/github.com/bukzor/prototype.chatfs/.claude/ideas.kb/2026-07-26-000-sub-as-chatfs-CLI-dispatcher.md`.

## Proposed Solution

Let a real patch queue decide, not vibes. Dogfood sub as-is (chatfs
generator), file the wart upstream as a responsiveness probe, and choose
based on what accumulates:

- patches merged promptly -> stay upstream, contribute
- patches ignored, queue stays small -> thin rebaseable fork
- contract-level disagreement emerges (e.g. want jdx/usage as the spec
  grammar) -> successor package, using sub's source as basis (MIT); the
  patch queue and dogfood notes are its requirements doc

## Implementation Steps

- [ ] Consider `gh repo fork juanibiapina/sub --clone=false` -- zero-maintenance
      insurance against upstream repo deletion (local clone covers everything else)
- [ ] Read the source (~1.3k lines; a sitting)
- [ ] File the group trailing-`--help` wart as an upstream issue (+PR if trivial)
- [ ] Dogfood via chatfs libexec generator (see chatfs ideas.kb entry)
- [ ] After ~2 weeks of use: revisit with the patch queue in hand and decide
- [ ] Record the decision (here + chatfs ideas.kb entry lifecycle)

## Open Questions

- Is the gizmo itself a product mission (public package under my design), or
  instrumental to chatfs? Changes whether "successor package" is ever the
  right branch.
- Does sub's completion wiring ship usable bash/zsh setup snippets, or does
  that need writing?

## Success Criteria

- [ ] A recorded decision: upstream / fork / successor, with the evidence
      that drove it
- [ ] chatfs CLI works end-to-end through whichever dispatcher was chosen

## Notes

Upstream formula defect (mac-only binary in linuxbrew) fixed locally
2026-07-26; commit `51e0550` in `~/repo/github.com/bukzor/tap`, unpushed.
