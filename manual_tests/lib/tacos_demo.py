#!/sourceme/bash
from lib.sh import run, cd
from lib.constants import USER, NOW
from manual_tests.lib import slice

# FIXME: use a more specific type than str for URL
URL = str


def clone() -> None:
    run(("rm", "-rf", "tacos-demo"))
    run(("git", "clone", "git@github.com:getsentry/tacos-demo"))
    cd("tacos-demo/terraform/env/prod/")


# returns: the URL of the new PR
def new_pr(test_name: str) -> URL:
    branch = f"{USER}/test/{test_name}/{NOW.isoformat().replace(':', '_')}"

    # NB: setting an upstream tracking branch makes `gh pr` stop working well
    run(("git", "checkout", "-b", branch))

    # edit one or more slices
    slice.edit_random()

    ### git commit -am "test: $test_name ($NOW)"
    ### git push origin "$branch:$branch"

    ### pr_url="$(gh::open-pr "$branch")"
    ### banner PR opened: "$pr_url"

    ### # this callback is defined in test-environ.sh
    ### # shellcheck disable=SC2317 # command appears unreachable
    ### onexit() {
    ###   gh::close-pr "$pr_url"
    ### }

    ### echo "$pr_url"
    # TODO: anything
    del test_name
    return URL()
