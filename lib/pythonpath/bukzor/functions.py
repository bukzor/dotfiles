from __future__ import annotations

import datetime
from typing import Iterable, TypeVar

T = TypeVar("T")


class MoreThanOneError(AssertionError):
    pass


class LessThanOneError(AssertionError):
    pass


def one(xs: Iterable[T]) -> T:
    __tracebackhide__ = True

    tmp = tuple(xs)
    count = len(tmp)
    if count == 1:
        return tmp[0]
    elif count < 1:
        raise LessThanOneError(f"Expected one result, got zero: {tmp}")
    else:  # count > 1:
        raise MoreThanOneError(f"Expected one result, got {count}: {tmp}")
