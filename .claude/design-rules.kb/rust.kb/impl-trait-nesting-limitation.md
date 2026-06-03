# impl Trait can't nest inside Fn bounds (yet)

**Known compiler limitation, not a design rule.**

Can't write `read: impl Fn() -> impl Into<File>`. Workaround — explicit generics:

```rust
fn file<F, R>(self, name: &str, read: F) -> Self
where F: Fn() -> R, R: Into<File>,
```

Identical compiled code. Purely syntactic limitation.

Each closure literal creates a unique anonymous type, so closure type
parameters must be per-method, not per-struct/impl.
