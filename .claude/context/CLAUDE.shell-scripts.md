- _Always_ prefer "hard" quotes (i.e. '). Only use soft quotes (") where you
  _actively_ want variable interpolation.
- _Always_ use "$@" when "wrapping" a command
- when nesting shells, pass variables via shell args:

  ```bash
  sh -euc 'echo arg1: "$1"; echo arg2: "$2"' - "$@"

  find ... -print 0 | xargs -n1 sh -euxc 'dir="$(dirname "$1")"; cd "$dir" ...' -
  ```

- **Always** use shell options -eu
- Use shell option -x where showing all commands it helpful for log clarity
  - when running under -x mode, prefer `:` over `echo` for printing messages
- if you end up writing long or complex pipelines, use bash and
  `set -o pipefail`

## Tips & Tricks

- insert a line:
  ```sh
  sed -r '/^def test_abc\(/i\
  @pytest.mark.xyz'
  ```
