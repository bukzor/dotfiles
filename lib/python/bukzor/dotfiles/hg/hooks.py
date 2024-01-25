"""A simple hg hook to keep an intree hg-git in sync.

Installation: in .hg/hgrc:

    [hooks]
    update = python:lib.hg.update

"""
from __future__ import annotations

from bukzor.sh import sh
from mercurial.context import changectx
# from hgext_hggit.git_handler import GitHandler
from mercurial.localrepo import localrepository
from mercurial.ui import ui

# pyright: basic
# mypy: ignore-errors


def hg_git_sync(repo: localrepository, ctx: changectx) -> bool:
    git = repo.githandler  # type: ignore
    git.export_commits()  # equivalent to hg-push, but without network access
    sha = git.map_git_get(ctx.hex())
    if not sha:
        return False

    sh.run(("git", "checkout", "-q", "--detach"))
    sh.run(("git", "reset", "-q", "--mixed", sha))

    try:
        bookmark = ctx.bookmarks()[0]
    except IndexError:
        pass
    else:
        sh.run(("git", "checkout", "-q", sha, "-B", bookmark))

    s = repo.status()
    changed = s.added + s.modified + s.removed
    if changed:
        sh.run(("git", "add") + tuple(sorted(changed)))

    return True


def update(ui: ui, repo: localrepository, parent1: bytes, **kwargs: object) -> None:
    del ui, kwargs

    ctx: changectx = repo[repo.lookup(parent1)]

    hg_git_sync(repo, ctx)


def precommit(ui: ui, repo: localrepository, parent1: bytes, **kwargs: object) -> bool:
    del ui, kwargs

    ctx: changectx = repo[repo.lookup(parent1)]

    if not hg_git_sync(repo, ctx):
        return True

    return not sh.success(("pre-commit", "run"))
