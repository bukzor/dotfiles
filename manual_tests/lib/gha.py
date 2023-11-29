from __future__ import annotations

from datetime import datetime
from typing import cast

from lib import sh
from lib import wait

Check = str


def get_checks() -> list[object]:
    """get the most recent run of the named check"""
    result = sh.json(
        (
            "gh",
            "pr",
            "status",
            "--json",
            "statusCheckRollup",
            "--jq",
            # TODO: where are these fields documented??
            ".currentBranch.statusCheckRollup",
        )
    )
    assert isinstance(result, list), result
    return result


def assert_ran(check: Check, since: datetime) -> None:
    """success if a specified github-actions job ran"""
    c = get_check(check)
    completed_at = c["completedAt"]
    assert isinstance(completed_at, str), completed_at

    completed_at = datetime.fromisoformat(completed_at)
    assert completed_at > since, (completed_at, since)


def get_check(check: Check) -> dict[str, object]:
    checks = get_checks()
    for c in checks:
        assert isinstance(c, dict), (type(c), c)

        assert isinstance(c["name"], str), c
        name: str = c["name"]
        if name == check:
            return cast(dict[str, object], c)
    else:
        raise AssertionError(f"No such check found: {check}")


def assert_success(check: Check) -> None:
    # success if a specified github-actions job ran
    _check = get_check(check)
    assert _check["conclusion"] == "SUCCESS", _check


def assert_eventual_success(check: Check, since: datetime) -> None:
    sh.banner(f"waiting for {check}...")
    wait.for_(lambda: assert_ran(check, since))
    sh.banner(f"{check} ran")
    assert_success(check)
    sh.banner(f"{check} succeeded")
