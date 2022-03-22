# pylint:disable=missing-docstring
# enable tab completion
import readline
import rlcompleter
readline.parse_and_bind('tab: complete')
del readline, rlcompleter

# make common use cases quicker:
# pylint:disable=g-bad-import-order,g-importing-member,g-import-not-at-top
from pathlib import Path
P = Path
p = Path('/a/b/c/d.txt')

from pprint import pprint
pp = pprint

from datetime import datetime
now = datetime.now
NOW = now()
