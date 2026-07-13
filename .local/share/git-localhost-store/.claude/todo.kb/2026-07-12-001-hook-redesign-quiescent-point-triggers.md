---
managed-by: Skill(llm-subtask)
status: done
closeout: |
  Resolved 2026-07-13. Shared symlinked hook body, env re-entrancy guard,
  and post-checkout exit-code propagation landed; full testing.kb pass
  green under an isolated XDG_STATE_HOME (fork-bomb check stably 0
  against a simulated legacy-hook store). Unplanned addition during
  implementation: post-index-change fires during `git commit` itself
  (its internal index refresh), before commit's own ref-transaction
  lands -- adopting the store there would swap `.git` out from under the
  in-flight commit, so `bin/git-localhost-store` now always defers that
  case to post-commit/post-checkout. Documented in
  `docs/dev/testing.kb/store-recovery-via-commit.md` and the "Hook Logic
  Flow" section of CLAUDE.md. Both open questions resolved (see below).
  Optional hooks-sweep step left undone -- non-urgent, the env guard
  already covers legacy stores.
required-reading:
    - bin/git-localhost-store
    - docs/dev/testing.kb/merge-fetch-recurses-through-store-hooks.md
    - docs/dev/testing.kb/reclone-after-workdir-deletion.md
suggested-reading:
    - docs/dev/devlog/2025-12-18-000-fixed-reference-transaction-hook-race-condition-during-git-init.md
    - docs/dev/devlog/2026-07-11-001-recovery-merge-redesign--two-rules--fork-bomb-fix--git-localhost-clone-retired.md
---

# Hook redesign: quiescent-point triggers, one symlinked hook

**Priority:** High
**Complexity:** High
**Context:** 2026-07-12 simplification review. Executable surface drops
from ~815 lines / 9 scripts to ~130 lines / 2 files (with the migration
retirement); two failure modes and one hazardous test procedure removed.

## Problem Statement

The `reference-transaction` hook fires **mid-operation** and is the root
of nearly all the system's incidental complexity: the fresh-init
refs-empty skip (2025-12-18 init race), the `committed` state gate, and
the fork bomb when the recovery merge writes into the store — which
forced the hooks-aside/trap/self-heal dance (~35 lines) plus a
fork-bomb-hazard test. Separately, the three hooks are near-identical
copies installed per-repo at init time, so hook fixes never propagate to
existing repos.

## Proposed Solution

Three parts, landing together:

1. **Quiescent-point triggers.** Keep `post-index-change` (`git add` on
   fresh repos). Replace `pre-commit` + `reference-transaction` with
   `post-commit` + `post-checkout`:

   | protection trigger | today | proposed |
   |---|---|---|
   | `git add` on fresh repo | post-index-change | post-index-change |
   | any commit (`--allow-empty`, `--no-verify` included) | pre-commit + reference-transaction | post-commit |
   | `git clone` (incl. re-clone recovery) | reference-transaction, mid-clone | post-checkout, end of clone |

2. **Env re-entrancy guard** (~3 lines) in `bin/git-localhost-store`
   replaces the hooks-aside/trap/self-heal machinery. Still needed even
   after (1): stores created before this change carry old copied
   `reference-transaction` hooks, which the recovery fetch would fire.

3. **One hook body, symlinked.** `template-repo/hooks/*` become symlinks
   to a single shared script. Verified 2026-07-12
   (`trash/template-symlink-test/`): `git init --template=` copies
   symlinks as symlinks, and hooks execute through them. Future hook
   edits propagate to every post-change repo automatically.

## Implementation Steps

- [x] Write the shared hook body (short-circuit when `.git` is a
      symlink/gitfile, else exec `bin/git-localhost-store`); replace
      `template-repo/hooks/{post-index-change,pre-commit,reference-transaction}`
      with `{post-index-change,post-commit,post-checkout}` symlinks to it
- [x] Replace the hooks-aside/trap/self-heal block in
      `bin/git-localhost-store` with the env guard
- [x] Update testing.kb: `empty-commit-on-fresh-repo.md` (conversion now
      via post-commit), `merge-fetch-recurses-through-store-hooks.md`
      (must run against an old-style store with real-file
      reference-transaction hooks — that's the case the guard exists
      for), `fresh-repository-setup.md` (hooks are symlinks)
- [x] Full testing.kb pass, including reclone scenarios A/A2/B
- [ ] Optional follow-up: sweep `~/.local/state/git-localhost-store/repos/*/hooks/`,
      replacing our three known hook files with the new symlinks
      (retroactively fixes stale hooks — cf.
      `abandoned/2026-05-05-000-audit-and-sweep-stale-hooks.md`;
      the env guard makes this non-urgent)
- [x] ADR + devlog; update CLAUDE.md hook-flow sections and README

## Open Questions

- ~~Scenario B behavior delta: a failing post-checkout makes `git clone`
  exit non-zero (today: exit 0, stderr only). Clone's junk cleanup is
  already in LEAVE_ALL mode by checkout time, so nothing gets deleted —
  arguably better visibility for the "needs a human" refusal. Accept?~~
  **Resolved: accept.** Per the user: never allow things to be quietly
  wrong; rare/expected-never situations should fail loudly and early.
- ~~Keep the hook-level `[ -L .git ]` fast path, or always exec the
  relocator (which re-checks)? post-commit/post-checkout fire far less
  often than reference-transaction did, so the fork cost is lower now.~~
  **Resolved: dropped.** `bin/git-localhost-store` already re-checks;
  the hook-level duplicate added no safety, only an extra fork per
  invocation, which is cheap now that invocation frequency dropped from
  every ref write to once per commit/checkout.

## Success Criteria

- [x] All testing.kb scenarios pass
- [x] Fork-bomb check stably 0 against a legacy-hook store
- [x] Fresh `git init` + template yields symlink hooks; conversion still
      fires on first add/commit/clone
- [x] `bin/git-localhost-store` loses the hooks-aside block entirely

## Rationale

Kept below the fold deliberately — the steps above stand alone; this is
the reasoning that justifies changing the core mechanism, for the
session that executes (or challenges) it.

### Why reference-transaction is the complexity source

It fires *inside* other git operations:

- During `git init`'s HEAD creation → the 2025-12-18 race (broken repos
  with `HEAD.lock`, no `objects/`) → the refs-empty skip.
- During any ref write, including the recovery merge's own
  fetch/update-ref into the store → the 2026-07-11 fork bomb →
  hooks-aside/trap/self-heal, which itself grew a crash-recovery
  self-heal for the "prior run died mid-fetch, store left hookless"
  failure mode, plus a test that is a live fork-bomb hazard to run.
- It needs the `$1 = committed` gate, and it runs on **every ref write
  in every repo forever** (every commit, every fetch) just to no-op via
  `[ -L .git ]`.

post-commit and post-checkout fire at quiescent points: the commit is
fully written, or clone's checkout is complete, before we `mv .git`.
Today's system already survives a strictly harsher timing (swapping
`.git` mid-ref-transaction during clone), so the safety argument is
conservative, but the full testing.kb pass is still the gate.

### Coverage: what the trio loses vs. reference-transaction

Case-by-case:

- Commits: post-commit covers `--allow-empty` (today only
  reference-transaction catches it) and `--no-verify` (which skips
  pre-commit — today's pre-commit was never a reliable layer; githooks(5)
  confirms `--no-verify` does not skip post-commit).
- Clone: post-checkout runs at the end of `git clone` (githooks(5)),
  after all ref transactions committed — the recovery-merge entry point
  moves there unchanged. `--no-checkout` clones convert on first
  add/commit/checkout instead; the refs at risk in that window came from
  the remote and are re-fetchable by definition.
- Fetch/branch/tag into a never-converted repo: the only genuine
  coverage loss. Refs acquired by fetch are remote-recoverable; local
  branches/tags require objects, which require a prior commit or fetch —
  both already handled.
- merge/am/cherry-pick/rebase/stash don't fire post-commit, but all
  presuppose an existing commit or checkout, so conversion already
  happened by then.
- Bare repos: today survives by luck (hook fires, refs-empty skip
  happens to apply at clone time). With the trio, nothing fires in bare
  repos at all — strictly cleaner. Same for `git worktree add`
  (post-checkout fires in the new worktree, `.git` is a gitfile,
  short-circuit).
- Plumbing-built repos (`commit-tree` + `update-ref`, no porcelain):
  lost, but tools that bypass porcelain (e.g. jj) bypass hooks entirely
  anyway.

### Why the env guard beats the hooks-aside dance

Hooks inherit the environment of the git process that runs them, and the
recovery fetch/update-ref are direct children of `bin/git-localhost-store`
— so an exported variable reaches any nested invocation, which exits 0
immediately: recursion depth capped at 1 by construction. No filesystem
mutation, no trap, no crash-leaves-store-hookless failure mode, and it
works regardless of store vintage (old copied hooks included). The
2026-07-11 session established `core.hooksPath` can't suppress
reference-transaction during fetch and moved hooks/ aside; a re-entrancy
guard wasn't among the alternatives considered.

### What deliberately does NOT change

The two-rule recovery merge (force-sync `refs/remotes/*`,
ancestry-check `refs/heads/<default>`, refuse unknown shapes) is
essential, requirements-driven complexity, settled 2026-07-11 — this
task must not re-litigate it. The symlink store layout, path encoding,
and refusal-needs-a-human policy are likewise untouched.
