from __future__ import annotations

###import rlcompleter
from pathlib import Path


def mkdirp(path: Path):
    from os import makedirs

    makedirs(path, exist_ok=True)


def get_readline() -> object:
    import os
    import sys

    # stupidity imported from site.py :(
    if not sys.flags.ignore_environment:
        PYTHON_BASIC_REPL = os.getenv("PYTHON_BASIC_REPL")
    else:
        PYTHON_BASIC_REPL = False

    if PYTHON_BASIC_REPL:
        CAN_USE_PYREPL = False
    else:
        try:
            from _pyrepl.main import CAN_USE_PYREPL
        except ImportError:
            CAN_USE_PYREPL = False

    if CAN_USE_PYREPL:
        import _pyrepl.readline

        return _pyrepl.readline
    else:
        import readline

        return readline


def get_readline_backend(readline: object) -> str:
    result = getattr(readline, "backend", None)  # added python3.13
    if result is not None:
        return result

    readline_doc = getattr(readline, "__doc__", "")
    if readline_doc.endswith(" libedit readline."):
        return "editline"
    elif " pyrepl." in readline_doc:
        return "pyrepl"
    elif readline_doc.endswith(" GNU readline."):
        return "readline"
    else:
        raise AssertionError(readline_doc)


def init_readline(readline: object):
    backend = get_readline_backend(readline)
    if backend == "pyrepl":
        return
    elif backend == "editline":
        init_file = "~/.editrc"
    elif backend == "readline":
        init_file = "~/.inputrc"
    else:
        raise AssertionError(backend)

    init = Path(init_file).expanduser()
    if init.exists():
        print("Line-editor configured:", init_file)
        readline.read_init_file(init)


def set_readline_history(readline: object, history_file: str):
    # The guard is necessary to avoid doubling history size at
    # each interpreter exit when readline was already configured
    # through a PYTHONSTARTUP hook, see:
    # http://bugs.python.org/issue5845#msg198636
    if readline.get_current_history_length() != 0:
        return

    history = Path(history_file).expanduser()
    if history.exists():
        # print(f"Line-editor history < {history_file}")
        readline.read_history_file(history)

    def write_history():
        # print(f"Line-editor history > {history_file}")
        readline.write_history_file(history)

    import atexit

    atexit.register(write_history)


# Enable default readline configuration on interactive prompts.
def register_readline():
    readline = get_readline()

    # readline.set_completer(rlcompleter.Completer().complete)
    init_readline(readline)

    # If no history was loaded, default to .python_history.
    backend = get_readline_backend(readline)
    history_file = f"~/.python_history.{backend}"
    set_readline_history(readline, history_file)


def register_python_interactivehook():
    """Make this be the default interactive configuration."""
    import sys

    sys.__interactivehook__ = register_readline
