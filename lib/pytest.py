# tools for dealing with pytest
# please be responsible; wear eye protection
from __future__ import annotations

import functools
from contextlib import AbstractContextManager as ContextManager

import pytest
import typing_extensions
from typing_extensions import Callable
from typing_extensions import ParamSpec
from typing_extensions import TypeVar

T = TypeVar("T")

Generator = typing_extensions.Generator[T, None, None]  # shim python3.13
Params = ParamSpec("Params")
Return = TypeVar("Return")


def context_to_fixture(
    context: Callable[Params, ContextManager[Return]]
) -> Callable[Params, Generator[Return]]:
    @pytest.fixture
    @functools.wraps(context)
    def fixture(
        *args: Params.args, **kwargs: Params.kwargs
    ) -> Generator[Return]:
        with context(*args, **kwargs) as result:
            yield result

    return fixture
