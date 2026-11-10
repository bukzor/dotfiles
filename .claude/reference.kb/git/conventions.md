# Git conventions

### Repository Targeting

Use `git -C <directory>` to specify the repository -- never `cd <directory> && git`:

```bash
git -C /path/to/project status
git -C /path/to/project diff HEAD~1
```

### Path Scoping

**MANDATORY:** ALL git commands MUST include explicit path arguments. Unqualified commands will be blocked.

Use `.` for current directory when operating on the whole repository:

```bash
git status -s .
git diff .
git l -n10 .
```

### Log

Use `git l` (alias) instead of `git log --oneline`. It provides graph, ISO date, and relative time:

```bash
git l -n5 .           # recent commits at path
git l -n10            # recent commits in repo
```

Other paths:

```bash
git status -s path/to/file
git diff path/to/directory/
```

### Push

Ordinary `push` is not caution-gated at `git-caution: solo|personal`: push
freely, don't ask. Only the force variants consult the caution table in
`commit.md`. Leaving verified work unpushed is the state that costs something.

For commits, see `~/.claude/reference.kb/git/commit.md` — always use `git commit-staged`.

### Index Hygiene

The index may contain staged changes unrelated to current work. Treat index modification as destructive.

- Stage changes with `git add` before committing
- Use `git commit-staged` to commit only staged changes at specific paths
- Never use `git commit -- paths` - it commits from working copy, not the index

### Setting work aside

Never `git stash` — it's unscoped and destructive (silently moves the working
tree and index). To park in-progress work, commit it on a throwaway branch:

```bash
git checkout -b wip && git commit -am WIP && git checkout -
```

The work is a real commit (recoverable, inspectable), and `checkout -` returns
to the prior branch with a clean tree.
