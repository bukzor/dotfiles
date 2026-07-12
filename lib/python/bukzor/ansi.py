"""Constants and tools for dealing with ANSI terminal codes."""

from __future__ import annotations

import typing
from abc import abstractmethod
from enum import Enum
from typing import NamedTuple
from typing import Self

ESC = b"\033"
CSI = ESC + b"["  # ]  for python-treesitter syntax bug
RESET = CSI + b"m"
# GREEN = f"{CSI}92;1m"
# TEAL = f"{CSI}36;1m"

T = typing.TypeVar("T")
P = typing.ParamSpec("P")


### def attribute(f: Callable[P, T]) -> T:
###     from builtins import property
###
###     result = property(f)
###     return typing.cast(T, result)


### from enum.pyi >>>

# In 3.11 `EnumMeta` metaclass is renamed to `EnumType`, but old name also exists.
import enum

# import types
# import typing

EnumType = enum.EnumMeta


### if typing.TYPE_CHECKING:
###     from enum import _magic_enum_attr
### else:
###     _magic_enum_attr = property


### from enum.pyi <<<


class SGRColor(int, Enum):
    __slots__ = ()

    black = 0
    red = 1
    green = 2
    yellow = 3
    blue = 4
    purple = 5
    teal = 6
    white = 7


class Named:
    __slots__ = ()

    @property
    @abstractmethod
    def name(self) -> str:
        raise NotImplementedError


class Exported(Named):
    def __repr__(self):
        return f"ansi.{self.name.upper()}"


class SGRLayer(int, Exported, Enum):
    bg = 40
    fg = 30


BG = SGRLayer.bg
FG = SGRLayer.fg


class SGRBrightness(int, Exported, Enum):
    dark = 0
    bright = 60


DARK = SGRBrightness.dark
BRIGHT = SGRBrightness.bright


### class Enumerated(Named):
###     @property
###     def _name_(self) -> str:
###         cls = type(self)
###         return cls.__repr__(self)
###
###     @_name_.setter
###     def _name_(self, value: str) -> None:
###         assert value == self.name
###
###     @property
###     def _value_(self) -> Self:
###         return self


class Enumerated(Named):
    __slots__ = ()

    def __new__(cls, *args: object, **kwargs: object):
        self = super().__new__(cls, *args, **kwargs)
        del self.__dict__
        return self

    @property
    def _value_(self) -> Self:
        return self

    ### @_value_.setter
    ### def _value_(self, value: Self) -> None:
    ###     assert value == self._value_

    @property
    def _name_(self) -> str:
        return self.name

    @_name_.setter
    def _name_(self, value: str) -> None:
        assert value == self._name_

    @property
    def __objclass__(self) -> type[Self]:
        return type(self)

    @__objclass__.setter
    def __objclass__(self, value: type[Self]) -> None:
        assert value is self.__objclass__

    @property
    def _sort_order_(self) -> int:
        return 0

    @_sort_order_.setter
    def _sort_order_(self, value: int) -> None:
        del value

    ### def __setattr__(self, key: object, value: object) -> None:
    ###     raise Exception(f"no wannee __setattr__! ({key} = {value})")

    def __setitem__(self, key: object, value: object) -> None:
        del key, value
        raise Exception("no wannee __setitem__!")


class _ANSIColor(NamedTuple):
    color: SGRColor
    layer: SGRLayer = BG
    brightness: SGRBrightness = DARK

    @property
    def fg(self) -> Self:
        return self._replace(layer=FG)

    @property
    def bg(self) -> Self:
        return self._replace(layer=BG)

    @property
    def bright(self) -> Self:
        return self._replace(brightness=BRIGHT)

    @property
    def dark(self) -> Self:
        return self._replace(brightness=DARK)

    def __repr__(self) -> str:
        return f"{self.color._name_.upper()}.{self.layer._name_}.{self.brightness._name_}"

    @property
    def sgr(self) -> int:
        return int(self.color) + int(self.layer) + int(self.brightness)

    @property
    def ansi(self) -> bytes:
        return CSI + str(self.sgr).encode("US-ASCII") + b"m"


class ANSIColor(Enumerated, _ANSIColor):

    @property
    def name(self) -> str:
        return self.color.name


###import pudb
###
###pudb.set_trace()
###


class Color(Enum):
    __slots__ = ()

    # class Color(enum.Enum):
    black = 0
    red = SGRColor.red
    green = SGRColor.green
    yellow = SGRColor.yellow
    blue = SGRColor.blue
    purple = SGRColor.purple
    teal = SGRColor.teal
    white = SGRColor.white


BLACK = Color.black
RED = Color.red
GREEN = Color.green
YELLOW = Color.yellow
BLUE = Color.blue
PURPLE = Color.purple
TEAL = Color.teal
WHITE = Color.white


# a couple aliases for the ambiguous colors
MAGENTA = PINK = PURPLE
CYAN = TEAL
