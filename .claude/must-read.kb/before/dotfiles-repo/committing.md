# Before committing to the dotfiles repo

The dotfiles repo is the git repo rooted at `~`: everything under it
(`~/.claude/`, `~/bin/`, `~/.vimrc.d/`, ...) unless another repo claims the
path. This fires both on the urge to commit there mid-session and at session
end, which is when those commits are made.

> [!@bukzor] 2026-11-22: commits to dotfiles `main` are held till session end;
> before that, each iteration's commit is pure churn.

> [!@bukzor] 2026-11-22: work on dotfiles `main` happens in
> `~/repo/github.com/bukzor/dotfiles--main` (a `gh repo clone`), not in `~`,
> whose local `main` is stale.

> [!DRAFT] agent-authored 2026-11-22, vetoable: edits made live under `~`
> during the session are carried into the clone at session end -- after a
> `pull --ff-only`, confirm each file's base matches `git -C ~ show HEAD:PATH`,
> copy it over, review the clone's diff, commit there, push.
