# The asking law, and what each of its rules answers to

Design record for `must-read.kb/before/asking-the-user.md`. The entry
itself carries rules only; this file carries the evidence they were
derived from, so a later editor can tell a load-bearing rule from a
stylistic one before rewriting it.

## How the entry got its shape

The section structure is not editorial taste — it is a ruled
instruction about how to guide an agent (2026-08-28):

> "I'd instead give agent a _mode_ of thinking, clear success criteria
> and a directory of tools"

Hence: a factoring step (mode), `## Success criteria`, `## Tools that
earn them`. Prescription of output and presentation was deliberately
reduced; universals are encouraged, not mandated. An editor who
converts the tools list back into a procedure or template is undoing
the ruling, not tidying it.

The entry is a merge. Two bank siblings — `asking-the-user-to-approve-
or-ratify.md` (the facts/adequacy/acts factoring) and a short-lived
`asking-the-user-multiple-questions.md` (the form) — became one entry
under the broadest honest name, because the factoring and the form
always fire together: you cannot shape a batch before knowing which
items deserve to be in it.

## Evidence corpus

Sessions under `~/.claude/projects/`; line numbers are JSONL lines.
Five walkthrough formats tried between 2026-08-20 and 2026-08-28.

- `98f2be37` L1431→L1434 (Aug 21): faithful five-part narrative
  walkthrough, ~15k chars — "that's so long :( / can you give me a
  listing of items i can agree/disagree/correct?"
- `98f2be37` L1439→L1446: the repair that worked — 11 numbered items
  grouped by the reply owed, 1–3 sentences each, "My rec:" inline.
- `98f2be37` L1477: "This workflow sucks. Real bad. I have a bunch of
  toil copy-pasting your answer and formatting it, and your multipart
  responses get separated from their referents making them
  inscrutible." — origin of the file-register law. The toil is
  owner-side quote-reply prose, not chat presentation as such.
- `33e3067f` L199 (Aug 23): "i didn't read your … section because the
  synthesis is lacking. all the items you listed are second- or
  third-order concerns about this deep stack frame of a larger piece."
- `d5828a77` L859ff (Aug 26), a real register run: "editing in place?
  where?"; "a vim command would be helpful"; "commit seems premature.
  uncommit, leave it staged"; the owner then ruled by editing the
  files inline.
- `6c04b3e5` L525→L527 (Aug 28 am), the praised format: 13 questions
  in 4 sections, each a bold universal question + 1–2 evidence
  sentences + "Mine:" with a one-line reason. "Good calls all around!"

## Per-rule provenance

- **Only acts deserve the ask.** A signature on a fact records a false
  judge; the same law as the sweep skill's cheapest-competent-court.
- **Artifact in hand.** One decision was unanswerable from
  descriptions: the owner asked "Hm? Where?", and reading both
  artifacts in full dissolved the question outright.
- **Frame stated.** From `33e3067f` L199 above. Frame synthesis is
  dialogic — the agent cannot do it unilaterally; it needs discussion,
  archeology, or the owner's own reflection. "When neither is needed
  that's a windfall, not the usual case" is why the entry says a free
  frame is a windfall rather than treating it as the normal path.
- **Reply unconstrained.** The menu/AskUserQuestion prohibition this
  once restated lives in `before/using-claude-code-tool/
  AskUserQuestion.md` and fires on its own trigger. Do not restate it
  here; that duplicate was cut on sight.
- **Labels, not numbers.** Ruled verbatim: "Numbers get ambiguous way
  too quickly, can't represent graph structure well."
- **A file register, always.** The one live contradiction of the pass,
  resolved by ruling: routing by expected reply size was rejected —
  "how is agent to tell if the **reply** is word-size? It can't." The
  register is required unconditionally; chat carries only the tally,
  the paths, and the editor command. Special cases were left for later
  "if the cost/benefit seems worthwhile" — so an editor adding a
  small-batch exemption is reopening a closed question, not
  optimizing. Ergonomics were ruled too: "a git-add but not a commit
  of question-register seems appropriate."
- **A stated position.** Sourced from the llm-claims SIGNATURE and
  PROVISIONAL claims, and from the "over-veto" incident (session,
  2026-08-09), where unstated agent positions turned ratification into
  rubber-stamping.
- **A second projection.** The predecessor was a mandated five-part
  skeleton, a ruled failure: "Too often it's just five
  similarly-opaque phrasings of the same thing." The intent survived
  (several genuinely different concretizations), the template did not.
  Length caps were rejected in the same breath — "Length is not the
  problem" — so the rule must never be re-tightened into a word budget.
- **Unfuse the variables.** Three of the pass's own option-pairs were
  false dichotomies, called out one at a time. This is the same razor
  as `when/redesigning-something-that-already-exists.md` ("a binary
  design question usually names the wrong variable"), applied to
  authoring a decision's options. The pointer was dropped from the
  entry because that entry fires on its own trigger; keep it that way
  rather than copying the razor's text across.

## The razor that produced this file

The owner, on finding drafting-time rationale written into the entry:

> "You need to distinguish between what *you* needed to know to write
> the skill and what *the agent using the skill* needs to know."

Editorial feedback given mid-drafting addresses the writer. Integrating
it verbatim is audience-mismatch bloat: the acting agent needs the
stance, the success criteria, and the tools, not the argument that
produced them. That argument is what this file is for.
