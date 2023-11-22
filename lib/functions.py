from typing import TypeVar, Iterable

T = TypeVar("T")


def one(xs: Iterable[T]) -> T:
    tmp = tuple(xs)
    assert len(tmp) == 1, tmp
    return tmp[0]
