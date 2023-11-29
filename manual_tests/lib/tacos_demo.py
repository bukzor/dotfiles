from __future__ import annotations

import datetime
from contextlib import contextmanager
from typing import Iterator
from typing import NamedTuple

from lib import sh
from lib.constants import NOW
from lib.constants import USER
from lib.functions import now
from manual_tests.lib import gh
from manual_tests.lib import slice

# TODO: centralize reused type aliases
Yields = Iterator
# FIXME: use a more specific type than str
Branch = str
URL = str


class TacosDemoPR(NamedTuple):
    branch: Branch
    url: URL
    since: datetime.datetime
    slices: slice.Slices


@contextmanager
def tacos_demo_pr(test_name: str, slices: slice.Slices) -> Yields[TacosDemoPR]:
    clone()
    tacos_demo_pr = new_pr(test_name, slices)
    yield tacos_demo_pr
    gh.close_pr(tacos_demo_pr[1])


def clone() -> None:
    sh.run(("rm", "-rf", "tacos-demo"))
    sh.run(("git", "clone", "git@github.com:getsentry/tacos-demo"))
    sh.cd("tacos-demo/terraform/env/prod/")


def commit_changes_to(
    slices: slice.Slices, test_name: str, postfix: str = ""
) -> Branch:
    branch = f"test/{USER}/{test_name}/{NOW.isoformat().replace(':', '_')}"

    sh.run(("git", "checkout", "-b", branch))

    for s in slices:
        slice.edit(s)
    if postfix:
        postfix = " - " + postfix

    sh.run(("git", "commit", "-m", f"test: {test_name} ({NOW}){postfix}"))
    sh.run(("git", "push", "origin", f"{branch}:{branch}"))

    return branch


def new_pr(test_name: str, slices: slice.Slices) -> TacosDemoPR:
    # NB: setting an upstream tracking branch makes `gh pr` stop working well

    since = now()
    branch = commit_changes_to(slices, test_name)

    pr_url = gh.open_pr(branch)

    sh.banner("PR opened:", pr_url)

    return TacosDemoPR(branch, pr_url, since, slices)
