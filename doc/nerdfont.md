# Nerd Font

This font is an essential component of a modern dev setup, adding icons for most imagineable purpose.


## Crostini

AKA 'penguin' or 'Linux on Chromebooks'

1. Browse to chrome-untrusted://terminal/html/nassh_preferences_editor.html
2. Paste into `Custom CSS (inline text)`
   ```css
   @font-face {
     font-family: 'Nerd Symbols';
     src: url(https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFont-Regular.ttf) format('truetype');
   }
   @font-face {
     font-family: 'Nerd Symbols Mono';
     src: url(https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFontMono-Regular.ttf) format('truetype');
   }
   ```

## ChromeOS

I haven't found a way to modify chromeos to enable such fallback fonts.
