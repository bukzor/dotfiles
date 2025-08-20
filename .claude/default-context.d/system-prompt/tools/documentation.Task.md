# Documentation Task - Function Definition Breakdown

This Task prompt successfully breaks down function definitions into organized file structures.

## Task Prompt

```
For your [FUNCTION_NAME] function definition from your <functions> section:

1. Create the directory /Users/buck/.claude/claude-startup-context.d/system-prompt/tools/[FUNCTION_NAME].d/
2. Create one file per attribute of the [FUNCTION_NAME] function definition, using appropriate suffixes:
   - Use .md for description and other text content
   - Use .json for JSON schema and structured data
   - Use .txt for simple string values
3. Write the content of each attribute to its respective file

For example: description.md, parameters.json, name.txt, etc. - whatever attributes exist in the [FUNCTION_NAME] function definition.
```

## Usage

Replace `[FUNCTION_NAME]` with the actual function name (e.g., KillBash, WebFetch, etc.)

## Results

Creates a structured directory with files organized by attribute type:
- `name.txt` - Function name
- `description.md` - Function description 
- `parameters.json` - JSON schema definition
- Additional files as needed per function attributes