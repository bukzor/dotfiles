let's commit the good work we've done.

CRITICAL SAFETY RULES:
- NEVER use git-restore, git-checkout, or any destructive git commands
- NEVER discard changes without explicit human approval
- When in doubt about any change, STOP and ask for human review
- ALWAYS examine changes with git-diff before deciding their fate
- Use cp -i and mv -i when moving files to prevent accidental overwrites

procedure:

**Iterative Process** (repeat until clean):
- Identify the next smallest coherent commit
- Group changes for review efficiency:
  * **Large commits**: Same pattern across many files (easy to skim)
  * **Small commits**: Complex changes needing scrutiny
- **Commit ordering**: dependencies first (infrastructure → features, machinery → data)
- **Use fixup!** for: obvious corrections to recent commits (typos, forgotten files, related improvements)
- **Ask human** if: multiple reasonable approaches or you might disagree with my judgment

**Required mechanics**:
- `git commit -m "message" file1 file2` (never stage-and-commit without file args)
- Each commit should represent a working system state
- Always end messages with: `🤖 Generated with [Claude Code](https://claude.ai/code)\n\nCo-Authored-By: Claude <noreply@anthropic.com>`

4. **Handle Non-Commit Files** (only with explicit human approval):
   - create trash/ directory if it doesn't exist
   - move stale/generated files to trash/ using `cp -i` then `mv -i` 
   - amend .gitignore for files we'll never commit but will usually exist

5. **Verify Success**:
   - git status should show clean working tree
   - all valuable work preserved either in commits or trash/

NEVER PROCEED TO STEP 4 WITHOUT HUMAN APPROVAL OF WHAT TO MOVE TO TRASH

---

## "Coherent Commits" 

**Key principle**: File moves/renames must be atomic (deletion + addition together, never split)

**Timeline goal**: Commits should tell a plausible development story, even if fictional

---

## Pre-commit Hook Failures

- **Check the exit code** - if the commit command failed, no commit was made  
- **When hooks fail after making fixes:** run the exact same commit command again
