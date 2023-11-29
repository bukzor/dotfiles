from __future__ import annotations

from lib.pytest import context_to_fixture
from manual_tests.lib import tacos_demo

reveal_type(context_to_fixture)

tacos_demo_pr = context_to_fixture(tacos_demo.tacos_demo_pr)
