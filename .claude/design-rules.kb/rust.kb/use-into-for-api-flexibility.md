# Use Into<T> for API flexibility

Bound on `Into<T>` rather than requiring `T` directly:

```rust
pub fn file<F, R>(self, name: &str, read: F) -> Self
where F: Fn() -> R, R: Into<File>,
```

Closures return `String`, `&str`, or `File` — whatever's natural.
Conversion happens inside the framework, not at every call site.

Without `Into`, callers must wrap: `|| File::new(some_string)`.
With `Into`, `|| some_string` just works.
