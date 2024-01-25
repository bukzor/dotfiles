"""Constants and tools for dealing with ANSI terminal codes."""

from __future__ import annotations

CSI = "\033["
RESET = f"{CSI}m"
GREEN = f"{CSI}92;1m"
TEAL = f"{CSI}36;1m"
