## Style guide

- all code should be fully-typed for `pyright`
  - return types may be left implicit when trivial
- let `black` handle the fine details of formatting

### Module Template

This is how I want my modules to look, generally.

`do_useful_thing.py`

```python
#!/usr/bin/env python3
"""
usage: do-useful-thing [ARG]

{{Explanation}}

{{Examples (if warranted)}}
"""
from __future__ import annotations

ExitCode: TypeAlias = None | int | str
USAGE = __doc__

def do_useful_thing(...):

def main() -> ExitCode:
    from os import environ
    from sys import argv
    ... # create the arguments of do_useful_thing

    result = do_useful_thing()

if __name__ == "__main__":
    raise SystemExit(main())
```

## Design guide

- module-global constants _are okay_
  - still considered constant if modified by `main`
- minimal error handling
  - let the default exception do its thing unless crashing is the wrong thing
- hygiene
  - any modules imported just for a particular function should be imported
    locally to the function
  - use `del` for any objects that we actively intend to not use, especially at
    global scope

## Creating a Class

- always use `dataclass(frozen=True)`
- never override `__init__`
- if we need non-trivial constructor(s):

  ```
  @classmethod
  def from_xyz(cls, x, y, z): ...
  ```

- when to create a class

  - replace dicts of known keys

- when to create a method (of `MyClass`)

  - function that takes just `MyClass`
  - function that requires each attribute of `MyClass`

## Testability

- all functions apart from `main` should take and return "plain old python"
  values
  - `main` always takes zero arguments and returns ExitCode (or None)
  - try to handle all system-integration issues in `main`: environment
    variables, argv, signal handlers, atexit, all IO
  - in non-main functions, you can often replace `print` by `yield`ing an object
- Specific approach to dependencies:
  - Use existing functions that already accept external dependencies as our
    testing seams
  - For subprocess calls, use functions like sh_stdout as the primary injection
    point
  - Direct file operations are acceptable and should be tested using pytest
    fixtures like tmp_path
  - Module constants are considered injectable via mock.patch.object and do not
    need to be converted to arguments
  - When a function already encapsulates an external dependency (like API
    calls), use it as is

## Creating a Test Suite

- create a `class DescribeThing` for each thing we need to test
- create `def it_does_something_useful` for each behavior the thing should have
- add docstrings for any class/method that isn't nicely self-descriptive
- use `pass` for any tests we should leave till after a discussion

## Writing Tests

- You may refactor the implementation for testability. For example:

  - add arguments where mocks would otherwise be needed
  - extract functions where the code clearly has multiple responsibilities
  - separate "pure" and "impure" code, to create testing seams

- we use pytest
- import the "module under test" like so: `import ... as M  # module under test`
- you may not use any part of the `mock` library

  - with one exception:
    `mock.patch.object(target_object, "attribute_name", replacement_value)`

- Testing strategies:

  - For file operations: use pytest fixtures like tmp_path and capture_fd
  - For subprocess calls: test using simple commands and mock via
    mock.patch.object for higher-level function tests
  - For API interaction
    - **Well-established libraries**: import and patch directly
      `mock.patch.object(xyz_sdk, "get_thingy", fake_get_thingy)`
    - **Custom/complex interactions**: patch a testing seam
      `mock.patch.object(M, "frobnicate_xyz", fake_frobnicate_xyz)`

- all code used in tests must be either
  - trivial and self-evidently correct
  - tested
- use fixturing for IO assertions: capture_fd tmp_path

## When fixing and revising

- prefer removing or generalizing over adding code
- remember that the units of technical debt are LOC -- each bit of code should
  be able to justify its existence
