# Sub-agent handoffs for hand-merging main ↔ svelte-crostini divergences

Each file here is one sub-agent's unit of work toward the parent plan,
`../2026-07-06-004-Hand-merge-true-divergences.md`. It carries both
directions of the handoff: the coordinator's brief, then the agent's own
record and report. Belongs here: work one agent can finish in one sitting
(≤60 min), scoped to named files. Does not belong: design (the parent plan
and `../CLAUDE.md`), or work spanning waves (split it).

A handoff file holds only what has no other home: what the unit was asked,
how far it got, what it chose and still doubts. Design, interfaces and
findings live in their own homes, and a handoff file links to them, never
copies them.

## Protocol

1. The coordinator writes the file before launch, named
   `YYYY-MM-DD-NNN-slug.md`: frontmatter `required-reading:` and
   `blocked-by:`; a **Problem Statement** (goal, scope as a file list,
   decisions already made for it). The launch prompt is only "do the task in
   {{path}}".
2. The agent works from the file and keeps it current: **Steps** as
   checkboxes, marked `[~]` on starting one and `[x]` on finishing it, so an
   interrupted unit can resume where it stopped; **Decisions** with reasons;
   **Open Questions**. At the end, a **Final report**: check results,
   deviations from the brief, and where each result lives (commit ids per
   branch, paths). `status:` stays `open` while it works; at the end it sets
   `status: done`, commits its unit, and replies with the path only.
3. While open, a later instruction is an in-place edit of the brief, and the
   message is just "reread {{path}}". Once done, the file is a frozen record:
   nobody updates it, and a correction is a new unit.

## The job

`main` and `svelte-crostini` have disjoint histories and must reach
identical content, so that 006 merges them with zero conflicts. Each theme's
merged content is **authored once**, then committed byte-identical on both
branches, each commit naming the other branch as counterpart. Where a side
is only an older copy of the other (its blob appears in the other branch's
history at that path), take the newer side; that is not a judgment call.

Workspaces (both clones of `github.com/bukzor/dotfiles`; agreements in
`../CLAUDE.md`):

- `~/repo/github.com/bukzor/dotfiles--main/` — `main`
- `~/repo/github.com/bukzor/dotfiles--svelte-crostini/` — `svelte-crostini`
  (this kb lives here)

Never touch `~`: it is this host's live `wsl-buck-win10` checkout, already
folded into main.

## Every agent, every task

- Read first: `~/.claude/must-read.kb/before/running-ANY-Bash-commands.md`,
  `~/.claude/must-read.kb/before/git/` (both files), then the brief's
  `required-reading:`.
- Stay inside the brief's file list. Sibling agents run concurrently on
  other files in the same two workspaces; never edit theirs or the parent
  plan.
- A real judgment call (which behavior to keep, not which copy is newer) is
  the user's. Record it under Open Questions with the options and your
  recommendation, land nothing for that file, and finish the rest.
- Write each finding into its home, the doc your scope names. When there is
  none, the Final report is its home.
- Stage your scope's paths as you finish each step. Commit with
  `git -C <workspace> commit-staged PATHS -- -m MSG` (or `commit-files`),
  per `~/.claude/reference.kb/git/commit.md`. Siblings share each
  workspace's index: never commit bare, and never stage, unstage or commit a
  path outside your scope. On an `index.lock` collision, retry.
- `git fetch` and fast-forward before editing a workspace; push right after
  each commit; never leave unpushed commits.
- The repo is public: no secrets, tokens, or credentials.
- "Does path P survive on branch B?" — count renames as deletions
  (`--no-renames`).
- Check what you land: a parse or load test of each file where a tool for it
  exists here (`git config -l`, `tmux -f`, `sh -n`, `jq`), and the
  `.config/sh` test suite (`redo -k test` in the svelte workspace) when you
  touch shell files. `nvim` and `kitty` are not installed on this host: say
  so in your report rather than claiming a check you could not run.
- Prove the theme is done: `git diff origin/main origin/svelte-crostini --
  <your paths>` is empty.
- Your handoff file lives in the svelte workspace; commit it there, in the
  same step that sets `status: done`.
- Run checks in the foreground. Never end your turn waiting on a background
  job.
- Scratch goes in `~/trash/` (gitignored).
- The brief (frontmatter inputs, Problem Statement) is the coordinator's;
  edit only your own sections, in place, ≤60 lines.
