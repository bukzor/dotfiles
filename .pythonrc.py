# pylint:disable=missing-docstring
# pylint:disable=g-bad-import-order,g-importing-member,g-import-not-at-top

# make common use cases quicker:
from pathlib import Path
P = Path
p = Path('/a/b/c/d.txt')


# Enable default readline configuration on interactive prompts.
def register_readline():
    import atexit
    import readline
    import rlcompleter

    # Reading the initialization (config) file may not be enough to set a
    # completion key, so we set one first and then read the file.
    readline_doc = getattr(readline, '__doc__', '')
    if readline_doc is not None and 'libedit' in readline_doc:
        init_file = '~/.editrc'
    else:
        init_file = '~/.inputrc'

    print('Line-editor configured:', init_file)
    readline.read_init_file(Path(init_file).expanduser())

    if readline.get_current_history_length() == 0:
        # If no history was loaded, default to .python_history.
        # The guard is necessary to avoid doubling history size at
        # each interpreter exit when readline was already configured
        # through a PYTHONSTARTUP hook, see:
        # http://bugs.python.org/issue5845#msg198636
        history = Path('~/.python_history').expanduser()
        if history.exists():
            readline.read_history_file(history)

        def write_history():
            readline.write_history_file(history)

        atexit.register(write_history)

import sys
del sys.__interactivehook__
register_readline()
del register_readline


from pprint import pprint
pp = pprint

from datetime import datetime
now = datetime.now
NOW = now()

from xml.etree import ElementTree as ET
