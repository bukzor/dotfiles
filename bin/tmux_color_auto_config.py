from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
from enum import auto
from typing import Self

TMUX_COLOR = [
    "black",
    "red",
    "green",
    "yellow",
    "blue",
    "magenta",
    "cyan",
    "white",
    "default",
    "inv",
]

_color_enum = [(color, i) for i, color in enumerate(TMUX_COLOR)]
ColorName = Enum("ColorName", _color_enum)
ColorMatch = Enum("ColorMatch", _color_enum + [("ANY", "*")])

# class ColorMatch(Color):
#     ANY = "*"


class SchemeName(Enum):
    DARK = "dark"
    LIGHT = "light"


class SchemeMatch(SchemeName):
    ANY = "*"


@dataclass(frozen=True)
class FontColor:
    """Represents a concrete color configuration."""

    scheme: SchemeName
    fg: Color
    bg: Color

    def __str__(self) -> str:
        """Format as tmux status-style string."""
        bright = ",bright" if self.scheme == SchemeName.DARK else ""
        return f"fg={self.fg.value}{bright},bg={self.bg.value}"


@dataclass(frozen=True)
class FontColorRule:
    """Represents a color rule that can include wildcards."""

    scheme: SchemeMatch = SchemeMatch.ANY
    fg: ColorMatch = ColorMatch.ANY
    bg: ColorMatch = ColorMatch.ANY
    allow: bool = True

    @classmethod
    def from_string(cls, rule: str) -> Self:
        """Parse a rule string like '+ scheme=dark,fg=yellow'."""
        rule = rule.strip()
        if not rule:
            return cls()

        # Parse allow/deny prefix
        allow = True
        if rule[0] in "+-":
            allow = rule[0] == "+"
            rule = rule[1:].strip()

        # Parse key-value pairs
        attrs: dict[str, SchemeMatch | ColorMatch] = {
            "scheme": SchemeMatch.ANY,
            "fg": ColorMatch.ANY,
            "bg": ColorMatch.ANY,
        }

        if rule:
            for pair in rule.split(","):
                if "=" not in pair:
                    continue
                key, value = pair.split("=", 1)
                key = key.strip()
                value = value.strip()

                if key == "scheme":
                    attrs[key] = SchemeMatch(value)
                elif key in ("fg", "bg"):
                    attrs[key] = ColorMatch(value)

        return cls(allow=allow, **attrs)

    def matches(self, color: Color) -> bool:
        """Check if this rule matches a concrete color configuration."""
        if self.scheme != SchemeMatch.ANY and color.scheme != self.scheme:
            return False
        if self.fg != ColorMatch.ANY and color.fg != self.fg:
            return False
        if self.bg != ColorMatch.ANY and color.bg != self.bg:
            return False
        return True

    def __str__(self) -> str:
        parts = []
        if self.scheme != SchemeMatch.ANY:
            parts.append(f"scheme={self.scheme.value}")
        if self.fg != ColorMatch.ANY:
            parts.append(f"fg={self.fg.value}")
        if self.bg != ColorMatch.ANY:
            parts.append(f"bg={self.bg.value}")

        prefix = "+" if self.allow else "-"
        return prefix + " " + ",".join(parts) if parts else prefix
