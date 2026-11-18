---
source: mutual
status: firm
see-also:
  - case-study.kb/git-add-parse-failure.md
  - failure-modes.kb/parse-not-updated-after-correction.md
  - failure-modes.kb/shallow-causal-analysis.md
---

# Pyproject.toml lost and restored

This is the multi-turn arc that started with the git-add parse
failure and ran for several exchanges before stabilizing. The thread
illustrates how a single misparse cascades when correction is
treated as surface-action rather than as a parse-rule update.

Initial state: the user had added a `[tool.pyright]` block to
`pyproject.toml` (working-copy only, not committed, not staged) as
a workaround for sibling-import resolution. The prior Claude had
read the file and used the workaround in subsequent operations.

Turn N: user asks "git-add, remove it, then re-test." Prior Claude
parses "git-add" against the wrong subject, stages the incubator
work, then removes the workaround from `pyproject.toml` via Edit.
Working copy now has no workaround, index has no copy, HEAD never
had it.

Turn N+1: prior Claude runs the test, sees it fails from `/tmp`
(predictable: cwd-based config discovery). Reports findings as if
they're investigative output.

Turn N+2: user says "git checkout to restore pyproject.yaml." Prior
Claude runs git diff and discovers no diff — the file matches HEAD,
because HEAD never had the workaround. Cannot checkout from nothing.

Turn N+3: user says "=.= you didn't add the change. anyhow restore
the change." Prior Claude restores via Edit (re-typing the workaround
content from memory). The surface remediation is correct.

Turn N+4: prior Claude *does not* trace back what its earlier "git-add"
parse should have been. It treats the correction as "redo this
specific thing" rather than "your parse strategy was wrong;
recompute." This is the parse-not-updated-after-correction failure
mode, and it leaves the broken parse strategy active for the next
turn.

Turn N+5+: subsequent turns asking about "the test" depend on the
same parse work (which file, which test). The still-broken model
produces wrong tests, generating the run-the-test repetition arc.

The lesson: a correction is data about the parse rule, not just
about the action. The prior Claude's analysis of this episode in
the realignment was itself shallow — it identified "asked permission
unnecessarily" as a failure but missed that the user's "why pause"
question was a fact-query, not a directive. The user had to surface
the missed cause directly. The shallow-causal-analysis failure mode
applies to the prior Claude's analysis OF this episode, not just to
the episode itself.
