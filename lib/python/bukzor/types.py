from __future__ import annotations

import typing
from pathlib import PosixPath
from pathlib import PurePosixPath

T = typing.TypeVar("T")
Generator = typing.Generator[T, None, None]  # py313/PEP696 shim
Environ = typing.MutableMapping[str, str]
Callback = typing.Callable[[], T]


class Path(PurePosixPath):
    @classmethod
    def cwd(cls, environ: Environ) -> typing.Self:
        return cls(environ["PWD"])


class OSPath(PosixPath, Path):
    @classmethod
    def cwd(cls, environ: object = None) -> typing.Self:
        del environ
        return super().cwd()
