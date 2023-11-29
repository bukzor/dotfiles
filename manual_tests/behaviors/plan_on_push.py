#!/usr/bin/env py.test
from __future__ import annotations

from datetime import datetime

from lib.functions import now
from manual_tests.lib import gh
from manual_tests.lib import gha
from manual_tests.lib import slice
from manual_tests.lib import tacos_demo

TEST_NAME = __name__

Branch = int


def assert_gha_plan(since: datetime) -> None:
    gha.assert_eventual_success("terraform_plan", since)
    gh.assert_matching_comment("Execution result of", since)


def test() -> None:
    tacos_demo.clone()

    since = now()
    tacos_demo_pr = tacos_demo.new_pr(TEST_NAME, slice.random())
    try:  # TODO: use fixtures to do this cleanup
        assert_gha_plan(since)

        since = now()
        tacos_demo.commit_changes_to(
            slice.random(), TEST_NAME, postfix="more code"
        )
        assert_gha_plan(since)
    finally:
        gh.close_pr(tacos_demo_pr.branch)
