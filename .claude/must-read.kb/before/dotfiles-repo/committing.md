# Before committing to the dotfiles repo

The dotfiles repo is the git repo rooted at `~`: everything under it
(`~/.claude/`, `~/bin/`, `~/.vimrc.d/`, ...) unless another repo claims the
path. This fires both on the urge to commit there mid-session and at session
end, which is when those commits are made.

> [!@bukzor] 2026-11-22: commits to dotfiles `main` are held till session end;
> before that, each iteration's commit is pure churn.

> [!@bukzor] 2026-11-24: "`main` is the working branch in `~` ... that
> working copy is cutting-edge, and it's dotfiles--main that's obsolete".
> Commit in `~`. (Supersedes 2026-11-22's "work on `main` happens in
> `dotfiles--main`", made on penguin while its `~` was svelte-crostini.)

> [!@bukzor] 2026-11-22: edits made live under `~` land on dotfiles `main` at
> session end, without overwriting anything `main` gained in the meantime.
