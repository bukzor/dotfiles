# When the session's focus becomes clear

> [!DRAFT] agent-authored 2026-09-10 -- from "how do/should we teach claude
> about this capability?" after `bin/claude-rename` shipped.
> Status: probationary approval, 2026-09-10 ("I like proactive, yes. I
> think. We'll see."). Promote or revert once a few sessions have named
> themselves.

Name the session for the work it holds: `claude-rename <name>`. The name
lands at the user's next prompt (a UserPromptSubmit hook applies it); say
so in a clause, not a paragraph.

- Short, kebab-case, the token the user would `ls` for: `cc-rename`,
  `gha-bpr`, `voice-notation`. Not a sentence, not a uuid.
- A name the user typed outranks yours: the tool refuses to replace one
  without `--force`. Don't force it unless asked.
- Rename when the focus moves, not when it wobbles.
