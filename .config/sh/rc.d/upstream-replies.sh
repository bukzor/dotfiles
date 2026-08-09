# Nag when upstream bug reports get replies (6h-throttled inside the
# tool; backgrounded so prompts never wait on the network; stderr
# dropped so offline shells start silently). Acknowledge a nag by
# running `upstream-replies` by hand.
(upstream-replies --rc 2>/dev/null &)
