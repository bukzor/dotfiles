import subprocess

Command = tuple[str, ...]

PS4 = "+ \033[36;1m$\033[m"


def xtrace(cmd: Command) -> None:
    print(PS4, quote(cmd))


def cd(dirname: str) -> None:
    from os import chdir

    xtrace(("cd", dirname))
    chdir(dirname)


def quote(cmd: Command) -> str:
    import shlex

    return " ".join(shlex.quote(arg) for arg in cmd)


def run(cmd: Command) -> None:
    xtrace(cmd)
    subprocess.run(cmd, check=True)
