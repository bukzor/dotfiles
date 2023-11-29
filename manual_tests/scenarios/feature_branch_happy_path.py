#!/usr/bin/env py.test
from __future__ import annotations

from pytest import fixture

from manual_tests.lib import gha
from manual_tests.lib import slice
from manual_tests.lib import tacos_demo


@fixture
def test_name() -> str:
    return __name__


@fixture
def slices() -> slice.Slices:
    return slice.random()


def test(tacos_demo_pr: tacos_demo.TacosDemoPR) -> None:
    gha.assert_eventual_success("terraform_lock", tacos_demo_pr.since)
    slice.assert_locked(tacos_demo_pr.slices)

    # TODO: the rest
