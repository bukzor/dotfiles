from __future__ import annotations

from pathlib import Path
from random import Random
from typing import TYPE_CHECKING

from lib import sh
from lib.constants import NOW
from lib.functions import one

if TYPE_CHECKING:
    import contextlib

Slice = int
Slices = tuple[int, ...]


def edit(slice: Slice) -> None:
    slice_path = one(Path().glob(f"slice-{slice}*/"))
    with (slice_path / "edit-me.tf").open("w") as f:
        f.write(
            f"""\
resource "null_resource" "edit-me" {{
  triggers = {{
    now = "{NOW}"
  }}
}}
"""
        )
    assert isinstance(f.name, str), f.name
    sh.run(("git", "add", f.name))


def random(seed: object = None) -> Slices:
    random = Random(seed)
    slice_count = random.randint(1, 3)
    slices = random.sample(range(3), slice_count)
    return tuple(sorted(slices))


def path(slice: Slice) -> Path:
    return one(Path().glob(f"slice-{slice}*/"))


def chdir(slice: Slice) -> contextlib.chdir[Path]:
    import contextlib

    return contextlib.chdir(path(slice))


def is_locked(slice: Slice) -> bool:
    with chdir(slice):
        return sh.success(("terraform", "plan", "--lock=true"))


def assert_locked(slices: Slices) -> None:
    for slice in range(3):
        locked = is_locked(slice)
        expected = slice in slices

        try:
            assert locked == expected, (locked, slice, slices)
        except AssertionError:
            # FIXME: actually do locking in our GHA "Obtain Lock" job
            assert locked == False, locked
