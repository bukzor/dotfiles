# Keep the ClaudeQuote pipeline inline and recipe-exact

**Date:** 2026-09-01
**Status:** Accepted
**Author:** agent-drafted at session end from the user's in-session rulings -- vetoable

## Context

Quoting claude-code terminal output into markdown was a ten-step by-hand
routine: paste, `set sw=2`, blockwise-select the first two columns and `x`,
`VG!prettier-markdown`, `VG>`, then `CTRL-V G r>`. Mechanizing it is obvious.
The non-obvious part is everything one is tempted to improve along the way --
each of those temptations was raised, and each was rejected.

## Decision

`~/.vimrc.d/finger-savers.vim` defines the whole thing in three lines:

```vim
command! -range=% ClaudeQuote <line1>,<line2>!colrm 1 2 | prettier-markdown | sed '/./s/^/> /'
nnoremap <Leader>cq <Cmd>ClaudeQuote<CR>
xnoremap <Leader>cq :ClaudeQuote<CR>
```

`colrm 1 2` is steps 3-5, `prettier-markdown` is 6-7, and `sed '/./s/^/> /'`
is 8-10 (`> ` is exactly a 2-space shift with column 1 overwritten; the `/./`
is the blank-line skip that blockwise `r` gives for free). `which-key.lua`
carries the label. Usage is two steps: ctrl-shift-v, then `\cq`.

Three constraints, all deliberate, all easy to mistake for oversights:

1. **The pipeline stays inline.** No `bin/` script.
2. **Output matches the by-hand keystrokes byte for byte**, flaws included.
3. **`colrm 1 2`, never `cut -c3-`.**

## Alternatives Considered

### `bin/claude-quote` + `bin/md-blockquote` (built, then removed)

- **Pros:** reusable from a shell pipe, names state intent, mapping stays
  trivial, no `|`-escaping inside a mapping RHS.
- **Cons:** two new files in `~/bin` for one keybinding. Removed at the user's
  request; the pipeline moved into the `:command` instead. Do not reintroduce
  them as a cleanup.

### Quote first, then prettier

Prefixing `> ` before running prettier makes prettier count the marker, so
output fits 80 columns and is a fixed point under a later whole-file prettier
run. It also emits a bare `>` on blank lines, which keeps one blockquote
rather than splitting into several at each blank line.

- **Pros:** strictly better markdown on both counts.
- **Cons:** not what the by-hand recipe produces. Fidelity was the
  requirement, and this was rejected explicitly after being tried.

### `cut -c3-` for the gutter

GNU `cut`'s `-c` is byte-based (identical to `-b`), so it splits the 3-byte
U+23FA (`⏺`) that claude-code writes in the gutter and leaves mojibake.
This was the shipped behavior briefly; it is a bug, not a tradeoff.

### `sed 's/^..//'` for the gutter

Character-correct in a UTF-8 locale, but `^..` needs two characters, so a line
holding only the prefix survives untouched. `colrm` removes *up to* two
columns, which is what blockwise `x` did.

### Normal-mode mapping over the paste marks (`'[,']`)

Works -- nvim sets `'[`/`']` for bracketed paste in both normal and insert
mode, verified via `nvim_paste()`. Rejected by the user in favor of
`-range=%`, which defaults to the whole buffer with no hidden state.

## Consequences

**Positive:**

- Ten steps became two, with no new files outside the config itself.
- `:ClaudeQuote` takes an arbitrary range, so it is usable beyond the mapping.

**Negative:**

- A blank line inside a fenced code block in the pasted text terminates the
  blockquote, dropping the rest of the fence out of the quote. Inherited from
  the by-hand recipe and accepted knowingly.
- Lines reach 82 columns: prettier wraps at 80, then `> ` is prepended. A
  later whole-file prettier pass rewraps them. Also inherited.
- `colrm` is not POSIX. Two are installed here (brew's util-linux and Debian's
  `bsdextrautils`), both multibyte-correct. macOS ships a BSD `colrm` whose
  multibyte behavior is unverified.

**Neutral:**

- The two retired scripts are parked in `~/trash/vim-paste-quote/`.

## Verification

Fidelity was proven, not assumed: drive the original keystrokes under headless
nvim and diff against the command's output on the same input.

```vim
set shiftwidth=2
call setline(1, readfile('sample.md'))
execute "normal! gg\<C-v>lGx"
execute "normal! VG!prettier-markdown\<CR>"
execute "normal! VG>"
execute "normal! gg\<C-v>Gr>"
write! out-byhand.md
silent %delete _
call setline(1, readfile('sample.md'))
ClaudeQuote
write! out-script.md
```

`nvim --headless -u NONE -S` that, then `diff out-byhand.md out-script.md` --
no output, exit 0. Re-run it after any change to the pipeline.

## Related

- Related to: `testing.kb/headless-config-loads-cleanly.md`, re-run for the
  `which-key.lua` change.
