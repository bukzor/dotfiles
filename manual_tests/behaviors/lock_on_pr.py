# source "$REPO_TOP/manual-tests/lib/test-environ.sh"
from manual_tests.lib import tacos_demo
import datetime

now = datetime.datetime.now

TEST_NAME = __name__


def test():
    tacos_demo.clone()

    # since = now()
    tacos_demo.new_pr(TEST_NAME)

    ###gha::assert-eventual-success terraform_lock "$since"

    ###for slice in 1 2 3; do
    ###  if array::in "$slice" "${slices[@]}"; then
    ###    # relevant slice is locked
    ###    slice::assert-locked "$slice"
    ###  else
    ###    # irrelevant slice is not locked
    ###    slice::assert-not-locked "$slice"
    ###  fi
    ###done

    ###banner PASS
    assert False
