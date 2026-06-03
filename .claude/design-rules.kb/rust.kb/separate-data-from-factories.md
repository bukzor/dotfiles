# Separate data from factories

Don't put closures in data structs. Merging data and factory pulls `Box`,
`dyn`, `'static` into the data type — forces heap allocation, prevents
`Clone`/`Debug`, spreads lifetime constraints.

## The pattern

- Data struct: `File { data, mtime, mode }` — pure, cloneable
- Factory: builder stores `Box<dyn Fn() -> File>` internally
- API: takes `impl Fn() -> impl Into<File>` — no boxing visible

## Diagnostic

If `'static` appears where it feels wrong, check for merged data+factory.
The `'static` is leaking from a boxed closure that doesn't belong there.
