" This scheme was created by CSApproxSnapshot
" on Tue, 06 Sep 2011

hi clear
if exists("syntax_on")
    syntax reset
endif

if v:version < 700
    let g:colors_name = expand("<sfile>:t:r")
    command! -nargs=+ CSAHi exe "hi" substitute(substitute(<q-args>, "undercurl", "underline", "g"), "guisp\\S\\+", "", "g")
else
    let g:colors_name = expand("<sfile>:t:r")
    command! -nargs=+ CSAHi exe "hi" <q-args>
endif

if 0
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_konsole") && g:CSApprox_konsole) || &term =~? "^konsole"
    CSAHi Normal term=NONE cterm=NONE ctermbg=16 ctermfg=157 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi Identifier term=underline cterm=NONE ctermbg=16 ctermfg=51 gui=NONE guibg=#000000 guifg=#00ffff
    CSAHi PreProc term=underline cterm=NONE ctermbg=16 ctermfg=224 gui=NONE guibg=#000000 guifg=#f5deb3
    CSAHi Type term=underline cterm=NONE ctermbg=16 ctermfg=250 gui=NONE guibg=#000000 guifg=#bebebe
    CSAHi Underlined term=underline cterm=underline ctermbg=16 ctermfg=147 gui=underline guibg=#000000 guifg=#80a0ff
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=226 ctermfg=21 gui=NONE guibg=#ffff00 guifg=#0000ff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=16 ctermfg=51 gui=NONE guibg=#000000 guifg=#00ffff
    CSAHi NonText term=bold cterm=bold ctermbg=16 ctermfg=21 gui=bold guibg=#000000 guifg=#0000ff
    CSAHi Directory term=bold cterm=NONE ctermbg=16 ctermfg=51 gui=NONE guibg=#000000 guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=157 ctermfg=16 gui=reverse guibg=#000000 guifg=#90ee90
    CSAHi Search term=reverse cterm=NONE ctermbg=21 ctermfg=231 gui=NONE guibg=#0000ff guifg=#ffffff
    CSAHi MoreMsg term=bold cterm=bold ctermbg=16 ctermfg=72 gui=bold guibg=#000000 guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=16 ctermfg=157 gui=bold guibg=#000000 guifg=#90ee90
    CSAHi LineNr term=underline cterm=NONE ctermbg=16 ctermfg=226 gui=NONE guibg=#000000 guifg=#ffff00
    CSAHi Scrollbar term=NONE cterm=NONE ctermbg=16 ctermfg=157 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi Menu term=NONE cterm=NONE ctermbg=16 ctermfg=157 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=16 ctermfg=157 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi SpellErrors term=NONE cterm=NONE ctermbg=16 ctermfg=157 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=16 ctermfg=51 gui=undercurl guibg=#000000 guifg=#90ee90 guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=201 ctermfg=157 gui=NONE guibg=#ff00ff guifg=#90ee90
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=248 ctermfg=157 gui=NONE guibg=#a9a9a9 guifg=#90ee90
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=157 gui=NONE guibg=#bebebe guifg=#90ee90
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=157 ctermfg=16 gui=reverse guibg=#000000 guifg=#90ee90
    CSAHi TabLine term=underline cterm=underline ctermbg=248 ctermfg=157 gui=underline guibg=#a9a9a9 guifg=#90ee90
    CSAHi TabLineSel term=bold cterm=bold ctermbg=16 ctermfg=157 gui=bold guibg=#000000 guifg=#90ee90
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=157 ctermfg=16 gui=reverse guibg=#000000 guifg=#90ee90
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=102 ctermfg=157 gui=NONE guibg=#666666 guifg=#90ee90
    CSAHi CursorLine term=underline cterm=NONE ctermbg=102 ctermfg=157 gui=NONE guibg=#666666 guifg=#90ee90
    CSAHi Question term=NONE cterm=bold ctermbg=16 ctermfg=51 gui=bold guibg=#000000 guifg=#00ffff
    CSAHi StatusLine term=reverse,bold cterm=NONE ctermbg=19 ctermfg=231 gui=NONE guibg=#00008b guifg=#ffffff
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=59 ctermfg=231 gui=NONE guibg=#333333 guifg=#ffffff
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=157 ctermfg=16 gui=reverse guibg=#000000 guifg=#90ee90
    CSAHi Title term=bold cterm=bold ctermbg=16 ctermfg=224 gui=bold guibg=#000000 guifg=#ffc0cb
    CSAHi Visual term=reverse cterm=NONE ctermbg=28 ctermfg=231 gui=NONE guibg=#006400 guifg=#ffffff
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=16 ctermfg=157 gui=bold,underline guibg=#000000 guifg=#90ee90
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=16 ctermfg=196 gui=NONE guibg=#000000 guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=248 ctermfg=51 gui=NONE guibg=#a9a9a9 guifg=#00ffff
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=124 ctermfg=157 gui=NONE guibg=#8b0000 guifg=#90ee90
    CSAHi Cursor term=NONE cterm=NONE ctermbg=157 ctermfg=176 gui=NONE guibg=#90ee90 guifg=#da70d6
    CSAHi lCursor term=NONE cterm=NONE ctermbg=157 ctermfg=16 gui=NONE guibg=#90ee90 guifg=#000000
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=37 ctermfg=157 gui=NONE guibg=#008b8b guifg=#90ee90
    CSAHi Constant term=underline cterm=NONE ctermbg=16 ctermfg=231 gui=NONE guibg=#000000 guifg=#ffffff
    CSAHi Special term=bold cterm=NONE ctermbg=16 ctermfg=201 gui=NONE guibg=#000000 guifg=#ff00ff
    CSAHi Statement term=bold cterm=NONE ctermbg=16 ctermfg=226 gui=NONE guibg=#000000 guifg=#ffff00
    CSAHi Ignore term=NONE cterm=NONE ctermbg=16 ctermfg=16 gui=NONE guibg=#000000 guifg=#000000
    CSAHi Comment term=bold cterm=NONE ctermbg=16 ctermfg=214 gui=NONE guibg=#000000 guifg=#ffa500
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=19 ctermfg=157 gui=NONE guibg=#00008b guifg=#90ee90
    CSAHi DiffChange term=bold cterm=NONE ctermbg=127 ctermfg=157 gui=NONE guibg=#8b008b guifg=#90ee90
    CSAHi DiffDelete term=bold cterm=bold ctermbg=37 ctermfg=21 gui=bold guibg=#008b8b guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=157 gui=bold guibg=#ff0000 guifg=#90ee90
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=16 ctermfg=196 gui=undercurl guibg=#000000 guifg=#90ee90 guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=16 ctermfg=21 gui=undercurl guibg=#000000 guifg=#90ee90 guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=16 ctermfg=201 gui=undercurl guibg=#000000 guifg=#90ee90 guisp=#ff00ff
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
    CSAHi Normal term=NONE cterm=NONE ctermbg=16 ctermfg=157 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi Identifier term=underline cterm=NONE ctermbg=16 ctermfg=51 gui=NONE guibg=#000000 guifg=#00ffff
    CSAHi PreProc term=underline cterm=NONE ctermbg=16 ctermfg=230 gui=NONE guibg=#000000 guifg=#f5deb3
    CSAHi Type term=underline cterm=NONE ctermbg=16 ctermfg=250 gui=NONE guibg=#000000 guifg=#bebebe
    CSAHi Underlined term=underline cterm=underline ctermbg=16 ctermfg=153 gui=underline guibg=#000000 guifg=#80a0ff
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=255 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=226 ctermfg=21 gui=NONE guibg=#ffff00 guifg=#0000ff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=16 ctermfg=51 gui=NONE guibg=#000000 guifg=#00ffff
    CSAHi NonText term=bold cterm=bold ctermbg=16 ctermfg=21 gui=bold guibg=#000000 guifg=#0000ff
    CSAHi Directory term=bold cterm=NONE ctermbg=16 ctermfg=51 gui=NONE guibg=#000000 guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=255 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=157 ctermfg=16 gui=reverse guibg=#000000 guifg=#90ee90
    CSAHi Search term=reverse cterm=NONE ctermbg=21 ctermfg=255 gui=NONE guibg=#0000ff guifg=#ffffff
    CSAHi MoreMsg term=bold cterm=bold ctermbg=16 ctermfg=72 gui=bold guibg=#000000 guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=16 ctermfg=157 gui=bold guibg=#000000 guifg=#90ee90
    CSAHi LineNr term=underline cterm=NONE ctermbg=16 ctermfg=226 gui=NONE guibg=#000000 guifg=#ffff00
    CSAHi Scrollbar term=NONE cterm=NONE ctermbg=16 ctermfg=157 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi Menu term=NONE cterm=NONE ctermbg=16 ctermfg=157 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=16 ctermfg=157 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi SpellErrors term=NONE cterm=NONE ctermbg=16 ctermfg=157 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=16 ctermfg=51 gui=undercurl guibg=#000000 guifg=#90ee90 guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=201 ctermfg=157 gui=NONE guibg=#ff00ff guifg=#90ee90
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=248 ctermfg=157 gui=NONE guibg=#a9a9a9 guifg=#90ee90
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=157 gui=NONE guibg=#bebebe guifg=#90ee90
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=157 ctermfg=16 gui=reverse guibg=#000000 guifg=#90ee90
    CSAHi TabLine term=underline cterm=underline ctermbg=248 ctermfg=157 gui=underline guibg=#a9a9a9 guifg=#90ee90
    CSAHi TabLineSel term=bold cterm=bold ctermbg=16 ctermfg=157 gui=bold guibg=#000000 guifg=#90ee90
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=157 ctermfg=16 gui=reverse guibg=#000000 guifg=#90ee90
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=241 ctermfg=157 gui=NONE guibg=#666666 guifg=#90ee90
    CSAHi CursorLine term=underline cterm=NONE ctermbg=241 ctermfg=157 gui=NONE guibg=#666666 guifg=#90ee90
    CSAHi Question term=NONE cterm=bold ctermbg=16 ctermfg=51 gui=bold guibg=#000000 guifg=#00ffff
    CSAHi StatusLine term=reverse,bold cterm=NONE ctermbg=19 ctermfg=255 gui=NONE guibg=#00008b guifg=#ffffff
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=236 ctermfg=255 gui=NONE guibg=#333333 guifg=#ffffff
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=157 ctermfg=16 gui=reverse guibg=#000000 guifg=#90ee90
    CSAHi Title term=bold cterm=bold ctermbg=16 ctermfg=231 gui=bold guibg=#000000 guifg=#ffc0cb
    CSAHi Visual term=reverse cterm=NONE ctermbg=28 ctermfg=255 gui=NONE guibg=#006400 guifg=#ffffff
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=16 ctermfg=157 gui=bold,underline guibg=#000000 guifg=#90ee90
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=16 ctermfg=196 gui=NONE guibg=#000000 guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=248 ctermfg=51 gui=NONE guibg=#a9a9a9 guifg=#00ffff
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=124 ctermfg=157 gui=NONE guibg=#8b0000 guifg=#90ee90
    CSAHi Cursor term=NONE cterm=NONE ctermbg=157 ctermfg=219 gui=NONE guibg=#90ee90 guifg=#da70d6
    CSAHi lCursor term=NONE cterm=NONE ctermbg=157 ctermfg=16 gui=NONE guibg=#90ee90 guifg=#000000
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=37 ctermfg=157 gui=NONE guibg=#008b8b guifg=#90ee90
    CSAHi Constant term=underline cterm=NONE ctermbg=16 ctermfg=255 gui=NONE guibg=#000000 guifg=#ffffff
    CSAHi Special term=bold cterm=NONE ctermbg=16 ctermfg=201 gui=NONE guibg=#000000 guifg=#ff00ff
    CSAHi Statement term=bold cterm=NONE ctermbg=16 ctermfg=226 gui=NONE guibg=#000000 guifg=#ffff00
    CSAHi Ignore term=NONE cterm=NONE ctermbg=16 ctermfg=16 gui=NONE guibg=#000000 guifg=#000000
    CSAHi Comment term=bold cterm=NONE ctermbg=16 ctermfg=220 gui=NONE guibg=#000000 guifg=#ffa500
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=19 ctermfg=157 gui=NONE guibg=#00008b guifg=#90ee90
    CSAHi DiffChange term=bold cterm=NONE ctermbg=127 ctermfg=157 gui=NONE guibg=#8b008b guifg=#90ee90
    CSAHi DiffDelete term=bold cterm=bold ctermbg=37 ctermfg=21 gui=bold guibg=#008b8b guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=157 gui=bold guibg=#ff0000 guifg=#90ee90
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=231 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=16 ctermfg=196 gui=undercurl guibg=#000000 guifg=#90ee90 guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=16 ctermfg=21 gui=undercurl guibg=#000000 guifg=#90ee90 guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=16 ctermfg=201 gui=undercurl guibg=#000000 guifg=#90ee90 guisp=#ff00ff
elseif has("gui_running") || &t_Co == 256
    CSAHi Normal term=NONE cterm=NONE ctermbg=16 ctermfg=120 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi Identifier term=underline cterm=NONE ctermbg=16 ctermfg=51 gui=NONE guibg=#000000 guifg=#00ffff
    CSAHi PreProc term=underline cterm=NONE ctermbg=16 ctermfg=223 gui=NONE guibg=#000000 guifg=#f5deb3
    CSAHi Type term=underline cterm=NONE ctermbg=16 ctermfg=250 gui=NONE guibg=#000000 guifg=#bebebe
    CSAHi Underlined term=underline cterm=underline ctermbg=16 ctermfg=111 gui=underline guibg=#000000 guifg=#80a0ff
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=226 ctermfg=21 gui=NONE guibg=#ffff00 guifg=#0000ff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=16 ctermfg=51 gui=NONE guibg=#000000 guifg=#00ffff
    CSAHi NonText term=bold cterm=bold ctermbg=16 ctermfg=21 gui=bold guibg=#000000 guifg=#0000ff
    CSAHi Directory term=bold cterm=NONE ctermbg=16 ctermfg=51 gui=NONE guibg=#000000 guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=120 ctermfg=16 gui=reverse guibg=#000000 guifg=#90ee90
    CSAHi Search term=reverse cterm=NONE ctermbg=21 ctermfg=231 gui=NONE guibg=#0000ff guifg=#ffffff
    CSAHi MoreMsg term=bold cterm=bold ctermbg=16 ctermfg=29 gui=bold guibg=#000000 guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=16 ctermfg=120 gui=bold guibg=#000000 guifg=#90ee90
    CSAHi LineNr term=underline cterm=NONE ctermbg=16 ctermfg=226 gui=NONE guibg=#000000 guifg=#ffff00
    CSAHi Scrollbar term=NONE cterm=NONE ctermbg=16 ctermfg=120 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi Menu term=NONE cterm=NONE ctermbg=16 ctermfg=120 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=16 ctermfg=120 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi SpellErrors term=NONE cterm=NONE ctermbg=16 ctermfg=120 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=16 ctermfg=51 gui=undercurl guibg=#000000 guifg=#90ee90 guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=201 ctermfg=120 gui=NONE guibg=#ff00ff guifg=#90ee90
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=248 ctermfg=120 gui=NONE guibg=#a9a9a9 guifg=#90ee90
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=120 gui=NONE guibg=#bebebe guifg=#90ee90
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=120 ctermfg=16 gui=reverse guibg=#000000 guifg=#90ee90
    CSAHi TabLine term=underline cterm=underline ctermbg=248 ctermfg=120 gui=underline guibg=#a9a9a9 guifg=#90ee90
    CSAHi TabLineSel term=bold cterm=bold ctermbg=16 ctermfg=120 gui=bold guibg=#000000 guifg=#90ee90
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=120 ctermfg=16 gui=reverse guibg=#000000 guifg=#90ee90
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=241 ctermfg=120 gui=NONE guibg=#666666 guifg=#90ee90
    CSAHi CursorLine term=underline cterm=NONE ctermbg=241 ctermfg=120 gui=NONE guibg=#666666 guifg=#90ee90
    CSAHi Question term=NONE cterm=bold ctermbg=16 ctermfg=51 gui=bold guibg=#000000 guifg=#00ffff
    CSAHi StatusLine term=reverse,bold cterm=NONE ctermbg=18 ctermfg=231 gui=NONE guibg=#00008b guifg=#ffffff
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=236 ctermfg=231 gui=NONE guibg=#333333 guifg=#ffffff
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=120 ctermfg=16 gui=reverse guibg=#000000 guifg=#90ee90
    CSAHi Title term=bold cterm=bold ctermbg=16 ctermfg=218 gui=bold guibg=#000000 guifg=#ffc0cb
    CSAHi Visual term=reverse cterm=NONE ctermbg=22 ctermfg=231 gui=NONE guibg=#006400 guifg=#ffffff
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=16 ctermfg=120 gui=bold,underline guibg=#000000 guifg=#90ee90
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=16 ctermfg=196 gui=NONE guibg=#000000 guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=248 ctermfg=51 gui=NONE guibg=#a9a9a9 guifg=#00ffff
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=88 ctermfg=120 gui=NONE guibg=#8b0000 guifg=#90ee90
    CSAHi Cursor term=NONE cterm=NONE ctermbg=120 ctermfg=170 gui=NONE guibg=#90ee90 guifg=#da70d6
    CSAHi lCursor term=NONE cterm=NONE ctermbg=120 ctermfg=16 gui=NONE guibg=#90ee90 guifg=#000000
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=30 ctermfg=120 gui=NONE guibg=#008b8b guifg=#90ee90
    CSAHi Constant term=underline cterm=NONE ctermbg=16 ctermfg=231 gui=NONE guibg=#000000 guifg=#ffffff
    CSAHi Special term=bold cterm=NONE ctermbg=16 ctermfg=201 gui=NONE guibg=#000000 guifg=#ff00ff
    CSAHi Statement term=bold cterm=NONE ctermbg=16 ctermfg=226 gui=NONE guibg=#000000 guifg=#ffff00
    CSAHi Ignore term=NONE cterm=NONE ctermbg=16 ctermfg=16 gui=NONE guibg=#000000 guifg=#000000
    CSAHi Comment term=bold cterm=NONE ctermbg=16 ctermfg=214 gui=NONE guibg=#000000 guifg=#ffa500
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=18 ctermfg=120 gui=NONE guibg=#00008b guifg=#90ee90
    CSAHi DiffChange term=bold cterm=NONE ctermbg=90 ctermfg=120 gui=NONE guibg=#8b008b guifg=#90ee90
    CSAHi DiffDelete term=bold cterm=bold ctermbg=30 ctermfg=21 gui=bold guibg=#008b8b guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=120 gui=bold guibg=#ff0000 guifg=#90ee90
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=16 ctermfg=196 gui=undercurl guibg=#000000 guifg=#90ee90 guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=16 ctermfg=21 gui=undercurl guibg=#000000 guifg=#90ee90 guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=16 ctermfg=201 gui=undercurl guibg=#000000 guifg=#90ee90 guisp=#ff00ff
elseif has("gui_running") || &t_Co == 88
    CSAHi Normal term=NONE cterm=NONE ctermbg=16 ctermfg=45 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi Identifier term=underline cterm=NONE ctermbg=16 ctermfg=31 gui=NONE guibg=#000000 guifg=#00ffff
    CSAHi PreProc term=underline cterm=NONE ctermbg=16 ctermfg=74 gui=NONE guibg=#000000 guifg=#f5deb3
    CSAHi Type term=underline cterm=NONE ctermbg=16 ctermfg=85 gui=NONE guibg=#000000 guifg=#bebebe
    CSAHi Underlined term=underline cterm=underline ctermbg=16 ctermfg=39 gui=underline guibg=#000000 guifg=#80a0ff
    CSAHi Error term=reverse cterm=NONE ctermbg=64 ctermfg=79 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=76 ctermfg=19 gui=NONE guibg=#ffff00 guifg=#0000ff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=16 ctermfg=31 gui=NONE guibg=#000000 guifg=#00ffff
    CSAHi NonText term=bold cterm=bold ctermbg=16 ctermfg=19 gui=bold guibg=#000000 guifg=#0000ff
    CSAHi Directory term=bold cterm=NONE ctermbg=16 ctermfg=31 gui=NONE guibg=#000000 guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=64 ctermfg=79 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=45 ctermfg=16 gui=reverse guibg=#000000 guifg=#90ee90
    CSAHi Search term=reverse cterm=NONE ctermbg=19 ctermfg=79 gui=NONE guibg=#0000ff guifg=#ffffff
    CSAHi MoreMsg term=bold cterm=bold ctermbg=16 ctermfg=21 gui=bold guibg=#000000 guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=16 ctermfg=45 gui=bold guibg=#000000 guifg=#90ee90
    CSAHi LineNr term=underline cterm=NONE ctermbg=16 ctermfg=76 gui=NONE guibg=#000000 guifg=#ffff00
    CSAHi Scrollbar term=NONE cterm=NONE ctermbg=16 ctermfg=45 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi Menu term=NONE cterm=NONE ctermbg=16 ctermfg=45 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=16 ctermfg=45 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi SpellErrors term=NONE cterm=NONE ctermbg=16 ctermfg=45 gui=NONE guibg=#000000 guifg=#90ee90
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=16 ctermfg=31 gui=undercurl guibg=#000000 guifg=#90ee90 guisp=#00ffff
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=67 ctermfg=45 gui=NONE guibg=#ff00ff guifg=#90ee90
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=84 ctermfg=45 gui=NONE guibg=#a9a9a9 guifg=#90ee90
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=85 ctermfg=45 gui=NONE guibg=#bebebe guifg=#90ee90
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=45 ctermfg=16 gui=reverse guibg=#000000 guifg=#90ee90
    CSAHi TabLine term=underline cterm=underline ctermbg=84 ctermfg=45 gui=underline guibg=#a9a9a9 guifg=#90ee90
    CSAHi TabLineSel term=bold cterm=bold ctermbg=16 ctermfg=45 gui=bold guibg=#000000 guifg=#90ee90
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=45 ctermfg=16 gui=reverse guibg=#000000 guifg=#90ee90
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=81 ctermfg=45 gui=NONE guibg=#666666 guifg=#90ee90
    CSAHi CursorLine term=underline cterm=NONE ctermbg=81 ctermfg=45 gui=NONE guibg=#666666 guifg=#90ee90
    CSAHi Question term=NONE cterm=bold ctermbg=16 ctermfg=31 gui=bold guibg=#000000 guifg=#00ffff
    CSAHi StatusLine term=reverse,bold cterm=NONE ctermbg=17 ctermfg=79 gui=NONE guibg=#00008b guifg=#ffffff
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=80 ctermfg=79 gui=NONE guibg=#333333 guifg=#ffffff
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=45 ctermfg=16 gui=reverse guibg=#000000 guifg=#90ee90
    CSAHi Title term=bold cterm=bold ctermbg=16 ctermfg=74 gui=bold guibg=#000000 guifg=#ffc0cb
    CSAHi Visual term=reverse cterm=NONE ctermbg=20 ctermfg=79 gui=NONE guibg=#006400 guifg=#ffffff
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=16 ctermfg=45 gui=bold,underline guibg=#000000 guifg=#90ee90
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=16 ctermfg=64 gui=NONE guibg=#000000 guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=76 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=84 ctermfg=31 gui=NONE guibg=#a9a9a9 guifg=#00ffff
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=32 ctermfg=45 gui=NONE guibg=#8b0000 guifg=#90ee90
    CSAHi Cursor term=NONE cterm=NONE ctermbg=45 ctermfg=54 gui=NONE guibg=#90ee90 guifg=#da70d6
    CSAHi lCursor term=NONE cterm=NONE ctermbg=45 ctermfg=16 gui=NONE guibg=#90ee90 guifg=#000000
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=21 ctermfg=45 gui=NONE guibg=#008b8b guifg=#90ee90
    CSAHi Constant term=underline cterm=NONE ctermbg=16 ctermfg=79 gui=NONE guibg=#000000 guifg=#ffffff
    CSAHi Special term=bold cterm=NONE ctermbg=16 ctermfg=67 gui=NONE guibg=#000000 guifg=#ff00ff
    CSAHi Statement term=bold cterm=NONE ctermbg=16 ctermfg=76 gui=NONE guibg=#000000 guifg=#ffff00
    CSAHi Ignore term=NONE cterm=NONE ctermbg=16 ctermfg=16 gui=NONE guibg=#000000 guifg=#000000
    CSAHi Comment term=bold cterm=NONE ctermbg=16 ctermfg=68 gui=NONE guibg=#000000 guifg=#ffa500
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=85 ctermfg=31 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=17 ctermfg=45 gui=NONE guibg=#00008b guifg=#90ee90
    CSAHi DiffChange term=bold cterm=NONE ctermbg=33 ctermfg=45 gui=NONE guibg=#8b008b guifg=#90ee90
    CSAHi DiffDelete term=bold cterm=bold ctermbg=21 ctermfg=19 gui=bold guibg=#008b8b guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=64 ctermfg=45 gui=bold guibg=#ff0000 guifg=#90ee90
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=85 ctermfg=31 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi Conceal term=NONE cterm=NONE ctermbg=84 ctermfg=86 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=16 ctermfg=64 gui=undercurl guibg=#000000 guifg=#90ee90 guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=16 ctermfg=19 gui=undercurl guibg=#000000 guifg=#90ee90 guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=16 ctermfg=67 gui=undercurl guibg=#000000 guifg=#90ee90 guisp=#ff00ff
endif

if 1
    delcommand CSAHi
endif
