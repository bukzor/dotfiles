from __future__ import annotations

from pytest import fixture
from typing_extensions import Generator

from manual_tests.lib import slice
from manual_tests.lib import tacos_demo


@fixture
def tacos_demo_pr(
    test_name: str, slices: slice.Slices
) -> Generator[tacos_demo.TacosDemoPR, None, None]:
    with tacos_demo.tacos_demo_pr(test_name, slices) as result:
        yield result
