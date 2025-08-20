from __future__ import annotations

import readline
import rlcompleter
from code import InteractiveConsole
from pathlib import Path

from pudb.shell import SetPropagatingDict

SHELL_FIRST_TIME = {"banner": "Hit Ctrl-D to return to PuDB."}


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

def set_readline_completion(readline, locals, globals):
    ns = SetPropagatingDict([locals, globals], locals)

    readline.set_completer(rlcompleter.Completer(ns).complete)
    return ns


def get_pudb_history() -> str:
    from os.path import join

    from pudb.settings import get_save_config_path

    save_config_path = get_save_config_path()
    assert save_config_path is not None

    return join(save_config_path, "shell-history")


def run_classic_shell(
    globals: dict[str, object], locals: dict[str, object], message: str = ""
):
    banner = SHELL_FIRST_TIME.pop("banner", "")
    if message:
        banner = f"{message}\n{banner}"

    ns = set_readline_completion(readline, locals, globals)
    init_readline(readline)
    pudb_history = get_pudb_history()
    set_readline_history(readline, pudb_history)

    shell = InteractiveConsole(ns)
    shell.interact(banner)


# required hook-by-name
pudb_shell = run_classic_shell
