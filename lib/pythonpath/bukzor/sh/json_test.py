#!/usr/bin/env py.test
from __future__ import annotations

import pytest

from . import json


class DescribeJq:
    def it_handles_blank_lines(self) -> None:
        result = tuple(json.jq(("echo", "1\n\n2")))
        assert result == (1, 2)

    def it_handles_commented_lines(self) -> None:
        result = tuple(json.jq(("echo", "1\n#2\n3")))
        assert result == (1, 3)

    def it_throws_on_error(self) -> None:
        with pytest.raises(ValueError) as raised:
            tuple(json.jq(("echo", "wut")))

        assert raised.value.args == ("bad JSON: 'wut'",)
