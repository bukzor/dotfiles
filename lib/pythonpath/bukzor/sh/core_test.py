#!/usr/bin/env py.test
from __future__ import annotations

from typing import cast

import pytest

from . import sh
from .core import _popen  # pyright:ignore[reportPrivateUsage]
from .core import _wait  # pyright:ignore[reportPrivateUsage]


class DescribeLines:
    def it_skips_empty_lines(self) -> None:
        assert tuple(sh.lines(("echo", "1\n\n2"))) == ("1", "2")

    def it_skips_comments(self) -> None:
        text = """\
3
 # I have something important to say!
4
"""

        assert tuple(sh.lines(("echo", text))) == ("3", "4")


class DescribePrivatePopen:
    def it_can_handle_posix_colon(self) -> None:
        proc = _popen((":", "ohai"))
        # type system thinks these can't be none, but they are /shrug
        out, err = proc.communicate()
        assert cast(object, out) is None
        assert cast(object, err) is None
        assert proc.returncode == 0


class DescribePrivateWait:
    def it_can_timeout(self) -> None:
        proc = _popen(("sleep", 9999))
        with pytest.raises(sh.TimeoutExpired) as raised:
            _wait(proc, timeout=0.01)

        error = raised.value
        assert error.cmd == ("sleep", "9999")

    def it_can_raise_error(self) -> None:
        proc = _popen(("sh", "-c", "exit 33"))
        with pytest.raises(sh.CalledProcessError) as raised:
            _wait(proc)

        error = raised.value
        assert error.returncode == 33

    def it_can_ignore_error(self) -> None:
        proc = _popen(("sh", "-c", "exit 33"))
        result = _wait(proc, check=False)
        assert result.returncode == 33
