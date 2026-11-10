# When Arc Seems Unnecessary

Trigger: questioning why Arc is needed, or suggesting Rc, Box, or avoiding
reference counting entirely.

## The chain

1. **Closures with state** — callbacks that capture variables
2. **Heterogeneous container** — different closures stored in one HashMap/Vec
3. **Type erasure** — `dyn Fn()` makes them the same type (like Python's `PyObject*`)
4. **`dyn Fn` is not Clone** — Clone returns `Self`, requires `Sized`; trait objects aren't `Sized`
5. **But we need Clone** — an `Fn` closure that returns owned values must produce them repeatedly; it can't move its captures out more than once
6. **Arc restores Clone** — clone bumps a refcount, the closure stays in one place on the heap

## Why not Rc?

`fuser` requires `Send + Sync` (FUSE callbacks come from multiple threads).
Rc is `!Send`. Arc's atomic overhead is negligible vs FUSE kernel round-trips.

## Mental model

Arc = Python reference. Every Python object is heap-allocated,
reference-counted, type-erased. Arc is Rust making you spell that out.
The "A" (atomic) makes it thread-safe — Python needs the GIL for that.

## When is Arc actually avoidable?

When the user provides the closure directly (not the builder synthesizing one).
A user-written `Fn` callback constructs fresh values each call — no sharing
needed. The builder's problem is that it receives the closure *once* at build
time and must return it from a synthesized Dir callback *repeatedly*.

## Source

chatfs-fuser dynamic routing design session, 2026-03-20.
