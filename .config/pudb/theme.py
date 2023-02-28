from __future__ import annotations


# References:
#   * https://github.com/inducer/pudb/blob/main/examples/theme.py
#   * https://github.com/inducer/pudb/blob/main/pudb/theme.py#L61-L78
###

# ------------------------------------------------------------------------------
# Reference for some palette items:
#
#  "namespace" : "import", "from", "using"
#  "operator"  : "+", "-", "=" etc.
#                NOTE: Does not include ".", which is assigned the type "source"
#  "argument"  : Function arguments
#  "builtin"   : "range", "dict", "set", "list", etc.
#  "pseudo"    : "self", "cls"
#  "dunder"    : Class method names of the form __<name>__ within
#               a class definition
#  "magic"     : Subset of "dunder", methods that the python language assigns
#               special meaning to. ("__str__", "__init__", etc.)
#  "exception" : Exception names
#  "keyword"   : All keywords except those specifically assigned to "keyword2"
#                ("from", "and", "break", "is", "try", "True", "None", etc.)
#  "keyword2"  : "class", "def", "exec", "lambda", "print"
# ------------------------------------------------------------------------------

# Supported 16 color values:
#   'h0' (color number 0) through 'h15' (color number 15)
#    or
#   'default' (use the terminal's default foreground),
#   'black', 'dark red', 'dark green', 'brown', 'dark blue',
#   'dark magenta', 'dark cyan', 'light gray', 'dark gray',
#   'light red', 'light green', 'yellow', 'light blue',
#   'light magenta', 'light cyan', 'white'
#
# Supported 256 color values:
#   'h0' (color number 0) through 'h255' (color number 255)
#
# 256 color chart: http://en.wikipedia.org/wiki/File:Xterm_color_chart.png
#
# "setting_name": (foreground_color, background_color),

# See pudb/theme.py
# (https://github.com/inducer/pudb/blob/main/pudb/theme.py) to see what keys
# there are.

# Note, be sure to test your theme in both curses and raw mode (see the bottom
# of the preferences window). Curses mode will be used with screen or tmux.
import typing as t

SyntaxGroup = str
SyntaxColor = t.Union[
    t.Tuple[str],  # foreground
    t.Tuple[str, str],  # foreground, background
]
SyntaxEntry = t.Union[
    SyntaxGroup,  # link
    SyntaxColor,
]

Palette = t.Dict[SyntaxGroup, SyntaxEntry]


try:
    add_setting = add_setting  # type:ignore
except NameError:

    def add_setting(color: str, setting: str) -> str:
        return f"{color}, {setting}"


try:
    palette = palette  # type:ignore
except NameError:
    palette: Palette = {}
try:
    link = link  # type:ignore
except NameError:

    def link(child: str, parent: str) -> None:
        ...


bg = "default"
fg = "default"
black = "h0"
dark_red = "h1"
dark_green = "h2"
brown = "h3"
dark_blue = "h4"
dark_magenta = "h5"
dark_cyan = "h6"
light_gray = "h7"
dark_gray = "h8"
light_red = "h9"
light_green = "h10"
yellow = "h11"
light_blue = "h12"
light_magenta = "h13"
light_cyan = "h14"
white = "h15"

bold = "bold"

# {{{ classic theme

palette_dict = {}
# }}}

fg0 = fg
fg1 = white
fg2 = light_gray

bg0 = bg
bg1 = black
bg2 = dark_gray
bg3 = fg2
bg4 = fg1

fg3 = bg2
fg4 = bg1


def highlight(fg) -> SyntaxColor:
    return (add_setting(fg, "bold"), bg2)


palette.update(
    {
        # {{{ base styles
        "background": (fg1, bg1),
        "selectable": (light_magenta,),
        "selectable": highlight(brown),
        "focused selectable": highlight(yellow),
        # selectable: "input": (add_setting(brown, bold), bg2),
        "highlighted": (light_red, light_blue),  # todo
        "hotkey": (add_setting(fg0, "underline"), bg1),
        "highlighted": (fg4, white),
        # }}}
        # {{{ general ui
        "label": (light_cyan, bg1),
        "header": (add_setting(fg0, bold), bg1),
        "dialog title": "header",
        "group head": "header",
        # input
        "input": highlight(brown),
        "focused input": "focused selectable",
        "button": "input",
        "focused button": "focused input",
        "value": (light_magenta,),  # "input",
        "fixed value": "label",
        # misc
        "warning": (fg4, brown),
        "header warning": "warning",
        "search box": "focused input",
        "search not found": "warning",
        # }}}
        # {{{ source view
        "source": (fg0, bg0),
        "focused source": highlight(fg0),
        "highlighted source": "highlighted",
        # current source
        "current source": (dark_cyan,),
        "focused current source": highlight(light_cyan),
        "current highlighted source": "current source",
        # breakpoint
        "breakpoint source": (yellow, dark_red),
        "breakpoint focused source": (add_setting(yellow, bold), light_red),
        "current breakpoint source": (dark_red, brown),
        "current breakpoint focused source": (add_setting(dark_red, bold), yellow),
        # gutter
        "line number": (fg4,),
        "breakpoint marker": (add_setting(dark_red, bold),),
        "current line marker": (fg1, bg0),
        # }}}
        # {{{ sidebar
        "sidebar one": "sidebar active",
        "sidebar two": "sidebar neutral",
        "sidebar three": "sidebar inactive",
        # focused
        "focused sidebar one": "focused sidebar active",
        "focused sidebar two": "focused sidebar neutral",
        "focused sidebar three": "focused sidebar inactive",
        # defaults
        "sidebar": "sidebar neutral",
        "focused sidebar": "focused sidebar neutral",
        # semantic
        "sidebar active": "builtin",
        "focused sidebar active": "focused builtin",
        "sidebar neutral": "source",
        "focused sidebar neutral": "focused source",
        "sidebar inactive": "current source",
        "focused sidebar inactive": "focused current source",
        # }}}
        # {{{ variables view
        "variables": "source",
        "variable separator": "background",
        # var label/value
        "var value": "sidebar",
        "var label": "sidebar inactive",
        "focused var value": "focused sidebar",
        "focused var label": "focused sidebar inactive",
        # highlighted
        "highlighted var label": "highlighted",
        "highlighted var value": "highlighted",
        "focused highlighted var label": "focused var label",
        "focused highlighted var value": "focused var value",
        # return
        "return label": "sidebar active",
        "return value": "var value",
        "focused return label": "focused sidebar active",
        "focused return value": "focused var value",
        # }}}
        # {{{ stack
        "stack": "source",
        # frame
        "frame name": "sidebar one",
        "frame class": "sidebar two",
        "frame location": "sidebar three",
        # focused frame
        "focused frame name": "focused sidebar one",
        "focused frame class": "focused sidebar two",
        "focused frame location": "focused sidebar three",
        # current frame
        "current frame name": "frame name",
        "current frame class": "frame class",
        "current frame location": "frame location",
        # focused current frame
        "focused current frame name": "focused frame name",
        "focused current frame class": "focused frame class",
        "focused current frame location": "focused frame location",
        # }}}
        # {{{ breakpoints view
        "breakpoint": "sidebar two",
        "disabled breakpoint": "sidebar three",
        "current breakpoint": "sidebar one",
        "disabled current breakpoint": "disabled breakpoint",
        # focused
        "focused breakpoint": "focused sidebar two",
        "focused current breakpoint": "focused sidebar one",
        "focused disabled breakpoint": "focused sidebar three",
        "focused disabled current breakpoint": "focused disabled breakpoint",
        # }}}
        # {{{ shell
        "command line edit": "source",
        "command line output": "source",
        "command line prompt": "source",
        "command line input": "source",
        "command line error": "warning",
        "focused command line output": "focused source",
        "focused command line input": "focused source",
        "focused command line error": "focused source",
        "command line clear button": "button",
        "command line focused button": "focused button",
        # }}}
        # {{{ Code syntax
        "comment": (fg2,),
        "keyword": (light_red,),
        "literal": (light_magenta,),
        "name": "source",
        "operator": (light_red,),
        "punctuation": "source",
        "argument": "name",
        "builtin": (brown,),
        "focused builtin": highlight(yellow),
        "exception": (light_cyan,),
        "function": (light_cyan,),
        "pseudo": (light_blue,),
        "class": (light_cyan,),
        "dunder": "function",
        "magic": "dunder",
        "namespace": (light_blue,),
        "keyword2": "keyword",
        "string": (light_green,),
        "doublestring": "string",
        "singlestring": "string",
        "docstring": "string",
        "backtick": "string",
        # }}}
    }
)

from pudb.theme import INHERITANCE_MAP

INHERITANCE_MAP: dict[SyntaxGroup, SyntaxGroup]

all_syntax_items = sorted(
    set(INHERITANCE_MAP)
    | set(INHERITANCE_MAP.values())
    | set(palette)
    | set(value for value in palette.values() if isinstance(value, SyntaxGroup)),
)

with open("palette.py", "w") as f:

    for syntax_item in all_syntax_items:
        if syntax_item not in palette:
            f.write(
                f"#  NOT SET: {syntax_item} {INHERITANCE_MAP.get(syntax_item, '(root item)')}\n"
            )

        elif isinstance(syntax_value := palette[syntax_item], SyntaxGroup):
            if syntax_value != INHERITANCE_MAP.get(syntax_item):
                f.write(f"link({syntax_item!r}, {syntax_value!r})\n")

                link(syntax_item, syntax_value)
                INHERITANCE_MAP.setdefault(syntax_value, "source")
            del palette[syntax_item]

    import json

    f.write(f"palette.update({json.dumps(palette, sort_keys=True, indent=2)})\n")
