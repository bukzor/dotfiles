from __future__ import annotations

from bukzor import json as JSON

from . import io
from .constant import US_ASCII
from .core import lines, stdout
from .types import Command, Generator


def json(cmd: Command) -> JSON.Value:
    """Parse the (singular) json on a subprocess' stdout.

    >>> json(("echo", '{"a": "b", "c": 3}'))
    {'a': 'b', 'c': 3}
    """
    text = stdout(cmd)
    if not text:
        return None

    import json

    result: JSON.Value = json.loads(text)
    if io.DEBUG >= 2:
        io.info("Got JSON:", json.dumps(result))
    return result


def jq(cmd: Command, *, encoding: str = US_ASCII) -> Generator[JSON.Value]:
    """Yield each object from newline-delimited json on a subprocess' stdout.

    >>> tuple(jq(("seq", 3)))
    (1, 2, 3)
    """
    import json

    for line in lines(cmd, encoding=encoding):
        try:
            result: JSON.Value = json.loads(line)
        except Exception as error:
            raise ValueError(f"bad JSON: {line!r}") from error
        else:
            if io.DEBUG >= 2:
                io.info("Got ndJSON:", json.dumps(result))
            yield result
