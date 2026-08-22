# When a stopped or killed agent needs resuming

Trigger: an agent or session should continue, but the harness refuses
(SendMessage: "stopped by the user and won't be resumed") — or every
resume re-lives a poisoned tail (a bogus error, an interrupt) and dies
again.

Load `Skill(claude-code-surgery)` before touching anything under
`~/.claude/projects`. Inspect first with `Skill(claude-code-archeology)`
tools; the surgery skill holds the locks, the cut rules, and worked
cases.

## When NOT to trigger

- The agent died for exogenous reasons (timeout, sleep, auth) and the
  harness *accepts* a resume: just SendMessage it — surgery is for
  refused or poisoned resumes only.
