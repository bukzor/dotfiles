# Claude Context: hterm Configuration

Context for AI assistants working on hterm terminal configuration.

## CRITICAL: How hterm Works

**hterm** is Chrome OS's terminal emulator, accessed via:
- Preferences: `chrome-untrusted://terminal/html/nassh_preferences_editor.html`
- Terminal: `chrome-untrusted://terminal/?emulator=hterm`

**Key constraint**: hterm stores config in Chrome's internal storage (not files). Configuration must be **copy-pasted** from these files into the web UI. No direct file-based config possible without Chrome extension.

**Configuration fields in preferences editor:**
- "Text font family" - Font stack list (e.g., `'Font A', 'Font B', monospace`)
- "Custom CSS (inline text)" - Full CSS with @font-face definitions
- "Keyboard Bindings" - JSON object with key mappings

## CRITICAL: Nerd Font Width Issues

**The "Symbols Only" Nerd Font is BROKEN** - renders double-width despite claiming to be monospace.

**Only solution**: Use fully patched Nerd Font variants like:
- `SauceCodeProNerdFontMono-Regular.ttf` ✓ Works
- `SymbolsNerdFontMono-Regular.ttf` ✗ Broken (double-width)

**Why**: Terminal wcwidth() is based on Unicode character properties, not font metrics. Private Use Area glyphs (where Nerd Font icons live) can render at different widths than the terminal expects, causing misalignment.

**Testing**: In neovim, Nerd Font icons should:
1. Appear (not as □ or �)
2. Move cursor 1 cell when pressing `l` on them
3. Align vertically in columns

## CRITICAL: Recommended Font Stack

```
'Nerd Source Code Pro', 'Julia Mono', 'Unifont', monospace
```

**Why this order:**
1. **Nerd Source Code Pro**: Primary font - Source Code Pro + Nerd Font icons, properly monospaced
2. **Julia Mono**: 11,000+ glyphs, nice-looking, covers most Unicode including dingbats (✳, ❁, etc.)
3. **Unifont**: 60,000+ glyphs, bitmap (ugly/pixelated) but comprehensive fallback for rare symbols
4. **monospace**: System fallback

**Browser font fallback**: Tries each font in order until it finds one with the glyph. Earlier fonts are used preferentially.

## IMPORTANT: File Organization

- `custom-css-inline-text.css` - Recommended fonts only (paste into "Custom CSS (inline text)")
- `custom-css-inline-text-reference.css` - Alternative/test fonts (DO NOT paste into hterm)
- `keybindings.json` - Keyboard shortcuts (paste into "Keyboard Bindings")
- `README.md` - Installation instructions for humans

## IMPORTANT: Font Sources and Gotchas

**CDN reliability:**
- ✓ `cdn.jsdelivr.net/fontsource/fonts/` - Reliable, WOFF2 format
- ✓ `cdn.jsdelivr.net/gh/` (GitHub via jsDelivr) - Good for Nerd Fonts
- ✓ `fonts.gstatic.com` - Google Fonts, usually TTF
- ⚠ `raw.githubusercontent.com` - Works but slower, used for Nerd Fonts

**Font format preference:**
- WOFF2 > WOFF > TTF for web use
- WOFF2 is 30-50% smaller, better compression

**Google Fonts gotchas:**
- Don't hand-construct `fonts.gstatic.com` URLs - they break
- Use Fontsource CDN or fetch CSS from `fonts.googleapis.com/css2?family=...` and extract URLs

## IMPORTANT: Verifying Font Coverage

Check which system fonts have a specific character:
```bash
fc-list :charset=2733  # Check for U+2733 (✳)
```

Browser DevTools to see which font actually rendered:
1. Inspect element with the character
2. Go to "Fonts" tab (Firefox) or "Rendered Fonts" in Computed tab (Chrome)
3. Shows which font(s) were used

Test pages for Unicode support:
- `https://www.fileformat.info/info/unicode/char/2733/fontsupport.htm` (replace 2733 with hex codepoint)

## Font Coverage Reference

**Monospace fonts with good Unicode coverage:**
- JuliaMono: ~11,000 glyphs, outline font (looks nice)
- Unifont: ~60,000 glyphs, bitmap font (looks pixelated)
- DejaVu Mono: ~6,000 glyphs, outline font
- Noto Sans Mono: Good coverage but Latin subset may be limited on CDN

**Why not others:**
- Everson Mono: Only "Latin 6" subset available on CDN (~limited coverage)
- Quivira: NOT monospace (proportional serif)
- Symbola: NOT monospace (proportional)

## Font Naming Conventions

**In this config:**
- `'Nerd Source Code Pro'` - User's preferred name for the Nerd Font variant
- Maps to file: `SauceCodeProNerdFontMono-Regular.ttf`

**Standard Nerd Font naming:**
- `SauceCodePro` (not Source Code Pro) for the Nerd Font variant
- `Mono` suffix = monospace
- `Regular` vs `Medium` = font weight (both work, user prefers Regular)

## Keyboard Binding Notes

```json
{
  "$comment": "Shift-Enter inserts newline for claude-code under Chrome OS",
  "Shift-Enter": "'\n'"
}
```

This enables multi-line input in claude-code TUI by mapping Shift+Enter to literal newline.

## Testing Checklist

When modifying font configuration:

1. **Visual test**: Do special chars (✳, ❁, , , ⛳) appear correctly?
2. **Alignment test**: Do columns of icons line up vertically?
3. **Cursor test**: In vim, does cursor move 1 cell per character?
4. **Nerd Font test**: Do Nerd Font icons appear and align?
5. **Fallback test**: Do rare Unicode chars (🔨, ⇒, ❅) render without tofu (□)?

## Common Issues

**"Symbols render double-width"**: Using wrong Nerd Font variant or "Symbols Only" font
**"Icons appear as boxes (□)"**: Font not loaded or missing that codepoint
**"Font looks pixelated"**: Unifont is rendering (expected for rare chars only)
**"URLs don't load"**: Check CDN availability, try jsdelivr.net alternatives
**"Changes don't take effect"**: Must reload terminal after pasting new config
