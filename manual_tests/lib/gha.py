from lib import sh
from datetime import datetime


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


def assert_ran(check_name: str, since: datetime):
    """success if a specified github-actions job ran"""
    checks = get_checks()

    for check in checks:
        assert isinstance(check, dict), (type(check), check)
        if check["name"] == check_name:
            completed_at = datetime.fromisoformat(check["completedAt"])
            assert completed_at > since, (completed_at, since)
            return
    else:
        raise AssertionError(f"No such check found: {check_name}")


### }

### gha::assert-success() {
###   # success if a specified github-actions job ran
###   check_name="$1"
###   check="$(gha::get-check "$check_name")"
###   conclusion="$(
###     jq <<< "$check" '.conclusion' --raw-output
###   )"
###   test "$conclusion" = "SUCCESS"
### }

### gha::assert-eventual-success() {
###   # success if a specified github-actions job ran
###   check_name="$1"
###   since="$2"
###
###   banner waiting for "$check_name"...
###   wait::for gha::assert-ran "$check_name" "$since"
###   banner "$check_name" ran
###   gha::assert-success "$check_name"
###   banner "$check_name" succeeded
### }
