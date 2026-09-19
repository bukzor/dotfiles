# Shell config loading -- formal basis

[!DRAFT] 2026-09-19, agent-authored via /formalize; every `+` claim is vetoable.
Subject: `~/.config/sh/*.d` and the proposed `intent.d/` successor.
Notation: Skill(llm-claims). `stale when` gives the condition that retires a claim.

## Layer 0

**Sourcing is sequential, so config loading is a linear extension of a
sparse must-precede relation; the design problem is only how few false
edges the representation adds.** Refines into: SEQ, TRUE_DAG, FREE_OVER,
COMMUTE, RANK.

## Theory: state-flow (what units do)

* UNIT: a unit is a file sourced into a shell; its effect is a set of writes W(u) and reads R(u) over shell state (variables, functions, aliases, options, keymaps, PATH-like lists). Smallest: `050-prefix.sh` W={PREFIX,GOPREFIX,GOPATH}, R=∅. Stale when: a unit's effect depends on something other than shell state it reads (e.g. wall clock) -- then R is incomplete.
* GUARD: each unit has an applicability predicate over the invocation (shell, interactive, login). Today it is the directory (`env.d`=always, `rc.d`=interactive, `bashrc.d`=interactive∧bash); in intent.d it is the leg filename. Smallest: `rc.d/no-tty-pause.sh`, guard=interactive. Stale when: a unit tests the invocation inside itself instead of by placement -- `rc.d/direnv.sh`'s `if ZSH_VERSION` is a guard smuggled into content (a finding, not a refutation: the leg split removes it).
* REQ: `u requires v` iff R(u)∩W(v)≠∅, or u and v both write one order-sensitive resource and u's write is meant to win. Smallest: `900-path` requires `050-prefix` (reads GOPREFIX). Stale when: a read is made lazy (deferred to use time) or the resource's merge is made commutative -- the edge disappears.
* GUARD_MONO <- REQ GUARD: if u requires v then guard(v) ⊇ guard(u) -- a dependency must run in every invocation its dependent runs in. Smallest: `zshrc.d/050-completion` (interactive zsh) requires `300-homebrew` (always): holds. Violation example: an `env.sh` leg requiring a `bashrc` leg. Stale when: never; it is a consistency law. Consequence: the env-before-rc phase ordering is derived, not stipulated.

## Theory: order (what the relation is)

* SEQ: a shell sources one file at a time; a valid load order for invocation i is any linear extension of REQ restricted to applicable units. Stale when: sourcing becomes parallel or lazy-on-reference (it will not).
* ACYCLIC <- SEQ: REQ must be acyclic; a cycle has no linear extension, so it is unsatisfiable, not merely hard. A cycle is a design error resolved by splitting a unit. Stale when: SEQ is stale.
* NO_CYCLES_EVER+ <- ACYCLIC OVERLAY: no foreseeable need to accommodate cycles. The only cycle-shaped pattern in reach is the override overlay; it dissolves (OVERLAY). Fixpoint semantics for config would be the only other route, and shells have none. Stale when: someone wants a unit whose effect depends on a later unit's override of its own write -- and cannot express it as a defaulted read.
* OVERLAY <- REQ: "private-dotfiles may override anything" is a unit with W=everything, so every unit requires it and it requires nothing -- a root, never a cycle. The cycle appears only if a public unit sets a default that private overrides and the public unit then reads it; `${X:-default}` at the read site removes both the default-setting write and the cycle. Smallest: `030-private-dotfiles.sh` trysources `.sh_env`, currently inert. Stale when: private content exists that both reads and is read by public units at load time.
* TRUE_DAG: the actual REQ over today's units is a DAG that is neither a tree nor series-parallel. Smallest N, from the data: `050-prefix`<`900-path`, `300-homebrew`<`900-path`, `300-homebrew`<`zshrc.d/050-completion`, `050-prefix`⊀`050-completion`. Second N via the grab-bag: `060-basics`<`900-path` (VOLTA_HOME) and `060-basics`<`rc.d/prompt` (COLORTERM) with `050-prefix`⊀`prompt`. Stale when: `060-basics` is dissolved by dependent (kills the second N -- a bundle that serves two unrelated readers is the N generator) *and* HOMEBREW_PREFIX reads become lazy (kills the first).
* EDGE_CENSUS: true edges today, beyond root: path←{prefix, basics/VOLTA_HOME, homebrew, path-helper(merge), profile/PATH-default}; term-fixing←ostype; zkbd←{term-fixing/TERM, ostype}; every zkbd-derived keybind←zkbd; zsh-completion←homebrew; pane-title(bash)←precmd-functions; direnv(bash)←precmd-functions (merge: PROMPT_COMMAND string-prepend vs array); prompt←basics/COLORTERM. Root: every unit←functions, ←HOME. ~13 edges over ~30 units. Stale when: any unit's R or W changes; re-run the census.
* NOT_TREE <- TRUE_DAG: nesting-by-prerequisite alone (parent=prereq) cannot represent REQ; `900-path` has in-degree 4. Stale when: TRUE_DAG is stale.
* BULK_SHARED <- EDGE_CENSUS: prerequisites shared in bulk exist: root (functions, HOME: all units); zkbd (every terminal-key keybind, ~10 units after the keybind split); precmd-functions (2 bash hooks); homebrew (2). Retracts the prior "none yet". Stale when: EDGE_CENSUS is stale.

## Theory: representation (how the relation is written down)

* FREE_OVER <- SEQ: a representation may add edges REQ lacks at zero runtime cost -- any linear extension of a superset of REQ is a linear extension of REQ. The cost of a false edge is documentary: it misstates a dependency and blocks a reorganization that REQ would permit. Smallest: today's numbering asserts `010-ostype`<`050-prefix`; false, harmless. Stale when: SEQ is stale.
* FALSE_EDGES <- FREE_OVER: representations are ranked by false-edge count at equal legibility. Total order (status quo): ~all pairs. Nesting-by-prerequisite: in-degree>1 nodes need extra explicit edges or a false parent. Explicit `require` in each leg: zero, but invisible to `ls`. Series-parallel tree: false edges only inside N's (≥1 per N that survives COMMUTE). Stale when: legibility metric changes.
* SP <- FALSE_EDGES: the alternating ordered/unordered directory scheme is exactly a series-parallel decomposition tree: an ordered directory is series composition of its children, an unordered one is parallel composition. Nesting-by-prerequisite is the special case series(legs(D), parallel(children(D))). Both are one rule (RANK). Stale when: RANK is rejected.
* RANK+ <- SP: one loader rule covers numbering, nesting, and the alternating scheme: within a directory, legs precede subdirectories; an entry's rank is its numeric prefix, ∞ if none; entries of equal rank are unordered (no edge claimed); ranks ascend. Numbers assert order; names do not. Smallest: `intent.d/terminal-keys/{zshrc,inputrc}` then `intent.d/terminal-keys/home-end/zshrc` -- the leg precedes the child; the user's `500-public-dotfiles/000-home` and `500-application/{editor,pager,git}` read the same way. Compatible with today: unnumbered `claude.sh` sorts after `900-path` in both. Stale when: a unit's correct position cannot be expressed as (rank, nesting) without a false edge that someone objects to -- then it declares `require X` explicitly (RESIDUAL).
* RESIDUAL+ <- RANK NOT_TREE: DAG edges that RANK would misstate are written as `require X` in the dependent leg; the loader sources X's applicable legs once, on demand. Expected count after COMMUTE: 0-1 (completion←homebrew, if HOMEBREW_PREFIX stays a load-time read). Stale when: the count grows past a handful -- then the tree is misfiled.
* COMMUTE+ <- REQ EDGE_CENSUS: most edges are removable by making units commute -- defer the read (`ostype` as a function; `$EDITOR` read at keypress, already), default the read (`${X:-}`), or make the write commutative (hooks append to one array instead of one unit overwriting PROMPT_COMMAND; PATH entries carry an explicit priority and one owner sorts). Applied to EDGE_CENSUS: term-fixing←ostype, zkbd←ostype, pane-title←precmd, direnv←precmd, prompt←basics all vanish; path's four edges collapse to a single-owner list; what remains is zkbd←TERM (a filename), keybinds←zkbd (real, bulk -- nesting's one honest instance), completion←homebrew (real or lazy). Stale when: a unit's read cannot be deferred without changing behavior (TERM-derived filenames; anything exported to child processes must be set at load).
* SUBDIR_WHEN <- BULK_SHARED RANK: grow a subdirectory when several units share one prerequisite: the prerequisite becomes the directory (its legs first), the dependents its children. Today's instances: root (already `~/.config/sh/` itself: `functions.sh` then `*.d`), and `terminal-keys/` over the keybinds. Stale when: BULK_SHARED changes.

## Patch 2026-09-19: against the sibling ledgers

Source: `~/.claude/sessions.kb/penguin.kb/must-read-sharding.kb/2026-09-19-000-formal-ledger.md`
(trigger banks as occasion-indexed sets) and `trigger-installation.md`.
Restating supersedes; unmentioned claims stand.

* DIR_IS_INTENT+ <- RANK: every directory under `intent.d/` is an intent; a
  grouping directory (the user's `500-application/`) is an intent with no
  legs -- a pure prerequisite node with no effect. Replaces the earlier
  content-decidable split "intent = dir with legs, group = dir with only
  dirs": the sibling's WHILE_KEY shows the kind of a directory must be
  decidable from the path alone, and one kind needs no decision. Stale
  when: a directory must mean something a legless intent cannot.
  * // [!@bukzor] 2026-09-19: the sibling's NAMESPACE! ("a plain
    directory is a key prefix and nothing more") was ruled in scope of
    llm-kb; `intent.d` is not in that scope. Not a deviation -- no
    declaration owed, no contradiction to rule on.
* AXIS+ <- GUARD DIR_IS_INTENT: the closed vocabulary (contexts here,
  junctures there) is spelled with reserved names; the open set (intents
  here, triggers there) with free names. A reserved name is a directory
  iff it contains the open set: junctures hold triggers, so `before/` is
  a directory; contexts hold only text, so `zshrc` is a file. Restates
  the earlier "closed vocabulary on filenames", which the sibling's
  layout contradicted only in wording. Stale when: a context needs to
  contain more than one file.
* ROOT <- SUBDIR_WHEN: the root intent is sourced by the entry point by
  hand because the loader lives inside it. Same theorem as the sibling's
  ROOT ("the set at top is installed by the host context, never by a
  trigger in the bank -- an agent would have to read the bank to learn
  to read the bank"); independently derived, one line each.
* MECH_PULL <- GUARD: every guard here is decided by the runtime (the
  shell knows whether it is bash, interactive, login), so the sibling's
  NOTICED is discharged for free on every leg; this loader is the
  fully-mechanized end of its GRADIENT. Stale when: a leg's
  applicability depends on something the shell cannot test at source
  time.
* REENTRY <- SEQ: a context is re-entered (tmux shell skipping
  `.profile`; `alias login`), so legs are idempotent and each entry
  point re-runs the loader, resetting the loaded-set. This is the shell
  answer to the sibling's open COMPACTION? ("what re-installs a set
  after context reset"): re-install at every context entry, made cheap
  by idempotence. Offered as analogue, not solution -- their install
  costs context tokens, ours costs milliseconds.

## Theory: questions (sorted)

Decided by the formalism:
- "Tree or DAG?" -- DAG, not a tree, not SP (TRUE_DAG); after COMMUTE, nearly a forest with one residual edge.
- "Cycles, ever?" -- no (NO_CYCLES_EVER).
- "Nesting vs alternating layers?" -- the same rule (RANK); alternating layers is the general form, nesting the depth-2 case.

Dissolved:
- "must-be-first" / "bootstrap" -- a root of REQ, sourced by hand only because the loader is inside it (OVERLAY, SUBDIR_WHEN). Not a class.
- "last-wins merge order" -- a non-commutative write; either single-owner (data deps) or priority-as-data (COMMUTE). Not a class.
- "how expressive must the layout be?" -- irrelevant to correctness (FREE_OVER); only false-edge count matters.

Open:
- OWN_PATH? -- PATH as single-owner list (status quo, edges to every tool's env) vs priority-as-data with each tool intent prepending (no edges, priority numbers in ~8 files). Judgment; recommendation single-owner, it is what `900-path` already is.
- LAZY_BREW? -- make HOMEBREW_PREFIX a function/lazy read to remove the last residual edge, or keep one `require homebrew`. Trivial either way; decide when writing the loader.
