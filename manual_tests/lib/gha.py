from lib import sh
from lib import wait
from datetime import datetime

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


def assert_ran(check: Check, since: datetime):
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
        if c["name"] == check:
            assert isinstance(c, dict), (type(c), c)
            return c
    else:
        raise AssertionError(f"No such check found: {check}")


def assert_success(check: Check):
    # success if a specified github-actions job ran
    _check = get_check(check)
    assert _check["conclusion"] == "SUCCESS", _check


def assert_eventual_success(check: Check, since: datetime):
    sh.banner(f"waiting for {check}...")
    wait.for_(lambda: assert_ran(check, since))
    sh.banner(f"{check} ran")
    assert_success(check)
    sh.banner(f"{check} succeeded")
