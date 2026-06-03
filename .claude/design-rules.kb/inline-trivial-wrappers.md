# Inline trivial wrappers

A function with 1-3 lines and a single call site is indirection, not
abstraction. Inline it unless the name reveals non-obvious intent that the body
doesn't.
