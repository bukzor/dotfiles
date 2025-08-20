#!/usr/bin/env pytest
from __future__ import annotations

import pytest

from . import ansi
from .ansi import BLACK

UNSET = object()


class DescribeAnsiColor:

    def it_has_black(self):
        assert BLACK == ansi.Color(
            ansi.SGRColor.black, ansi.SGRLayer.bg, ansi.DARK
        )
        assert BLACK.layer == ansi.SGRLayer.bg
        assert BLACK.layer.value == 40
        assert BLACK.brightness == ansi.SGRBrightness.dark
        assert BLACK.brightness.value == 0
        assert BLACK == BLACK.bg.dark

    def it_can_represent_bright_fg(self):
        assert BLACK.sgr == 40
        assert BLACK.bg.sgr == 40
        assert BLACK.fg.sgr == 30
        assert BLACK.fg.dark.sgr == 30
        assert BLACK.fg.bright.sgr == 90
        assert BLACK.fg.bright == BLACK.bright.fg

    def it_has_black_bright_or_dark(self):
        assert BLACK.dark.sgr == 40
        assert BLACK.dark.ansi == b"\033[40m"  # ]

        assert BLACK.bright.sgr == 100
        assert BLACK.bright.ansi == b"\033[100m"  # ]

    def it_has_a_nice_repr(self):
        assert repr(BLACK) == "<Color.black: BLACK.bg.dark>"
        assert repr(BLACK.fg.bright) == "<Color.black: BLACK.fg.bright>"

    def it_is_immutable(self):
        assert BLACK.__slots__ == ()

        for cls in type(BLACK).mro():
            print(cls.__name__, getattr(cls, "__slots__", "unset"))

        with pytest.raises(AttributeError):
            BLACK.x = "X"  # type: ignore
