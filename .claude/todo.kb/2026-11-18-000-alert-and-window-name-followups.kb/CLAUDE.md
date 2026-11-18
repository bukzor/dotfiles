# Sub-agent handoffs for the alert and window-name follow-ups

Each file here is one sub-agent's unit of work toward the parent plan,
`../2026-11-18-000-alert-and-window-name-followups.md`. It carries both
directions of the handoff: the coordinator's brief, then the agent's own
record and report. Belongs here: work one agent can finish in one sitting
(≤60 min), scoped to named files. Does not belong: design (the devlog and
claims ledger named in the parent plan), or work spanning waves.

A handoff file holds only what has no other home: what the unit was asked,
how far it got, what it chose and still doubts. Design, interfaces and
findings live in their own homes, and a handoff file links to them, never
copies them.

## Protocol

1. The coordinator writes the file before launch: frontmatter
   `required-reading:` and `blocked-by:`; a **Problem Statement** (goal,
   scope as a file list, decisions already made). The launch prompt is only
   "do the task in {{path}}".
2. The agent works from the file and keeps it current: **Steps** as
   checkboxes, marked `[~]` on starting one and `[x]` on finishing it;
   **Decisions** with reasons; **Open Questions**. At the end, a **Final
   report**: check results, deviations from the brief, and where each result
   lives. `status:` stays `open` while it works; at the end it sets
   `status: done`, commits its unit, and replies with the path only.
3. While open, a later instruction is an in-place edit of the brief, and the
   message is just "reread {{path}}". Once done, the file is a frozen record.

## Every agent, every task

- Read first: `~/.claude/CLAUDE.md` and the `must-read.kb` files it points
  to (`llm-must-read-ls ~`), especially `before/running-ANY-Bash-commands.md`,
  `before/writing-bash-scripts.md`, `before/git/commit.md`; then the brief's
  `required-reading:`.
- The repo is the dotfiles checkout rooted at `~` (branch `main`), shared
  with other live sessions. Stay inside the brief's file list; never edit a
  sibling's files or the parent plan.
- Write each finding into its home, the doc your scope names. When there is
  none, the Final report is its home; name the gap in Open Questions.
- Commit with `git -C ~ commit-files PATHS -- -m MSG` (your scope's paths
  plus your handoff file), message per `~/.claude/reference.kb/git/commit.md`,
  ending `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`. Never
  commit bare; never stage, unstage or commit a path outside your scope. On
  an `index.lock` collision, retry. Do not push, and do not touch the
  `svelte-crostini` clone: the coordinator syncs branches.
- Never alter the user's live tmux server (no `source-file`, no option
  changes on the default socket); test on an isolated server
  (`tmux -L <name> -f <conf>`) and kill it when done.
- Shell scripts: `shellcheck` via `uvx --from shellcheck-py shellcheck`,
  clean, on any script you touch.
- Run checks in the foreground. Never end your turn waiting on a background
  job.
- Scratch goes in `~/trash/` (gitignored).
- The brief (frontmatter, Problem Statement) is the coordinator's; edit only
  your own sections, in place, ≤60 lines.
