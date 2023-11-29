from __future__ import annotations

import datetime
from typing import Iterable
from typing import TypeVar

T = TypeVar("T")


def now() -> datetime.datetime:
    return datetime.datetime.now(datetime.UTC)


def one(xs: Iterable[T]) -> T:
    tmp = tuple(xs)
    assert len(tmp) == 1, tmp
    return tmp[0]
