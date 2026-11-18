# Sub-agent handoffs for folding wsl-buck-win10 into main

Each file here is one sub-agent's unit of work toward the parent plan,
`../2026-11-10-000-Fold-wsl-buck-win10-into-main.md`. It carries both
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

## Repos and branches

All three are clones of `github.com/bukzor/dotfiles`; working agreements
(topology, one-writer rule) are in `../CLAUDE.md`.

- `~` — live checkout of `wsl-buck-win10` on this host (buck-win10, WSL).
  Shared index with sibling agents and possibly a peer session. Never
  `stash`, `checkout`, `reset`, `restore`, or `clean` here: the working
  tree is live config and someone else's work in progress.
- `~/repo/github.com/bukzor/dotfiles--svelte-crostini/` — `svelte-crostini`
  workspace. This kb lives here.
- `main` — workspace `~/repo/github.com/bukzor/dotfiles--main/`, created by
  unit 005 (the merge). Only a unit whose brief says so writes main.
  Otherwise, something main needs gets authored on svelte (or committed on
  `wsl-buck-win10`, which merges into main) and its commit id goes in your
  Final report.

## Every agent, every task

- Read first: `~/.claude/must-read.kb/before/running-ANY-Bash-commands.md`,
  `~/.claude/must-read.kb/before/git/` (both files), then the brief's
  `required-reading:`.
- Stay inside the brief's file list. Sibling agents run concurrently on
  other files; never edit theirs or the parent plan.
- Write each finding into its home, the doc your scope names. When there is
  none, the Final report is its home; name the gap in Open Questions.
- Stage your scope's paths as you finish each step. Commit with
  `git -C <repo> commit-staged PATHS -- -m MSG` (or `commit-files`), per
  `~/.claude/reference.kb/git/commit.md`. Siblings share the index: never
  commit bare, and never stage, unstage or commit a path outside your
  scope. On an `index.lock` collision, retry.
- One writer at a time on a branch: `git fetch` and fast-forward before
  editing a workspace, push right after each commit, never leave unpushed
  commits. Every convergence commit names its counterpart branch.
- The repo is public. Never commit a secret, token, or credential; name
  such a file in your report by path only, never its contents.
- "Does path P survive on branch B?" — count renames as deletions
  (`--no-renames`); `--diff-filter=D` alone misses renames.
- Your handoff file lives in the svelte workspace; commit it there, in the
  same step that sets `status: done`.
- Run checks in the foreground. Never end your turn waiting on a background
  job: if a sibling must land first, say so in your report and stop.
- Scratch goes in `~/trash/` (gitignored).
- The brief (frontmatter inputs, Problem Statement) is the coordinator's;
  edit only your own sections, in place, ≤60 lines.
- A decision that is the user's (keep vs. drop content, where a directory
  should live) is not yours: record it under Open Questions with your
  recommendation, leave the path as it is, and finish the rest.
