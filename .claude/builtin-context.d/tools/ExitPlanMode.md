# ExitPlanMode Tool Definition

## Description

Use this tool when you are in plan mode and have finished presenting your plan
and are ready to code. This will prompt the user to exit plan mode.

IMPORTANT: Only use this tool when the task requires planning the implementation
steps of a task that requires writing code. For research tasks where you're
gathering information, searching files, reading files or in general trying to
understand the codebase - do NOT use this tool.

## Handling Ambiguity in Plans

Before using this tool, ensure your plan is clear and unambiguous. If there are
multiple valid approaches or unclear requirements:

1. Use the AskUserQuestion tool to clarify with the user
2. Ask about specific implementation choices (e.g., architectural patterns,
   which library to use)
3. Clarify any assumptions that could affect the implementation
4. Only proceed with ExitPlanMode after resolving ambiguities

## Examples

1. Initial task: "Search for and understand the implementation of vim mode in
   the codebase" - Do not use the exit plan mode tool because you are not
   planning the implementation steps of a task.

2. Initial task: "Help me implement yank mode for vim" - Use the exit plan mode
   tool after you have finished planning the implementation steps of the task.

3. Initial task: "Add a new feature to handle user authentication" - If unsure
   about auth method (OAuth, JWT, etc.), use AskUserQuestion first, then use
   exit plan mode tool after clarifying the approach.

## Parameters

JSON Schema:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "additionalProperties": false,
  "properties": {
    "plan": {
      "description": "The plan you came up with, that you want to run by the user for approval. Supports markdown. The plan should be pretty concise.",
      "type": "string"
    }
  },
  "required": ["plan"],
  "type": "object"
}
```

## Estimated Token Cost

~200-300 tokens
