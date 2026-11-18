---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-002-commands-agents-are-told-to-run.md  # Open Questions 4-5
---

# `claude-tokens-cost` prices for current models; main's stray `breakdown.md`

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (switch fallout)

## Problem Statement

Tentative rulings (user, 2026-11-18: "infer intent, tentative judgments"):

1. `bin/claude-tokens-cost` (both branches) has no `PRICES` entry for
   `claude-opus-5-5`, so it fails on today's corpus. Add entries for every
   current Claude model, in its existing format. Take the prices from
   Anthropic's published pricing (load `Skill(claude-api)`, or fetch the
   pricing page); never from memory. Cite the source in the commit message.
   If unknown models should warn rather than fail, make that change too.
   Land it byte-identical on both branches. Show the cost of a real
   transcript containing opus-5-5 rows.
2. `.claude/commands/breakdown.md` exists only on main, and its frontmatter
   is invalid YAML. Svelte deleted it. Check svelte's history to see whether
   it was renamed or superseded (for example by a `breakdown` skill). If so,
   delete it on main. If it was dropped with no replacement, record that
   under Open Questions, and fix only its frontmatter.

Then `git -C ~ pull --ff-only`. Use unit 001's ssh workaround if plain ssh
still fails.

**Scope (only these files):** `bin/claude-tokens-cost` in both workspaces;
`.claude/commands/breakdown.md` on main; `git pull` in `~`; this handoff
file.

## Steps

- [x] `claude-tokens-cost`: prices from the published table; warn on
  unknown models; land on both branches; cost a real opus-5-5 transcript
- [x] `breakdown.md`: trace svelte's history; delete or fix frontmatter
- [x] `git -C ~ pull --ff-only`; final checks

## Decisions

- Prices: every row of the pricing page's model table, including the
  three retired-but-listed (Opus 4.1, Opus 4, Sonnet 4), so older
  transcripts still price. Keyed by the API ID the response echoes: the
  dated snapshot where one exists (`claude-opus-4-5-20251101`, as
  `claude-haiku-4-5-20251001` already was). The cache multipliers are not
  uniform: 0.05x (Opus/Sonnet 5.5), 0.025x (Fable/Mythos 5.1, 5.2).
- Haiku 5.5 is priced by prompt length (5x base over 100k prompt tokens,
  where the prompt counts input, cache writes and reads). The one-number
  table could not express that, so I added `LONG_PROMPT`.
- Unknown model: warn, don't fail. Its rows cost `nan`, stderr names the
  model and count, and the total covers priced rows only. A new model no
  longer blocks the report, and it can't read as free: `nan` propagates
  through `claude-tokens-histogram`/`-params` sums.
- Fast mode (2x) and US-only `inference_geo` (1.1x) are not priced:
  `claude-tokens` emits neither. Every usage record here is
  `speed=standard, inference_geo=global`.
- `breakdown.md`: the brief's "Svelte deleted it" doesn't hold. The path
  never existed on svelte (`--all` history: only main's `2ee5cfc`,
  2025-08-20). No content match in svelte or `bukzor-agent-skills`. So
  dropped-without-replacement: I fixed the frontmatter only. I quoted the
  whole `argument-hint`, which leaves the displayed text unchanged, and
  removed `model: claude-3-5-sonnet-20241022`, which was retired
  2025-10-28, so the command could not run as pinned.

## Open Questions

1. `.claude/commands/breakdown.md`: keep (main-only; 006 merges it
   through with no conflict), port to svelte, or delete? It has no
   replacement. Recommend keep: it works now, and it costs nothing.
   Main's other main-only commands (`claude-workshop`, `frustration`,
   `lets-commit`, `why`) raise the same question. They are out of this
   unit's scope.

## Final report

- `bin/claude-tokens-cost`: svelte `2ba3ce7`, main `54db312`, both pushed.
  `git diff origin/main origin/svelte-crostini -- bin/claude-tokens-cost`
  is empty. Source cited in both commit messages.
- `.claude/commands/breakdown.md`: main `df7f5ba`, pushed.
- `~` fast-forwarded to `df7f5ba` with plain ssh (the workaround was no
  longer needed).
- Checks (scratch `~/trash/unit-006/`): black- and pyright-clean. Fable-5-1
  rows are byte-identical to the old script's output. An opus-5-5 row
  checked by hand matches. Haiku 5.5 at 100,000 vs 100,001 prompt tokens
  switches tier. An unknown model warns and gives `nan`.
- Real transcript: `73d94314-...` (`-home-bukzor-claude-deadlock`), 1,939
  opus-5-5 requests, $112.15 ($80.65 subagents, $31.51 main thread).
  Live corpus: `claude-tokens | claude-tokens-cost` gives $350.24 over 5,555
  requests. `md-frontmatter ~/.claude/commands/*.md` exits 0.
