# Separate data from factories

Don't put a closure (`Box<dyn Fn() -> T>`) inside a data struct. A `File` is
data (content + metadata). A closure that *produces* a File on each read is a
factory — that's the caller's concern, not the struct's.

Merging them pulls `Box`, `dyn`, and `'static` into the data type, which:

- Forces heap allocation on pure data
- Prevents `Clone`, `Debug` from deriving naturally
- Spreads lifetime constraints to every consumer of the type

## The pattern

- Data struct: `File { data, mtime, mode }` — pure, cloneable, no closures
- Factory: the builder/framework stores `Box<dyn Fn() -> File>` internally
- User-facing API: takes `impl Fn() -> impl Into<File>` — clean, no boxing visible

## How we learned this

Started with `File` containing an `Inner` enum (`Static(String)` /
`Dynamic(Box<dyn Fn()>)`). This merged data and factory, causing `'static`
to infect the entire API. Splitting them fixed it — `File` became pure data,
closures stayed in the builder.

## Diagnostic

If `'static` appears in your API where it feels wrong, check whether you've
merged a data type with a factory. `'static` on a struct means it can't borrow
— if your data type is conceptually just values, it shouldn't need that
constraint. The `'static` is leaking from a boxed closure that doesn't belong
there.

## Source

chatfs-fuser API design session, 2026-03-19.
