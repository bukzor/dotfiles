from os import getenv

import contextlib
from subprocess import CompletedProcess

Command = tuple[str, ...]

DEBUG = bool(getenv("DEBUG", "1"))
PS4 = "+ \033[36;1m$\033[m"


def info(msg: tuple[str, ...]):
    from sys import stderr

    print(*msg, file=stderr, flush=True)


def banner(*msg: str):
    info(("\033[92;1m", "=" * 8) + msg + ("=" * 8, "\033[m"))


def xtrace(cmd: Command) -> None:
    if DEBUG:
        info((PS4, quote(cmd)))


def cd(dirname: str) -> None:
    from os import chdir

    xtrace(("cd", dirname))
    chdir(dirname)


def quote(cmd: Command) -> str:
    import shlex

    return " ".join(shlex.quote(arg) for arg in cmd)


def stdout(cmd: Command) -> str:
    return _run(cmd, encoding="US-ASCII", capture_output=True).stdout.rstrip("\n")


def json(cmd) -> object:
    import json

    result = stdout(cmd)
    if not result:
        raise ValueError(f"JSON can't decode empty-string: {result!r}")
    try:
        return json.loads(result)
    except Exception as error:
        raise error from ValueError(f"bad JSON: >>>\n{result}\n<<<")


def success(cmd: Command, returncode=0) -> bool:
    # any non-ascii bytes are ambiguous, here:
    result = _run(cmd, check=False)
    return result.returncode == returncode


def _run(cmd: Command, **run_kwargs) -> CompletedProcess[str]:
    xtrace(cmd)
    if cmd[0] == ":":
        return CompletedProcess(cmd, 0, "", "")

    run_kwargs.setdefault("check", True)
    # any non-ascii bytes are ambiguous, here:
    run_kwargs.setdefault("encoding", "US-ASCII")
    import subprocess

    return subprocess.run(cmd, **run_kwargs, text=True)


def run(cmd: Command) -> None:
    _run(cmd)


@contextlib.contextmanager
def quiet():
    global DEBUG
    orig, DEBUG = DEBUG, False
    yield orig
    DEBUG = orig
