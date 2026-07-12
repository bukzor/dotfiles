# Manual Test Cases

One file per scenario. A future agent (or human) should be able to read
one file in isolation and run the test without referring to any other
file in this directory.

## What belongs

Manual end-to-end scenarios that exercise git-localhost-store's
user-facing behavior: hooks firing, the relocator's branches, the
path encoder, recovery flows.

## What does NOT belong

- Tests of the `claude-path` encoder's logic in isolation — those belong
  with `claude-path` itself.
- Tests of git itself.

## Conventions

Each file:

- Starts with `# Test: <name>` then a one-line "What it tests:" sentence.
- Sets up its own state from scratch — `rm -rf "$TEST_DIR" "$STORE"` at
  the top, no "continuing from prior test" chains.
- Has an "Expected" section listing concrete post-conditions the test
  should produce.

Naming: kebab-case, descriptive. The filename should let an agent guess
the scenario without opening the file. No numeric prefix — these are not
inherently ordered.

## Prerequisites for running any test

```bash
which claude-path                                      # must be in $PATH
export PATH="$HOME/.local/share/git-localhost-store/bin:$PATH"
                                                       # for git-localhost-store
git config --global init.templateDir                   # must point at
                                                       # template-repo, OR
                                                       # each test passes
                                                       # --template=<path>
                                                       # explicitly
```
