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


### slice::random() {
###   { echo "$((RANDOM % 3))"
###     for slice in 0 1 2; do
###       if ((RANDOM % 100 <= 33)); then
###         echo $slice
###       fi
###     done
###   } | sort -u
### }


def random(seed: object) -> Slices:
    random = Random(seed)
    slice_count = random.randint(1, 3)
    slices = random.sample(range(3), slice_count)
    return tuple(sorted(slices))


def edit_random(seed: object = None) -> Slices:
    slices = random(seed)

    for slice in slices:
        edit(slice)

    return slices


### slice::assert-locked() {
###   : FIXME: perform a real assertion here
###   if true; then
###     return 0
###   else
###     (
###       slice_number="$1"
###       cd slice-"$slice_number"*/ || return 1
###       if ! terraform plan --lock=true; then
###         : ok
###       else
###         echo >&2 "AssertionError: slice $slice_number should be locked!"
###         return 1
###       fi
###     )
###   fi
### }

### slice::assert-not-locked() {
###   : FIXME: perform a real assertion here
###   if true; then
###     return 0
###   else
###     ! assert-locked "$1"
###   fi
### }
