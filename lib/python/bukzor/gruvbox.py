"""A pythonic representation of the "gruvbox" color scheme.

Source: https://github.com/morhetz/gruvbox/blob/0401386/colors/gruvbox.vim
Source Last Modified: 12 Aug 2017
Source Author: morhetz <morhetz@gmail.com>
"""

from __future__ import annotations

from enum import Enum
from enum import Flag

# from typing import ClassVar
from typing import NamedTuple

from .color import RGB


class Unset(Enum):
    UNSET = None


UNSET = Unset.UNSET


class Contrast(Enum):
    # naming matches upstream source as much as possible

    C0_HARD = 51  # maximum contrast
    C0 = 50  # a bit less, default
    C0_SOFT = 49  # a bit less

    C1 = 40
    C2 = 30
    C3 = 20
    C4 = 10

    GRAY = 0  # minimum contrast (naming taken from upstream)


class Saturation(Enum):
    FADED = -1
    DEFAULT = 0
    BRIGHT = 1


FADED = Saturation.FADED
BRIGHT = Saturation.BRIGHT


class ColorName(Enum):
    pass


class Hue(ColorName):
    black = 0
    red = 1
    green = 2
    yellow = 3
    blue = 4
    purple = 5
    aqua = 6
    white = 7

    # orange exists in gruvbox but not ansi
    orange = 8


black = Hue.black
red = Hue.red
green = Hue.green
yellow = Hue.yellow
blue = Hue.blue
purple = Hue.purple
aqua = Hue.aqua
white = Hue.white
orange = Hue.orange


class TextLayer(Flag):
    BG = 1
    FG = 10


BG = TextLayer.BG
FG = TextLayer.FG


class GrayScale(NamedTuple):
    layer: TextLayer
    contrast: Contrast


bg0_h = GrayScale(BG, Contrast.C0_HARD)
bg0 = GrayScale(BG, Contrast.C0)
bg0_s = GrayScale(BG, Contrast.C0_SOFT)
bg1 = GrayScale(BG, Contrast.C1)
bg2 = GrayScale(BG, Contrast.C2)
bg3 = GrayScale(BG, Contrast.C3)
bg4 = GrayScale(BG, Contrast.C4)

gray = GrayScale(BG | FG, Contrast.GRAY)

fg4 = GrayScale(FG, Contrast.C4)
fg3 = GrayScale(FG, Contrast.C3)
fg2 = GrayScale(FG, Contrast.C2)
fg1 = GrayScale(FG, Contrast.C1)
fg0 = GrayScale(FG, Contrast.C0)


class Color(NamedTuple):
    saturation: Saturation
    hue: Hue


class Bright(Enum):
    red = Color(BRIGHT, red)


bright_red = Bright.red
print(bright_red.value.saturation)


# install a few aliases for the ambiguous colors
grey = gray
magenta = pink = purple
cyan = teal = aqua


class Dark(Enum):
    dark0 = 100
    dark0_hard = (dark0, HARD)
    dark0_soft = (dark0, SOFT)

    dark1 = 101
    dark2 = 102
    dark3 = 103
    dark4 = 104

    gray = gray.value


class Light(Enum):
    light0 = 100
    light0_hard = (light0, HARD)
    light0_soft = (light0, SOFT)

    light1 = 101
    light2 = 102
    light3 = 103
    light4 = 104

    gray = gray.value


assert Dark.gray == Hue.gray


fg_light = bg_dark = neutrals_dark = {
    (black, HARD): RGB(29, 32, 33),
    black: RGB(40, 40, 40),
    (black, SOFT): RGB(50, 48, 47),
    red: RGB(60, 56, 54),
    green: RGB(80, 73, 69),
    yellow: RGB(102, 92, 84),
    4: RGB(124, 111, 100),
    gray: RGB(146, 131, 116),
}

bg_light = fg_dark = neutrals_light = {
    (black, HARD): RGB(249, 245, 215),
    black: RGB(253, 244, 193),
    (black, SOFT): RGB(242, 229, 188),
    red: RGB(235, 219, 178),
    green: RGB(213, 196, 161),
    yellow: RGB(189, 174, 147),
    4: RGB(168, 153, 132),
    GRAY: RGB(146, 131, 116),
}


bright = {
    red: RGB(251, 73, 52),
    green: RGB(184, 187, 38),
    yellow: RGB(250, 189, 47),
    blue: RGB(131, 165, 152),
    purple: RGB(211, 134, 155),
    aqua: RGB(142, 192, 124),
    orange: RGB(254, 128, 25),
}

neutral = {
    red: RGB(204, 36, 29),
    green: RGB(152, 151, 26),
    yellow: RGB(215, 153, 33),
    blue: RGB(69, 133, 136),
    purple: RGB(177, 98, 134),
    aqua: RGB(104, 157, 106),
    orange: RGB(214, 93, 14),
}

faded = {
    red: RGB(157, 0, 6),
    green: RGB(121, 116, 14),
    yellow: RGB(181, 118, 20),
    blue: RGB(7, 102, 120),
    purple: RGB(143, 63, 113),
    aqua: RGB(66, 123, 88),
    orange: RGB(175, 58, 3),
}


class TerminalTheme(NamedTuple):
    flavor: ColorschemeFlavor

    cursor: RGB
    cursor_text_color: RGB

    url_color: RGB

    visual_bell_color: RGB
    bell_border_color: RGB

    active_border_color: RGB
    inactive_border_color: RGB

    foreground: RGB
    background: RGB
    selection_foreground: RGB
    selection_background: RGB

    active_tab_foreground: RGB
    active_tab_background: RGB
    inactive_tab_foreground: RGB
    inactive_tab_background: RGB

    # black  (bg3/bg4)
    color0: RGB
    color8: RGB

    # red
    color1: RGB
    color9: RGB

    #: green
    color2: RGB
    color10: RGB

    # yellow
    color3: RGB
    color11: RGB

    # blue
    color4: RGB
    color12: RGB

    # purple
    color5: RGB
    color13: RGB

    # aqua
    color6: RGB
    color14: RGB

    # white (fg4/fg3)
    color7: RGB
    color15: RGB
