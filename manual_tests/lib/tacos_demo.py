import pytest

from lib import sh
from lib.constants import USER, NOW
from manual_tests.lib import slice
from manual_tests.lib import gh

# FIXME: use a more specific type than str for URL
URL = str


@pytest.fixture
def tacos_demo_pr(test_name):
    clone()
    pr_url = new_pr(test_name)
    yield pr_url
    gh.close_pr(pr_url)


def clone() -> None:
    sh.run(("rm", "-rf", "tacos-demo"))
    sh.run(("git", "clone", "git@github.com:getsentry/tacos-demo"))
    sh.cd("tacos-demo/terraform/env/prod/")


# returns: the URL of the new PR
def new_pr(test_name: str) -> URL:
    branch = f"{USER}/test/{test_name}/{NOW.isoformat().replace(':', '_')}"

    # NB: setting an upstream tracking branch makes `gh pr` stop working well
    sh.run(("git", "checkout", "-b", branch))

    # edit one or more slices
    slice.edit_random()

    sh.run(("git", "commit", "-m", f"test: {test_name} ({NOW})"))
    sh.run(("git", "push", "origin", f"{branch}:{branch}"))

    pr_url = gh.open_pr(branch)

    sh.banner("PR opened:", pr_url)

    ### # this callback is defined in test-environ.sh
    ### # shellcheck disable=SC2317 # command appears unreachable
    ### onexit() {
    ###   gh::close-pr "$pr_url"
    ### }

    ### echo "$pr_url"
    # TODO: anything
    del test_name
    return URL()
