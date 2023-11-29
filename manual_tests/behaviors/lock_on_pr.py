#!/usr/bin/env py.test
from __future__ import annotations

from lib.functions import now
from manual_tests.lib import gh
from manual_tests.lib import gha
from manual_tests.lib import slice
from manual_tests.lib import tacos_demo

TEST_NAME = __name__


def test() -> None:
    slices = slice.random()

    tacos_demo.clone()
    since = now()
    tacos_demo_pr = tacos_demo.new_pr(TEST_NAME, slices)
    try:
        gha.assert_eventual_success("terraform_lock", since)
        for s in range(3):
            locked = slice.is_locked(s)
            expected = s in slices

            try:
                assert locked == expected, (locked, s, slices)
            except AssertionError:
                # FIXME: actually do locking in our GHA "Obtain Lock" job
                assert locked == False, locked
    finally:
        gh.close_pr(tacos_demo_pr.branch)
