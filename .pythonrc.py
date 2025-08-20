from __future__ import annotations

# make common use cases quicker:
from pathlib import Path

# pylint:disable=missing-docstring
# pylint:disable=g-bad-import-order,g-importing-member,g-import-not-at-top


P = Path
p = Path("/a/b/c/d.txt")


import bukzor.readline

bukzor.readline.register_python_interactivehook()


from pprint import pprint

pp = pprint

from datetime import datetime

now = datetime.now
NOW = now()

from xml.etree import ElementTree as ET
