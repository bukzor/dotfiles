# impl Trait can't nest inside Fn bounds (yet)

**This is a known compiler limitation, not a design rule.**

## The problem

You can't write:

```rust
fn file(self, name: &str, read: impl Fn() -> impl Into<File>) -> Self
```

`impl Trait` isn't allowed in the return type position of `Fn` trait bounds.
The workaround is explicit generics:

```rust
fn file<F, R>(self, name: &str, read: F) -> Self
where
    F: Fn() -> R,
    R: Into<File>,
```

These compile to identical code. The limitation is purely syntactic.

## Python mismatch

In Python, `Callable[[], Into[File]]` works fine as a type hint — nested
generics resolve at runtime. In Rust, `impl Trait` is a compile-time
monomorphization instruction that can only appear in direct argument/return
positions, not nested inside other trait bounds.

## Status

Active proposals exist (`return_type_notation` and related RFCs). The Rust team
considers this the right direction. Likely stabilized eventually, but Rust moves
conservatively — expect a year or more.

## Related

Each closure literal creates a unique anonymous type, so closure type parameters
must be per-method, not per-struct/impl. You can't "lift" `F: Fn() -> R` to a
higher scope and reuse it across methods, because each `.file()` call passes a
different closure type.

## Source

chatfs-fuser API design session, 2026-03-19.
