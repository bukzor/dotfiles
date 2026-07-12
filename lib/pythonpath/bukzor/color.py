"""Color conversions

OKLab Reference: https://bottosson.github.io/posts/oklab/#converting-from-linear-srgb-to-oklab
"""

from __future__ import annotations

from typing import NamedTuple


class OKLab(NamedTuple):
    L: float
    a: float
    b: float


def rgb_to_oklab(rgb: RGB) -> OKLab:
    l = 0.4122214708 * rgb.r + 0.5363325363 * rgb.g + 0.0514459929 * rgb.b
    m = 0.2119034982 * rgb.r + 0.6806995451 * rgb.g + 0.1073969566 * rgb.b
    s = 0.0883024619 * rgb.r + 0.2817188376 * rgb.g + 0.6299787005 * rgb.b

    from math import cbrt

    l_ = cbrt(l)
    m_ = cbrt(m)
    s_ = cbrt(s)

    return OKLab(
        0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
        1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
        0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_,
    )


def oklch_to_oklab(lch: OKLCh) -> OKLab:
    from math import cos
    from math import sin

    return OKLab(lch.L, lch.C * cos(lch.h), lch.C * sin(lch.h))


class OKLCh(NamedTuple):
    L: float
    C: float
    h: float


def oklab_to_oklch(lab: OKLab) -> OKLCh:
    from math import atan2
    from math import sqrt

    return OKLCh(lab.L, sqrt(lab.a**2 + lab.b**2), atan2(lab.b, lab.a))


# sRGB, D65,
class RGB(NamedTuple):
    r: float
    g: float
    b: float


def oklab_to_rgb(lab: OKLab) -> RGB:
    l_ = lab.L + 0.3963377774 * lab.a + 0.2158037573 * lab.b
    m_ = lab.L - 0.1055613458 * lab.a - 0.0638541728 * lab.b
    s_ = lab.L - 0.0894841775 * lab.a - 1.2914855480 * lab.b

    l = l_**3
    m = m_**3
    s = s_**3

    return RGB(
        +4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
        -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
        -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s,
    )
