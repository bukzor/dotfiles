# Nag when upstream bug reports get replies (6h-throttled inside the
# tool; backgrounded so prompts never wait on the network; stderr
# dropped so offline shells start silently). Acknowledge a nag by
# running `upstream-replies` by hand; watch another thread with
# `upstream-replies add <issue-url>`.
#
# The tool ships in github.com/bukzor/bukzor-tools (`uv tool install .`),
# not in these dotfiles; this hook no-ops when it isn't installed.
(upstream-replies --rc 2>/dev/null &)
