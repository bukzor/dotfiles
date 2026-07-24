# Devlog: 2026-07-24 — Claude Code branch recovery: extract by leaf, not by carve

## Focus

A `/rewind` had orphaned a 288-record branch inside one session jsonl:
`claude --resume <id>` kept landing on the sibling branch, and the text
we wanted ("primordial") was unreachable. Recovered it, then rebuilt
`claude-branch-extract` around what recovering it taught us, and added
`claude-jsonl-cwd`.

## How Claude Code picks a branch (2.1.219, reverse-engineered)

Worth writing down: this cost a dozen passes over a 275 MB binary, and
the modules' docstrings state the rule without the evidence trail.

- **Selection is by max timestamp, not by append order.** At load:
  `P = f2t(messages, m => leafUuids.has(m.uuid))`, where `f2t` is
  max-by-`Date.parse(timestamp)` and `leafUuids` comes from
  `last-prompt` records' `leafUuid` field. Then `Bze(messages, P)` walks
  `parentUuid` back to a root. `session.py`'s old docstring claimed
  "most recently appended chain" — plausible, and wrong.
- **Fallback:** with no registered leaves, it takes the newest
  non-sidechain message. So a file with `last-prompt` stripped still
  resumes correctly — which is why the pre-existing extractor worked by
  accident.
- **`Bze` splices decorations back in** after the parent walk
  (`AB_(messages, chain, seen)`), which is why attachments and
  file-history records must be carried along.
- **Hidden flags:** `--resume-session-at <uuid>` (help text says
  "message id", the code matches `.uuid`) truncates the *already
  selected* chain — it cannot cross branches. Also `--rewind-files
  <uuid>`, `--reply-on-resume`.

## Decisions

### `/rewind` is structurally incapable of this, so a file-surgery tool is warranted

**Rationale:** the rewind picker is a `MessageSelector` over the
in-memory conversation — the single chain chosen at load — and its only
action is "restore to the point before this message". The `/resume`
picker builds one entry per *file* (`sessionId → path` map), so it
can't offer branches either. Branch choice happens once, at load, and
nothing re-opens it. Rewind is a UI action; fast-forward requires
rewriting the leaf pointer, which only file surgery can do.

**Alternatives considered:** `--resume-session-at` (truncates within the
selected chain — errors out on a foreign uuid); `--fork-session` (copies
whichever branch was already selected).

### Extract additively (keep what belongs), not subtractively (drop sibling subtrees)

**Rationale:** first instinct was to copy the whole file and delete the
sibling subtrees, on the theory that attachments are unattributable
leaves. Measurement refuted it — `parentUuid` places every one of them,
and most belong elsewhere. On the session at hand: of 154 attachments,
8 were in-chain, 31 hung off it, and **115 belonged to other branches**;
of 94 file-history records, 67 did. Subtractive kept all that junk (781
records / 1763 KiB); additive is both smaller and *correct* (303
records / 942 KiB). The four keep-rules are in `belongs_to_branch` /
`branch_records`.

**Alternatives considered:** subtractive (measured, rejected above);
chain-only, i.e. the previous behavior (240 records — drops every
attachment, so resumed context is thinner than what the assistant
originally saw, and `/rewind`'s file restore is dead).

### Forward-tracing is the default, with no flag for the old behavior

**Rationale:** `resolve_tip` used to extract `ancestors_of(<the record
you named>)`, so feeding it the line your grep found silently truncated
the branch at the match — losing, in this case, 200 messages. You can
rewind afterward; you cannot fast-forward. And the truncating behavior
doesn't need a flag: extract the full branch, then `claude --resume
<new> --resume-session-at=<uuid>` rewinds on load without a second file.

### Session settings are branch-scoped in practice

**Rationale:** `mode`, `permission-mode`, `ai-title`, `last-prompt` etc.
are keyed by sessionId with last-wins semantics, so a naive "keep the
last one" imports the *sibling* branch's title and leaf pointer. Cutoff
is the branch's own last record, then collapse to one per type.

## Conventions Established

- **Never decode a `projects/<slug>/` dir name back into a path.**
  `claude-slug` maps both `/` and `.` to `-`, so `prototype.chatfs/docs`
  and `prototype-chatfs-docs` are the same slug. Read `.cwd` from the
  file — that's `claude-jsonl-cwd`. (Cost this session: handed the user
  a `cd` command to a directory that doesn't exist.)
- **cwd is per-branch.** Branches of one file can live in different
  directories; the whole-file answer is the *live* branch's. Bit us
  twice — `claude-jsonl-cwd` documents it, `branch_extract` reports the
  cwd of the branch it extracted (`Session.cwd(among=...)`).
- **Run the tool against real data before believing the design.** Both
  bugs above (settings cutoff, per-branch cwd) survived review and died
  on first contact with the actual file.

## Open Questions

- Did an older Claude Code have a branch-switching rewind picker? User
  remembers one from ~a year ago; found no trace in 2.1.219 and argued
  it never existed, but that's inference — the older builds weren't
  inspected. Tracked in `~/.claude/todo.md`.

## References

- `~/lib/pythonpath/bukzor/claude/{session,branch_extract}.py`
- `~/bin/{claude-branch-list,claude-branch-extract,claude-jsonl-cwd}`
- anthropics/claude-code#55347 (the orphaned-branch bug)
- Claude Code 2.1.219 binary: `f2t`, `Bze`, `AB_`, `PBe`, `MessageSelector`
