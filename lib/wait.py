from os import getenv

from lib import sh
from time import sleep as do_sleep

WAIT_LIMIT = int(getenv("WAIT_LIMIT", "30"))
WAIT_SLEEP = int(getenv("WAIT_SLEEP", "3"))


def _wait_loop(assertion, limit, sleep):
    while limit > sleep:
        try:
            result = assertion()
        except AssertionError:
            result = False

        if result in (True, None):
            return

        do_sleep(sleep)
        limit -= sleep


def for_(assertion, limit=WAIT_LIMIT, sleep=WAIT_SLEEP):
    sh.banner(f"retrying for {limit} seconds...")
    with sh.quiet():
        _wait_loop(assertion, limit, sleep)
    sh.run((":", "show the final try:"))
    assertion()
