from random import Random
from pathlib import Path

from lib import sh
from lib.functions import one
from lib.constants import NOW

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
    sh.run(("git", "add", f.name))


def random(seed: object = None) -> Slices:
    random = Random(seed)
    slice_count = random.randint(1, 3)
    slices = random.sample(range(3), slice_count)
    return tuple(sorted(slices))


def path(slice: Slice) -> Path:
    return one(Path().glob(f"slice-{slice}*/"))


def chdir(slice: Slice):
    import contextlib

    return contextlib.chdir(path(slice))


def locked(slice: Slice) -> bool:
    with chdir(slice):
        return sh.success(("terraform", "plan", "--lock=true"))
