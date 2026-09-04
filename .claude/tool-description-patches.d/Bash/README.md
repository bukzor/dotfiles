Two upstream families ride concurrently: a ~1.3k harness form (opus/fable)
and the classic ~10k long form (fable/sonnet sessions), each with the model
name baked into its commit-trailer example -- hence one upstream.d/ file per
(family, model) wording. A new model name or a 1M-context marker will trip
`changed-upstream`; just add the new wording.

2.1.238 dropped the long form's "dedicated tools" preamble paragraph (the
`IMPORTANT: Avoid using this tool to run cat/head/tail/...` block and its
Read/Edit/Write bullets) from the opus-1m wording, otherwise unchanged from
2.1.232 -- already redundant with the stub's one-line version of the same
rule, so nothing to fold in.

The stub keeps mechanics (state persistence, dedicated-tools rule, timeout,
run_in_background) plus the git safety line, and defers everything else:
Bash conventions to must-read.kb/before/running-ANY-Bash-commands.md, git
conventions to must-read.kb/before/git/. The long form's step-by-step
commit/PR procedure is deliberately dropped, not moved: it teaches bare
`git commit`/HEREDOC flows and only-commit-when-asked, both of which the
user's standing config overrides (commit-files/commit-staged, commit
eagerly). The commit trailer convention lives in
reference.kb/git/commit.md.
