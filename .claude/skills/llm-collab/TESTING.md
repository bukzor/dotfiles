# Testing llm-collab

Manual test procedures for verifying the skill works correctly.

## Maintaining These Tests

- When adding a new script → add corresponding test
- When changing skeleton structure → update skeleton integrity checks
- When a bug slips through → add a test that would have caught it

## Validating These Tests Are Correct

The skeleton integrity check must stay in sync with what scripts actually reference:

```bash
# Extract paths scripts expect from skeleton
grep -hro '\$SKELETON/[^"]*' bin/* | sort -u

# Compare against paths listed in "Skeleton Integrity Check" section
# Any mismatch means TESTING.md is stale
```

If a script fails but these tests didn't catch it, TESTING.md is incomplete.

## Quick Smoke Test

```bash
cd ~/.claude/skills/llm-collab
tmpdir=$(mktemp -d)
bin/llm-collab-init "$tmpdir"
echo "Exit code: $?"
ls -la "$tmpdir"/docs/dev/
rm -rf "$tmpdir"
```

**Expected:** Exit code 0, no errors, `docs/dev/{adr,devlog}/` exist with CLAUDE.md files.

## Skeleton Integrity Check

Verify all files referenced by scripts actually exist:

```bash
cd ~/.claude/skills/llm-collab

# Files llm-collab-init expects to copy
test -f skeleton/CLAUDE.md && echo "✓ CLAUDE.md" || echo "✗ CLAUDE.md"
test -f skeleton/ROADMAP.md && echo "✓ ROADMAP.md" || echo "✗ ROADMAP.md"
test -f skeleton/CONTRIBUTING.md && echo "✓ CONTRIBUTING.md" || echo "✗ CONTRIBUTING.md"
test -f skeleton/docs/dev/adr/CLAUDE.md && echo "✓ docs/dev/adr/CLAUDE.md" || echo "✗ docs/dev/adr/CLAUDE.md"
test -f skeleton/docs/dev/devlog/CLAUDE.md && echo "✓ docs/dev/devlog/CLAUDE.md" || echo "✗ docs/dev/devlog/CLAUDE.md"
test -f skeleton/docs/architecture/overview.md && echo "✓ docs/architecture/overview.md" || echo "✗ docs/architecture/overview.md"

# Files llm-collab-devlog expects
test -f skeleton/docs/dev/devlog/YYYY-MM-DD-000-example-entry.md && echo "✓ devlog template" || echo "✗ devlog template"

# Files llm-collab-adr expects
test -f skeleton/docs/dev/adr/YYYY-MM-DD-000-example-decision.md && echo "✓ adr template" || echo "✗ adr template"

# Files llm-collab-idea expects
test -f skeleton/.claude/ideas.kb/YYYY-MM-DD-000-example-idea.md && echo "✓ idea template" || echo "✗ idea template"
```

**Expected:** All checks pass. Any `✗` indicates a script/skeleton mismatch.

## Full Workflow Test

```bash
tmpdir=$(mktemp -d)
cd "$tmpdir"

# 1. Initialize
~/.claude/skills/llm-collab/bin/llm-collab-init .
echo "--- init exit: $? ---"

# 2. Create devlog entry
~/.claude/skills/llm-collab/bin/llm-collab-devlog "Test entry"
echo "--- devlog exit: $? ---"

# 3. Create ADR
~/.claude/skills/llm-collab/bin/llm-collab-adr "Test decision"
echo "--- adr exit: $? ---"

# 4. Create idea
~/.claude/skills/llm-collab/bin/llm-collab-idea "Test idea"
echo "--- idea exit: $? ---"

# 5. Verify structure
echo "--- Structure ---"
find . -type f | grep -v '.git' | sort

cd -
rm -rf "$tmpdir"
```

**Expected:** All exit codes 0. Structure includes:
- `CLAUDE.md`, `ROADMAP.md`, `CONTRIBUTING.md`
- `docs/dev/adr/CLAUDE.md` + dated ADR file
- `docs/dev/devlog/CLAUDE.md` + dated devlog file
- `.claude/ideas.kb/` + dated idea file

## Script Path Audit

Grep scripts for hardcoded paths and verify they match skeleton:

```bash
cd ~/.claude/skills/llm-collab
grep -n 'skeleton/' bin/* | grep -v '^Binary'
```

Review output: every `$SKELETON/path/to/file` must exist in `skeleton/`.

## Common Failure Modes

| Symptom | Likely Cause |
|---------|--------------|
| `cp: cannot stat '...'` | Script references path that doesn't exist in skeleton |
| `Error: docs/dev/devlog/ not found` | Script expects you to `cd` into project first |
| Init succeeds but scripts fail | Init creates different structure than scripts expect |
