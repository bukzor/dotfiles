#!/usr/bin/env py.test
from __future__ import annotations

import pytest
from bukzor import ansi

from . import io


class DescribeBanner:
    def its_pretty(self, capfd: pytest.CaptureFixture[str]) -> None:
        io.banner("one:", 1)

        result = capfd.readouterr()
        assert result.out == ""
        assert (
            result.err == "\x1b[92;1m ======== one: 1 ======== \x1b[m\n"
        )  # ]]  treesitter-python bug


class DescribeXtrace:
    def it_prints(self, capfd: pytest.CaptureFixture[str]) -> None:
        io.xtrace(("ls", "1 2", 3, "4"))

        result = capfd.readouterr()
        assert result.out == ""
        assert result.err == f"+ {ansi.TEAL}${ansi.RESET} ls '1 2' 3 4\n"


class DescribeQuiet:
    def it_suppresses_xtrace(self, capfd: pytest.CaptureFixture[str]) -> None:
        with io.quiet():
            io.xtrace(("ls", "1 2", 3, "4"))

        result = capfd.readouterr()
        assert result.out == ""
        assert result.err == ""


class DescribeUniq:
    def it_suppresses_dups(self, capfd: pytest.CaptureFixture[str]) -> None:
        with io.uniq():
            io.info("1")
            io.debug("2")
            io.info("1")
            io.debug("3")
            io.info("2")
            io.info("4")
            io.info("3")

        result = capfd.readouterr()
        assert result.out == ""
        assert result.err == "1\n2\n3\n4\n"
