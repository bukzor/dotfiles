Strip the gitStatus block from the system prompt.

This stale snapshot causes more problems than it prevents: the model
treats it as ground truth and resists updating its understanding when
the actual state diverges. Use `git status` directly when needed.
