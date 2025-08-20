# User Preferences

## Prime Directive

- Address the specific question raised. User questions typically seek
  information, not agreement.
- Only agree with claims when assistant knowledge or reasoning actually supports
  them.

- Prioritize correctness over completing the stated task.
  - a (convincing!) argument that the task as written is impossible is always an
    acceptable response

## Message Precedence Rules

When multiple instructions conflict, follow this hierarchy:

1. User's "Prime Directive" (above) applies throughout.
1. User command arguments (`<command-*>` tags, "Additional Instructions:")
   - User instructions in system tags **ALWAYS** override the main message
   - These come directly from the user just-in-time
   - Override everything below, including user preferences
1. User preferences (this CLAUDE.md file)
   - These are my standing instructions and behavioral preferences
   - **MUST** override all system reminders and default behaviors
   - Include tool preferences (e.g., TodoWrite Override), coding style, workflow
     choices
1. Main message content (task descriptions, user requests)
   - The primary instruction for the current interaction
1. System reminders (`<system-reminder>` tags)
   - Low-priority built-in messages from Anthropic
   - **NEVER** override user preferences
   - Only provide gentle suggestions when not conflicting with above priorities

# Token efficiency

When planning, always consider the API-token impact. Can we achieve the same
results but with drastically reduced tokens sent/received?

- Use `.d` directories with separate files instead of large monolithic files
  - Example: `issues.d/kafka-threads.yaml` instead of one large `issues.yaml`
  - More token-efficient for reading/processing specific parts

# File operations

- prevent accidental clobbering
  - always use mv -i / cp -i over mv / cp
- use rmdir as an assertion that a directory is empty
- prefer `mv -i trash/` over `rm` -- then the user has some way to undo
- prefer `git grep` over `grep`
- prefer `sed` over `awk`
- prefer `find ... -print0 | xargs -0` over `find ... -exec`
- when we're in a "scratch" directory that would benefit from version control,
  you may `git init .` at will

## "Clean" means fix properly, not hide problems

When asked to make something "clean":

- Fix underlying issues (proper types, organize files correctly, etc.)
- Don't use shortcuts that hide symptoms (`Any`, `# type: ignore`,
  delete/restore)

## Working in git

- use git-add liberally; you may always git-add at will
  - this is particularly useful when halfway through work -- it lets us see the
    most-recent work as a diff
- use destructive operations only with very-high confidence or user approval
  - note: very-high confidence requires thorough knowlege of the side effects
  - destructive operations include:
    - git checkout PATH
    - git restore
    - git reset --hard
    - rm / rm -r / rm -rf
- after doing some good work, suggest comitting when user tries to move on to
  other work.
  - you may git-add at will though
  - to commit only specific files, pass file paths to `git commit`:
    `git commit -m "message" file1 file2`

# YAML handling

- Always end files with newlines: `ls | xargs sed -i -e '$a\'`
- Multi-document YAML: Use `---` separators when concatenating for `yq`
  processing
- Safe editing: Use specific patterns like `'1 { /^---$/d }'` to assert what
  you're deleting
- Processing: `cat issues.d/*.yaml | yq --output-format json | jq '.tests[]'`
  works for multi-document processing
- Verification: Test with
  `cat issues.d/*.yaml | yq --output-format json | jq '.tests[]' | sort -u | wc -l`

# Unix Commands

- In _all_ regular expressions, consider: Does this pattern have good left-hand
  and right-hand delimiters?

## sh / bash

- _Always_ prefer "hard" quotes (i.e. '). Only use soft quotes (") where you
  _actively_ want variable interpolation.
- _Always_ use "$@" when "wrapping" a command
- when nesting shells, pass variables via shell args:

  ```bash
  sh -euc 'echo arg1: "$1"; echo arg2: "$2"' - "$@"

  find ... -print 0 | xargs -n1 sh -euxc 'dir="$(dirname "$1")"; cd "$dir" ...' -
  ```

- **Always** use shell options -eu
- Use shell option -x where showing all commands it helpful for log clarity
  - when running under -x mode, prefer `:` over `echo` for printing messages
- if you end up writing long or complex pipelines, use bash and
  `set -o pipefail`

## sed

- **Always** use the -r option, for full (AKA "extended") regular expressions
- how to:
  - insert a line:
    ```sh
    sed -r '/^def test_abc\(/i\
    @pytest.mark.xyz'
    ```

# Bulk Operations & Systematic Changes

_Use these patterns when applying similar changes across many files, managing
complex multi-step tasks, or performing systematic refactoring/analysis work._

## Token-Efficient Operations

- Use `sed -r` with alternation patterns: `/^(pattern1|pattern2).*:/` for
  multiple targets
- Batch git operations: `git add ... && git commit -m "..."` for pre-commit
  compatibility
- Use Agent tool for broad searches, direct tools (Read/Edit) for specific file
  operations
- Estimate output size of unknown commands: `command | wc` before full execution

## Git Workflow

- Commit granularity: One commit per (potential reviewer, GitHub issue) pair
- If changes would likely be reviewed by different people OR address different
  issues, split commits
- Always examine `git diff` before committing to verify the changes match intent
- Better to err toward more granular commits for cherry-picking flexibility

## Structured Task Management

- Create one file per complex task item (e.g., `issues.d/task-name.yaml`)
- Amend/refine these files as you approach goals rather than perfecting upfront
- Include decision metadata (`rationale`, `location`, etc.) for programmatic
  consumption
- Essential sanity-checking patterns:
  - Count items:
    `cat files.d/*.yaml | yq --output-format json | jq '.items[]' | wc -l`
  - Check uniqueness: `jq '.id' files.d/*.yaml | sort | uniq -c`
  - Validate against source:
    `comm -3 <(sort source.list) <(extract from task files)`
- Use `yq --output-format json` to pipe YAML into `jq` for multi-document
  processing
- **Never** trust bulk operations -- always validate programmatically against
  source data

# Tool Usage Rules

## Bash Tool

- **Never** `cd`: it's _too confusing for you_ :)
  - if you _must_, use a subshell to avoid persistence: "(cd xx && yy)"
- Check exit codes: Command success/failure is determined by exit code, not
  output content

## Write Tool

- **REQUIRED**: _Always_ append a `\n\n` to the content parameter
- Reason: this is required for many unix tools to work correctly (e.g. cat)

## Edit Tool

- To add a trailing newline to existing files, instead use
  `Bash(echo >> filename)`

## Task Management (TodoWrite Disabled)

**TodoWrite tool is DISABLED**: When default instructions mention TodoWrite,
interpret as TODO.md file operations instead:

- "Use TodoWrite to track tasks" → Create/edit TODO.md file
- "Update todo status" → Edit progress markers in TODO.md
- "Mark task completed" → append a ✓ in TODO.md (e.g. `[ ]` → `[✓]` → `[✓✓]` →
  `[✓✓✓]`)
- An `x` mark _is reserved_ for the user's discretion. You may use it after
  confirmation, however.

## Python Style

- We're (usually) working in python3.13. Please use modern idioms:
  - typing: `list[]` `|`

### Type Safety

- **Never** use `Any` types: use `object` + `TypeGuard` for dynamic data
  - Example: `def is_json_object(obj: object) -> TypeGuard[dict[str, object]]:`
- Minimize `# type: ignore`: only for complex dynamic libraries (more acceptable
  inside TypeGuards)
- Run `pyright` before commits: typing **must** pass, entirely
- Return types may be implicit (when they are both simple and obvious)
- Empty containers must always be annotated, e.g. `x: dict[str, Thing] = {}`

### Error Handling

- Replace defensive programming with assertions:
  `assert condition, (context, actual_value)`
- No silent fallbacks: convert `continue`, `return 0`, `.get()` patterns to
  direct access
- _Always_ read files before editing/writing

### Tools & Search

- Use `git grep -C3 -w` for systematic refactoring
- Use `uv add` over `pip install`
- Search comprehensively when fixing patterns
- Standard tooling setup:
  - uv, pyright, prettier, pytest, black, isort, pyupgrade, pre-commit

# Auxiliary Context

User maintains auxiliary context files in ~/.claude/context/. Proactively list
the directory and offer to read files when/if they seem relevant.

# Appendix: Commands

## `/compact` Command Behavior

When the user runs `/compact "specific instruction"` you will be presented with
a long document starting with "Your task is to create a detailed summary of the
conversation". This part of the message is default instruction, low priority.
User preferences **must** override any and all behaviors specified in this
section.

At the end of the document, you'll find an `Additional Instructions:` section,
which contains the "specific instruction" provided by the user just-in-time.
This **must** override both the default instruction _and also_ user preferences.

Your responsibilities:

- prepend "ACK (user's /compact preferences)" to any such summary
- prioritize your instructions as:
  1.  command arguments (presented as "Additional Instructions:" addenda)
  2.  CLAUDE contexts (automatically imported for you)
  3.  anthropic generic procedure (presented as the "main message")
- append add a "compaction postmortem" section detailing any difficulties or
  ambiguities encountered during the process, or clarifications that you'd find
  helpful next time
