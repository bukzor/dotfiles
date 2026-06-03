# hterm Configuration

Configuration files for Chrome OS's hterm terminal emulator.

## Installation

### Fonts (terminal.css)

1. Open preferences editor: [chrome-untrusted://terminal/html/nassh_preferences_editor.html](chrome-untrusted://terminal/html/nassh_preferences_editor.html)
2. Find the "Custom CSS (URI)" field
3. Paste the contents of `terminal.css`
4. Save

### Keyboard Bindings

1. Open preferences editor: [chrome-untrusted://terminal/html/nassh_preferences_editor.html](chrome-untrusted://terminal/html/nassh_preferences_editor.html)
2. Find "Keyboard Bindings" section
3. Add:
   ```json
   {
     "Shift-Enter": "'\n'"
   }
   ```
4. Save

This enables Shift+Enter to insert newlines in claude-code under Chrome OS.

## Usage

Open terminal: [chrome-untrusted://terminal/?emulator=hterm](chrome-untrusted://terminal/?emulator=hterm)

## Files

- `custom-css-inline-text.css` - Font configuration with Nerd Fonts support (paste into "Custom CSS (inline text)" field)
- `custom-css-inline-text-reference.css` - Reference fonts for comparison/testing
- `keybindings.json` - Keyboard shortcuts (paste into "Keyboard Bindings" field)
