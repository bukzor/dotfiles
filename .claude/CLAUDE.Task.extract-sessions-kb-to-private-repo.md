--- # workaround: anthropics/claude-code#13003
requires:
  - ./must-read.kb/before/git/commit.md
  - ./must-read.kb/before/git/ANY-git-command.md
cost-benefit-sweh:
  timebox:
    "@value": 3.0
    rationale: |
      Repo creation + filter-repo extraction + dotfiles gitignore +
      multi-host clone setup. Beyond 3h, the per-host portability
      (cwd: paths) needs its own design conversation.
  benefit-2w:
    "@value": 1.5
    rationale: |
      Reduces dotfiles churn ongoing; ~3-5 min saved per dotfiles
      commit reviewing log/blame × frequent commits over 2 weeks.
      Also unblocks parallel sessions.kb work on other hosts.
---

# Task: Extract `~/.claude/sessions.kb/` to a private repo

## Problem

`sessions.kb/` is a high-churn working journal. Living in dotfiles
pollutes that repo's log/blame. Submodules double the churn (every
sessions commit forces a pointer bump). Solution: a private GitHub
repo, cloned directly at the path, dotfiles gitignores it.

Steps:

- [ ] Confirm with user: repo name, history preservation, per-host subdir layout
- [ ] Create `bukzor/claude-sessions` private repo via `gh repo create`
- [ ] Extract history with `git filter-repo` into a temp clone under `~/trash`
- [ ] Push the extracted repo to GitHub
- [ ] Switch the working host: `git rm`, gitignore, clone fresh at `~/.claude/sessions.kb`
- [ ] Add CLAUDE.md inside new repo (per-host subdir convention, push cadence, `cwd:` portability stance)
- [ ] Clone the new repo on other hosts
- [ ] Verify: entries visible, dotfiles clean, fresh claude-code session can read sessions.kb

## Confirm with user before starting

1. **Repo name**: `bukzor/claude-sessions` (private)?
2. **Preserve history** via `git filter-repo`? (Alternative: fresh
   start, single initial commit.)
3. **Per-host subdir layout** (`sessions.kb/<hostname>/<entry>.md`)?
   The schema's absolute `cwd:` paths don't port across hosts; per-host
   subdirs sidestep both portability and merge conflicts. Hostname:
   `$(hostname -s)`.

## Procedure

### 1. Create repo

```bash
gh repo create bukzor/claude-sessions --private --description "claude-code session index"
```

### 2. Extract history

```bash
tmp=$(mktemp -d -p ~/trash claude-sessions.XXXX)
git clone ~/ "$tmp/extract"
cd "$tmp/extract"
git filter-repo --path .claude/sessions.kb --path-rename .claude/sessions.kb/:
```

For per-host layout: explicitly list existing files and move them.
Don't trust a glob — verify staged set before committing.

### 3. Push

```bash
git remote add origin git@github.com:bukzor/claude-sessions.git
git push -u origin <branch>   # whatever filter-repo produced
```

### 4. Switch the working host

```bash
git -C ~ rm -r .claude/sessions.kb
echo "/.claude/sessions.kb/" >> ~/.gitignore
git clone git@github.com:bukzor/claude-sessions.git ~/.claude/sessions.kb
git -C ~ commit-files .gitignore .claude/sessions.kb -- -m "$(cat <<'EOF'
sessions.kb: extract to private claude-sessions repo

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### 5. Update CLAUDE.md inside new repo

Document per-host subdir convention, push cadence, and whether `cwd:`
stays host-absolute or becomes portable.

### 6. Other hosts

```bash
git clone git@github.com:bukzor/claude-sessions.git ~/.claude/sessions.kb
mkdir -p ~/.claude/sessions.kb/$(hostname -s)
```

### 7. Verify

- `ls ~/.claude/sessions.kb/<host>/` shows existing entries
- `git -C ~ status .claude/sessions.kb/` shows nothing
- A fresh claude-code session can read sessions.kb (allow-list still
  covers `~/.claude`)

## Risks

- **Secrets in history.** `filter-repo` preserves everything; run
  `gitleaks detect` against the extracted repo before pushing.
- **Dotfiles history retains the old sessions.kb commits.** Not
  rewriting; accept it.

## Rollback

If the new repo is the wrong shape, the source of truth is dotfiles'
history until Step 4 lands. Before Step 4: delete/force-push the
GitHub repo and re-extract. After Step 4: `git revert` the dotfiles
commit and `git checkout HEAD .claude/sessions.kb`.

## Out of scope

- Tooling to enumerate entries across hosts.
- Sync to a future team-sessions repo.
