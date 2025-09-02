# Unix Commands

- In _all_ regular expressions, consider: Does this pattern have good left-hand
  and right-hand delimiters?
- If you're unsure about a command's output size, measure the output size:
  `command | wc`
  - prefer this over head/grep as it often means you get full context "for free"

# File operations

- prevent accidental clobbering
  - always use mv -i / cp -i over mv / cp
- use rmdir as an assertion that a directory is empty
- prefer `mv -it trash/` over `rm` -- then the user has some way to undo
- prefer `sed` over `awk`
  - **Always** use the -r option, for full (AKA "extended") regular expressions
  - token efficiency: Use `sed -r` with alternation patterns:
    `/^(pattern1|pattern2).*:/` for multiple targets
- prefer `find ... -print0 | xargs -0` over `find ... -exec`

## Working in git

- **Never use `git add -A`**: Only use `git add -u` (tracked files) or specific paths
- token efficiency: Batch git operations: `git add ... && git commit -m "..."`
  for pre-commit compatibility
- when we're in a "scratch" directory that would benefit from version control,
  you may `git init .` at will
- Commit granularity: One commit per (potential reviewer, GitHub issue) pair
  - If changes would likely be reviewed by different people OR address different
    issues, split commits
  - Always examine `git diff` before committing to verify the changes match
    intent
  - Better to err toward more granular commits for cherry-picking flexibility
- use git-add liberally; you may always git-add at will
  - this is particularly useful when halfway through work -- it lets us see the
    most-recent work as a diff
- use destructive operations only with very-high confidence or user approval
  - note: very-high confidence requires thorough knowlege of the side effects
  - destructive operations include:
    - git checkout PATH
    - git restore
    - git reset --hard
    - rm
- after doing some good work, suggest comitting when user tries to move on to
  other work.
  - you may git-add at will though
  - to commit only specific files, pass file paths to `git commit`:
    `git commit -m "message" file1 file2`
- prefer `git grep` over `grep`

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
