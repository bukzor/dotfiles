from __future__ import annotations

from datetime import datetime

from lib import sh
from lib import wait
from lib.functions import now
from manual_tests.lib import gha

# FIXME: use a more specific type than str
URL = str
Branch = str


def assert_matching_comment(comment: str, since: datetime) -> None:
    # Fetch the comments on the PR
    comments = sh.json(
        (
            "gh",
            "pr",
            "view",
            "--json",
            "comments",
            "--jq",
            ".comments.[] | {body, createdAt}",
        )
    )
    assert isinstance(comments, list), comments

    # Parse the comments and their creation times
    for c in comments:
        assert isinstance(c, dict), c

        assert isinstance(c["createdAt"], str), c
        created_at = datetime.fromisoformat(c["createdAt"])

        if created_at >= since:
            if comment in c["body"]:
                return
    else:
        raise AssertionError(f"No matching comment: {comment}")


def open_pr(branch: Branch) -> str:
    return sh.stdout(("gh", "pr", "create", "--fill-first", "--head", branch))


def close_pr(pr_url: URL) -> None:
    sh.banner("cleaning up:")
    since = now()

    if sh.success(("gh", "pr", "edit", "--add-label", ":taco::unlock")):
        sh.banner("waiting for unlock...")
        wait.for_(lambda: gha.assert_ran("terraform_unlock", since))
        sh.banner("unlocked.")

    sh.banner("deleting branch:")
    sh.run(
        (
            "gh",
            "pr",
            "close",
            "--comment",
            "test cleanup",
            "--delete-branch",
            pr_url,
        )
    )
