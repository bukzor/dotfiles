--- # workaround: anthropics/claude-code#13003
requires:
  - ./must-read.kb/before/git/commit.md
  - ./must-read.kb/before/git/ANY-git-command.md
cost-benefit-sweh:
  timebox:
    "@value": 3.0
    rationale: |
      Repo creation + filter-repo extraction + submodule wiring +
      multi-host init. Beyond 3h, the per-host portability (cwd:
      paths) needs its own design conversation.
  benefit-2w:
    "@value": 1.5
    rationale: |
      Moves sessions.kb's file-content churn out of dotfiles' log/blame
      (submodule pointer bumps remain, but are much smaller diffs);
      ~3-5 min saved per dotfiles commit reviewing log/blame × frequent
      commits over 2 weeks. Also unblocks parallel sessions.kb work on
      other hosts.
---

# Task: Extract `~/.claude/sessions.kb/` to its own repo

## Problem

`sessions.kb/` is a high-churn working journal. Living in dotfiles
pollutes that repo's log/blame. Solution: a public GitHub repo
(revised 2026-07-09 — see Decision 1 below), wired back into dotfiles
as a **git submodule** at the same path (user's explicit preference,
2026-07-09 — they already lean on submodules elsewhere, e.g.
`repo/scratch`). The churn concern is mitigated by only bumping the
dotfiles gitlink pointer as needed, not after every sessions.kb-side
commit.

Steps:

- [x] Confirm with user: repo name, history preservation, per-host subdir layout, submodule vs plain clone
- [x] Create `bukzor/bukzor.claude-sessions` repo (public) via `gh repo create`
- [x] Extract history with `git filter-repo` in the `~/repo/github.com/bukzor/dotfiles` working copy
- [x] Push the extracted repo to GitHub — https://github.com/bukzor/bukzor.claude-sessions, `main`, 77 commits, `gitleaks detect` clean
- [ ] **Go/no-go checkpoint**: strip sessions.kb from dotfiles history (force-push, rewrites shared `svelte-crostini`)
- [~] Switch the working host: `git rm`, `git submodule add` at `~/.claude/sessions.kb`, `mkdir penguin/` — **blocked**, see review note in `~/.claude/sessions.kb/extract-sessions-kb-to-own-repo.md` (apparent concurrent activity in the live directory)
- [x] Add CLAUDE.md inside new repo (per-host subdir convention, push/pointer-bump cadence, `cwd:` portability stance) — pushed as `7f33915`
- [ ] Init the submodule on other hosts
- [ ] Verify: entries visible, dotfiles gitlink clean, fresh claude-code session can read sessions.kb

## Decisions (confirmed by user 2026-07-09; full rationale in
`~/.claude/sessions.kb/extract-sessions-kb-to-own-repo.md`)

1. **Repo name**: `bukzor/bukzor.claude-sessions` — `bukzor.` prefix
   survives forks. **Visibility: public** (revised 2026-07-09 — the
   original plan said "private" with no rationale ever recorded;
   sessions.kb is already public today, living inside the public
   `bukzor/dotfiles`, so a public split repo creates no new exposure,
   and it keeps GitHub Actions minutes free on standard runners if CI
   is added later — private repos meter against a capped monthly
   quota).
2. **History, as an ideal**: full symmetric `git filter-repo` split —
   new repo gets sessions.kb's full history; dotfiles gets it stripped
   entirely, so dotfiles' current `.git` ≈ union of the two resulting
   repos. The strip-from-dotfiles half is a force-push rewrite of the
   shared `svelte-crostini` branch — treat it as its own go/no-go, not
   bundled into "do the extraction."
3. **Per-host subdir layout**: `sessions.kb/<hostname>/`. Confirmed.
4. **Working copy**: do the filter-repo surgery in
   `~/repo/github.com/bukzor/dotfiles` (disposable second clone of
   `origin`), not in `~`. Canonical commits/pushes still happen from
   `~`; pull into the working copy to sync as needed.
5. **Branch**: `bukzor/dotfiles` has an orphan `svelte-crostini`
   branch (no common ancestor with `main`). Treat it as the effective
   main line for this task; ignore `main`.
6. **Wiring: submodule**, not a gitignored plain clone. Mirror the
   existing `repo/scratch` submodule convention: `git submodule add`,
   real branch checked out (not detached), `active = true`. Accept the
   pointer-bump churn as a known, chosen tradeoff.

## Procedure

### 1. Create repo

```bash
gh repo create bukzor/bukzor.claude-sessions --public --description "claude-code session index"
```

### 2. Extract history (in the working copy)

```bash
cd ~/repo/github.com/bukzor/dotfiles
git checkout svelte-crostini
git switch -c extract/sessions-kb
git filter-repo --path .claude/sessions.kb --path-rename .claude/sessions.kb/:
```

For per-host layout: explicitly list existing files and move them
into `<hostname>/` (this host: `penguin`). Don't trust a glob — verify
the staged set before committing.

### 3. Push

```bash
git remote add sessions git@github.com:bukzor/bukzor.claude-sessions.git
git push sessions extract/sessions-kb:main
```

### 4. Strip from dotfiles history — go/no-go checkpoint

Re-clone (or re-fetch) a clean working copy before this step; the
extract in step 2 rewrote refs in place. This rewrites every commit
from the first `.claude/sessions.kb` touch onward (68 of 358 commits
on `svelte-crostini`) and requires a force-push. Confirm explicitly
before running, and confirm again before the force-push — other host
clones will diverge until reconciled.

```bash
cd ~/repo/github.com/bukzor/dotfiles
git checkout svelte-crostini
git switch -c strip/sessions-kb
git filter-repo --invert-paths --path .claude/sessions.kb --force
# review, then:
git push --force-with-lease origin strip/sessions-kb:svelte-crostini
```

### 5. Switch the working host (`~`) — wire up as a submodule

This has to happen in `~` directly (the real working tree), not the
scratch clone.

```bash
git -C ~ rm -r .claude/sessions.kb
git -C ~ submodule add git@github.com:bukzor/bukzor.claude-sessions.git .claude/sessions.kb
mkdir -p ~/.claude/sessions.kb/penguin
git -C ~ commit-files .gitmodules .claude/sessions.kb -- -m "$(cat <<'EOF'
sessions.kb: extract to bukzor.claude-sessions repo, wire back
in as a submodule

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
git -C ~ push origin svelte-crostini
```

Ongoing: this is where the churn is mitigated — bump the dotfiles
gitlink pointer only as needed (not after every sessions.kb-side
commit). When it is needed:

```bash
git -C ~ add .claude/sessions.kb
git -C ~ commit-files .claude/sessions.kb -- -m "sessions.kb: bump pointer"
git -C ~ push origin svelte-crostini
```

### 6. Update CLAUDE.md inside new repo

Document per-host subdir convention, push cadence, and whether `cwd:`
stays host-absolute or becomes portable.

### 7. Other hosts

```bash
git -C ~ submodule update --init .claude/sessions.kb
mkdir -p ~/.claude/sessions.kb/$(hostname -s)
```

If step 4 (history strip) landed, each other host's dotfiles clone
also needs to pick up the rewritten `svelte-crostini` — a hard reset
to the new remote tip, not a normal pull/merge — before the submodule
init will resolve correctly.

### 8. Verify

- `ls ~/.claude/sessions.kb/<host>/` shows existing entries
- `git -C ~ submodule status .claude/sessions.kb` shows the expected SHA/branch
- `git -C ~ status .claude/sessions.kb` shows nothing (no unpushed pointer bump)
- A fresh claude-code session can read sessions.kb (allow-list still
  covers `~/.claude`)

## Risks

- **Secrets in history.** `filter-repo` preserves everything; run
  `gitleaks detect` against the extracted repo before pushing — more
  important now that the target is public, not private. Not currently
  on PATH on this host (`penguin`) — `brew install gitleaks` before
  step 3.
- **History strip force-pushes a shared branch.** Every other clone
  of `bukzor/dotfiles` (other hosts) diverges until they hard-reset to
  the rewritten `svelte-crostini`. Coordinate timing.
- **Pointer-bump lag.** The gitlink only updates in dotfiles when
  explicitly bumped, so dotfiles will often show the submodule as
  "modified (new commits)" between bumps. Mitigated by design: bump
  lazily/as-needed rather than after every sessions.kb-side commit —
  that's the whole point of choosing this over the plain-clone
  approach.

## Rollback

If the new repo is the wrong shape, the source of truth is dotfiles'
history until Step 4 lands. Before Step 4: delete/force-push the
GitHub repo and re-extract. After Step 4: `git revert` the dotfiles
commit(s) and `git checkout HEAD -- .claude/sessions.kb`; then
`git submodule deinit -f .claude/sessions.kb` to undo the wiring.

## Out of scope

- Tooling to enumerate entries across hosts.
- Sync to a future team-sessions repo.
