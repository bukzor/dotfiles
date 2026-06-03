# Use #[expect], not #[allow], for lint suppression

`#[expect(lint)]` is self-cleaning: warns when the suppressed lint stops firing.

## Dual-compilation: dead_code + tests

Items used only from `#[cfg(test)]` are dead in `--lib` but alive in `--tests`:

- `#[expect(dead_code)]` → unfulfilled in test build → warning
- `#[cfg_attr(not(test), expect(dead_code))]` → clean in both

## Diagnostic workflow

**Categorize before annotating.** Do not iterate speculatively.

```bash
cargo clippy -p CRATE --lib 2>&1 | grep 'is never'
cargo clippy -p CRATE --tests 2>&1 | grep 'is never'
```

- **Both** builds → `#[expect(dead_code)]`
- **Lib only** → `#[cfg_attr(not(test), expect(dead_code, reason = "..."))]`
- **Tests only** → investigate

Verify: `cargo clippy -p CRATE --all-targets` (zero warnings = clean).

## Transitive suppression

`#[expect(dead_code)]` on an `impl` block covers the struct and all methods.
One annotation on the right target often covers several warnings.

