# Use Into<T> for API flexibility

When a function accepts or returns a type, bound on `Into<T>` rather than
requiring `T` directly. This lets callers pass any type that converts naturally,
without explicit `.into()` calls at every site.

## In closure return types

For callbacks that produce a value, use:

```rust
pub fn file<F, R>(self, name: &str, read: F) -> Self
where
    F: Fn() -> R,
    R: Into<File>,
```

This lets closures return `String`, `&str`, or `File` — whatever's natural for
the call site. The conversion happens inside the framework, not at every use.

## Why not just take the concrete type

Requiring `Fn() -> File` forces callers to wrap every return:
`|| File::new(some_string)`. With `Into<File>`, `|| some_string` just works.

## Python analogy

This is similar to Python functions accepting `Union[str, Path]` or using
`os.fspath()` — accept what's natural, convert internally.

## Source

chatfs-fuser API design session, 2026-03-19.
