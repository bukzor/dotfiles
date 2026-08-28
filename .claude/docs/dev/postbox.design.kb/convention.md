# The postbox convention

Inter-session messages are files; delivery is a read. Chosen over push
messaging at the decision point in `transport.md`.

## The invariant: mutable-until-read

**A message belongs to the sender until it is read; after reading, it
belongs to the record.** Pre-read: visible, editable, deletable — by sender
or owner. Post-read: immutable audit trail. The transition happens exactly
once, at read time.

Owner-ratified as non-negotiable: "the ability to see, review, even
**edit** sent post. That's a feature i want to preserve no matter our final
solution." Every future mechanism (hook, CLI, mount, monitor) gets checked
against this invariant before adoption.

Derived bans:

- **No mechanism may auto-read on arrival.** Monitors and hooks emit
  filenames, never bodies; the Read is a deliberate act at a boundary.
  (Also what keeps receipt `/rewind`-able: the message enters context via
  an ordinary tool call in an ordinary turn.)
- **Live channels carry no content.** Wake pings (`claude --resume`,
  tmux keybindings) are a fixed formulaic phrase ("check your postbox").
  Content in a live channel is unreviewable, unretractable, and — for
  `--resume`/send-keys — arrives wearing the *user's* authority.
- **Single-consumer inboxes; never a shared claim-queue.** One reader per
  directory removes all races, which is what keeps weak transports viable
  (S3 has no atomic rename; the `read/` move stays advisory).

## Protocol

> [!TODO] core protocol
> A message is a markdown file in the recipient's inbox:
> `<postbox>/<recipient>/<timestamp>-<from>-<slug>.md`, with a two-line
> header (from, re) and the body. Sending is writing that file — no API,
> no registry; `ls` of the postbox plus tmux window names is the roster.
> Receiving happens only at task boundaries (task end, task start, or
> owner's "check mail") — never mid-task. Consumed mail moves to
> `<postbox>/<recipient>/read/` — a move, never a delete.

> [!TODO] permission scoping
> Path rules give per-scope approval: within-project postbox writes
> allowed; cross-scope writes under Ask. The Ask prompt shows the full
> body as a file diff, and unlike push messaging the owner can also edit
> the message before it is read.

> [!QUESTION] runtime directory name and resolution
> Owner ruled global/local must unify; the name is unruled. Candidates:
> - `postbox/` at repo root, gitignored, `trash/`-style resolution (walk
>   up to `.git/`, fall back to `~/postbox/`) — **recommended**:
>   observability was a core selling point (visible in `ls`, tmux panes);
>   reuses an already-internalized pattern.
> - `.claude/postbox/` — hidden; `.claude/` is committed in many repos,
>   putting transient mail one careless `git add` from history.
> - `postbox.kb/` — `.kb` currently means durable knowledge under
>   governance; mail is ephemeral traffic and would dilute the suffix.
> Settles by: owner ruling. Gates all implementation.

## Mechanisms (each optional; all must pass the invariant)

> [!TODO] opt-in interruption via Monitor
> A recipient may arm a Monitor on its own inbox (inotify or poll) when it
> chooses to be interruptible. Emits filenames only. Receiver-polarity:
> the sender never gains interrupt power.

> [!TODO] wake-by-resume for dead sessions
> An orchestrator wakes a dead worker with
> `claude --resume <id> -p "check your postbox"`, and surfaces
> `claude --resume <id>` for the owner to attach interactively. Dead
> sessions only — two processes on one transcript corrupts state. This
> closes the overnight orchestrator/worker loop; its safety boundary is
> the workers' permission allowlists (nobody is at the prompt), plus a
> max-wakes guard against ping-pong.

> [!TODO] user-turn hook (the eventual enforced form)
> A prompt-time hook injects unread-mail *pointers* at the turn boundary,
> making "rewind to just before receipt" hold by construction rather than
> convention. Must be silent when the inbox is empty (hook noise measured
> at 3.5 Mtok/3 weeks) and must never inject bodies.

> [!TODO] draft stage for unattended traffic
> In closed loops the pre-read window collapses to seconds, degrading the
> invariant to post-hoc audit. Opt-in restoration: mail composed as
> `*.draft.md` (invisible to readers), promoted by rename — by the owner,
> or by the orchestrator for pre-approved traffic classes. Routine mail
> skips the stage.

> [!TODO] statusline unread count
> Zero-context-cost visibility of pending mail per session.

## Transport portability

The convention's only address is a path: any mount (s3fs, sshfs, syncthing)
extends it cross-machine with no change to agent instructions. Kept true by
the single-consumer and no-atomic-rename rules above.
