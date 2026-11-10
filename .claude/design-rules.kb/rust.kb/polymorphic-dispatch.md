# Polymorphic dispatch: simplification order

When a method needs to accept multiple types, prefer the simplest mechanism
that works. Try these in order — stop at the first that fits.

## 1. Generics with Into<T>

```rust
fn file<F, R>(self, name: &str, read: F) -> Self
where F: Fn() -> R, R: Into<File>
```

Use when: the method accepts several types that convert to one target type.
The caller never names the intermediate — `String`, `&str`, `File` all just work.

## 2. Concrete type with From impls

```rust
fn file(self, name: &str, read: impl Fn() -> File) -> Self
```

Use when: there's only one accepted type. `From` impls on the target let callers
use `.into()` at the call site if needed.

## 3. Enum (sum type)

```rust
enum FileSource { Static(File), Dynamic(Box<dyn Fn() -> File>) }
fn file(self, name: &str, source: impl Into<FileSource>) -> Self
```

Use when: the variants have genuinely different runtime behavior that the
receiver needs to distinguish. If the receiver treats all variants the same
(calls a function, gets a File), the enum is unnecessary.

## 4. Trait

```rust
trait ContentSource { fn read(&self) -> File; }
fn file(self, name: &str, source: impl ContentSource) -> Self
```

Use when: the behavior varies per type AND the set of types is open (users
implement it). If only your crate implements it, you've created a private
interface — use a simpler mechanism.

## Decision rule

Before creating a type or trait for dispatch, ask: does this represent a domain
concept, or is it solving a type system problem? If the latter, a simpler
mechanism likely exists.

## Source

chatfs-fuser API design session, 2026-03-19. Went through trait → merged struct
→ enum → bare generics, eliminating each intermediate type as unnecessary.
