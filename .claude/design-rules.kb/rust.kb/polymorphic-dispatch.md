# Polymorphic dispatch: simplification order

Try in order, stop at first fit:

## 1. Generics with Into<T>

```rust
fn file<F, R>(self, name: &str, read: F) -> Self
where F: Fn() -> R, R: Into<File>
```

Multiple types convert to one target. Caller never names the intermediate.

## 2. Concrete type with From impls

One accepted type. Callers use `.into()` at call site if needed.

## 3. Enum (sum type)

Variants have genuinely different runtime behavior the receiver distinguishes.
If receiver treats all variants the same, enum is unnecessary.

## 4. Trait

Behavior varies per type AND type set is open. If only your crate implements
it, use a simpler mechanism.

## Diagnostic

Does this type/trait represent a domain concept, or solve a type system
problem? If the latter, a simpler mechanism likely exists.
