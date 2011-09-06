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
    CSAHi Normal term=NONE cterm=NONE ctermbg=224 ctermfg=16 gui=NONE guibg=#ffdab9 guifg=#000000
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=37 gui=NONE guibg=bg guifg=#008b8b
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=164 gui=NONE guibg=bg guifg=#cd00cd
    CSAHi Type term=underline cterm=bold ctermbg=bg ctermfg=72 gui=bold guibg=bg guifg=#2e8b57
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=104 gui=underline guibg=bg guifg=#6a5acd
    CSAHi Error term=reverse cterm=bold ctermbg=196 ctermfg=231 gui=bold guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=226 ctermfg=21 gui=NONE guibg=#ffff00 guifg=#0000ff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=21 gui=NONE guibg=bg guifg=#0000ff
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=21 gui=bold guibg=bg guifg=#0000ff
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=21 gui=NONE guibg=bg guifg=#0000ff
    CSAHi ErrorMsg term=NONE cterm=bold ctermbg=196 ctermfg=231 gui=bold guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=16 ctermfg=224 gui=reverse guibg=bg guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=220 ctermfg=fg gui=NONE guibg=#eec900 guifg=fg
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=72 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=160 gui=NONE guibg=bg guifg=#cd0000
    CSAHi Scrollbar term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Menu term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=37 gui=undercurl guibg=bg guifg=fg guisp=#008b8b
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=225 ctermfg=fg gui=NONE guibg=#ffbbff guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=16 ctermfg=224 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=252 ctermfg=fg gui=underline guibg=#d3d3d3 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=16 ctermfg=224 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=254 ctermfg=fg gui=NONE guibg=#e5e5e5 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=254 ctermfg=fg gui=NONE guibg=#e5e5e5 guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=72 gui=bold guibg=bg guifg=#2e8b57
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=16 ctermfg=231 gui=bold guibg=#000000 guifg=#ffffff
    CSAHi StatusLineNC term=reverse cterm=bold ctermbg=243 ctermfg=224 gui=bold guibg=#737373 guifg=#ffdab9
    CSAHi VertSplit term=reverse cterm=bold ctermbg=243 ctermfg=231 gui=bold guibg=#737373 guifg=#ffffff
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=162 gui=bold guibg=bg guifg=#cd1076
    CSAHi Visual term=reverse cterm=NONE ctermbg=188 ctermfg=16 gui=reverse guibg=#000000 guifg=#cccccc
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=bold ctermbg=bg ctermfg=196 gui=bold guibg=bg guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=187 ctermfg=16 gui=NONE guibg=#e3c1a5 guifg=#000000
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=224 ctermfg=fg gui=NONE guibg=#ffbbbb guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=16 ctermfg=224 gui=NONE guibg=#000000 guifg=#ffdab9
    CSAHi lCursor term=NONE cterm=NONE ctermbg=16 ctermfg=224 gui=NONE guibg=#000000 guifg=#ffdab9
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=51 ctermfg=fg gui=NONE guibg=#00ffff guifg=fg
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=162 gui=NONE guibg=bg guifg=#c00058
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=104 gui=NONE guibg=bg guifg=#6a5acd
    CSAHi Statement term=bold cterm=bold ctermbg=bg ctermfg=131 gui=bold guibg=bg guifg=#a52a2a
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=224 gui=NONE guibg=bg guifg=#ffdab9
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=67 gui=NONE guibg=bg guifg=#406090
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=188 ctermfg=19 gui=NONE guibg=#cccccc guifg=#00008b
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=231 ctermfg=fg gui=NONE guibg=#ffffff guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=224 ctermfg=fg gui=NONE guibg=#edb5cd guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=230 ctermfg=153 gui=bold guibg=#f6e8d0 guifg=#add8e6
    CSAHi DiffText term=reverse cterm=bold ctermbg=216 ctermfg=fg gui=bold guibg=#ff8060 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=19 gui=NONE guibg=#bebebe guifg=#00008b
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
    CSAHi Normal term=NONE cterm=NONE ctermbg=230 ctermfg=16 gui=NONE guibg=#ffdab9 guifg=#000000
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=37 gui=NONE guibg=bg guifg=#008b8b
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=201 gui=NONE guibg=bg guifg=#cd00cd
    CSAHi Type term=underline cterm=bold ctermbg=bg ctermfg=72 gui=bold guibg=bg guifg=#2e8b57
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=105 gui=underline guibg=bg guifg=#6a5acd
    CSAHi Error term=reverse cterm=bold ctermbg=196 ctermfg=255 gui=bold guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=226 ctermfg=21 gui=NONE guibg=#ffff00 guifg=#0000ff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=21 gui=NONE guibg=bg guifg=#0000ff
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=21 gui=bold guibg=bg guifg=#0000ff
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=21 gui=NONE guibg=bg guifg=#0000ff
    CSAHi ErrorMsg term=NONE cterm=bold ctermbg=196 ctermfg=255 gui=bold guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=16 ctermfg=230 gui=reverse guibg=bg guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=226 ctermfg=fg gui=NONE guibg=#eec900 guifg=fg
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=72 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=196 gui=NONE guibg=bg guifg=#cd0000
    CSAHi Scrollbar term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Menu term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=37 gui=undercurl guibg=bg guifg=fg guisp=#008b8b
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=225 ctermfg=fg gui=NONE guibg=#ffbbff guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=16 ctermfg=230 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=231 ctermfg=fg gui=underline guibg=#d3d3d3 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=16 ctermfg=230 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=254 ctermfg=fg gui=NONE guibg=#e5e5e5 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=254 ctermfg=fg gui=NONE guibg=#e5e5e5 guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=72 gui=bold guibg=bg guifg=#2e8b57
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=16 ctermfg=255 gui=bold guibg=#000000 guifg=#ffffff
    CSAHi StatusLineNC term=reverse cterm=bold ctermbg=243 ctermfg=230 gui=bold guibg=#737373 guifg=#ffdab9
    CSAHi VertSplit term=reverse cterm=bold ctermbg=243 ctermfg=255 gui=bold guibg=#737373 guifg=#ffffff
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=199 gui=bold guibg=bg guifg=#cd1076
    CSAHi Visual term=reverse cterm=NONE ctermbg=252 ctermfg=16 gui=reverse guibg=#000000 guifg=#cccccc
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=bold ctermbg=bg ctermfg=196 gui=bold guibg=bg guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=230 ctermfg=16 gui=NONE guibg=#e3c1a5 guifg=#000000
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=224 ctermfg=fg gui=NONE guibg=#ffbbbb guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=16 ctermfg=230 gui=NONE guibg=#000000 guifg=#ffdab9
    CSAHi lCursor term=NONE cterm=NONE ctermbg=16 ctermfg=230 gui=NONE guibg=#000000 guifg=#ffdab9
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=51 ctermfg=fg gui=NONE guibg=#00ffff guifg=fg
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=198 gui=NONE guibg=bg guifg=#c00058
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=105 gui=NONE guibg=bg guifg=#6a5acd
    CSAHi Statement term=bold cterm=bold ctermbg=bg ctermfg=167 gui=bold guibg=bg guifg=#a52a2a
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=230 gui=NONE guibg=bg guifg=#ffdab9
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=103 gui=NONE guibg=bg guifg=#406090
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=252 ctermfg=19 gui=NONE guibg=#cccccc guifg=#00008b
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=255 ctermfg=fg gui=NONE guibg=#ffffff guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=225 ctermfg=fg gui=NONE guibg=#edb5cd guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=231 ctermfg=195 gui=bold guibg=#f6e8d0 guifg=#add8e6
    CSAHi DiffText term=reverse cterm=bold ctermbg=216 ctermfg=fg gui=bold guibg=#ff8060 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=19 gui=NONE guibg=#bebebe guifg=#00008b
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=231 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
elseif has("gui_running") || &t_Co == 256
    CSAHi Normal term=NONE cterm=NONE ctermbg=223 ctermfg=16 gui=NONE guibg=#ffdab9 guifg=#000000
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=30 gui=NONE guibg=bg guifg=#008b8b
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=164 gui=NONE guibg=bg guifg=#cd00cd
    CSAHi Type term=underline cterm=bold ctermbg=bg ctermfg=29 gui=bold guibg=bg guifg=#2e8b57
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=62 gui=underline guibg=bg guifg=#6a5acd
    CSAHi Error term=reverse cterm=bold ctermbg=196 ctermfg=231 gui=bold guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=226 ctermfg=21 gui=NONE guibg=#ffff00 guifg=#0000ff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=21 gui=NONE guibg=bg guifg=#0000ff
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=21 gui=bold guibg=bg guifg=#0000ff
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=21 gui=NONE guibg=bg guifg=#0000ff
    CSAHi ErrorMsg term=NONE cterm=bold ctermbg=196 ctermfg=231 gui=bold guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=16 ctermfg=223 gui=reverse guibg=bg guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=220 ctermfg=fg gui=NONE guibg=#eec900 guifg=fg
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=29 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=160 gui=NONE guibg=bg guifg=#cd0000
    CSAHi Scrollbar term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Menu term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=30 gui=undercurl guibg=bg guifg=fg guisp=#008b8b
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=219 ctermfg=fg gui=NONE guibg=#ffbbff guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=16 ctermfg=223 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=252 ctermfg=fg gui=underline guibg=#d3d3d3 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=16 ctermfg=223 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=254 ctermfg=fg gui=NONE guibg=#e5e5e5 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=254 ctermfg=fg gui=NONE guibg=#e5e5e5 guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=29 gui=bold guibg=bg guifg=#2e8b57
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=16 ctermfg=231 gui=bold guibg=#000000 guifg=#ffffff
    CSAHi StatusLineNC term=reverse cterm=bold ctermbg=243 ctermfg=223 gui=bold guibg=#737373 guifg=#ffdab9
    CSAHi VertSplit term=reverse cterm=bold ctermbg=243 ctermfg=231 gui=bold guibg=#737373 guifg=#ffffff
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=162 gui=bold guibg=bg guifg=#cd1076
    CSAHi Visual term=reverse cterm=NONE ctermbg=252 ctermfg=16 gui=reverse guibg=#000000 guifg=#cccccc
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=bold ctermbg=bg ctermfg=196 gui=bold guibg=bg guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=181 ctermfg=16 gui=NONE guibg=#e3c1a5 guifg=#000000
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=217 ctermfg=fg gui=NONE guibg=#ffbbbb guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=16 ctermfg=223 gui=NONE guibg=#000000 guifg=#ffdab9
    CSAHi lCursor term=NONE cterm=NONE ctermbg=16 ctermfg=223 gui=NONE guibg=#000000 guifg=#ffdab9
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=51 ctermfg=fg gui=NONE guibg=#00ffff guifg=fg
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=125 gui=NONE guibg=bg guifg=#c00058
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=62 gui=NONE guibg=bg guifg=#6a5acd
    CSAHi Statement term=bold cterm=bold ctermbg=bg ctermfg=124 gui=bold guibg=bg guifg=#a52a2a
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=223 gui=NONE guibg=bg guifg=#ffdab9
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=60 gui=NONE guibg=bg guifg=#406090
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=252 ctermfg=18 gui=NONE guibg=#cccccc guifg=#00008b
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=231 ctermfg=fg gui=NONE guibg=#ffffff guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=218 ctermfg=fg gui=NONE guibg=#edb5cd guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=224 ctermfg=152 gui=bold guibg=#f6e8d0 guifg=#add8e6
    CSAHi DiffText term=reverse cterm=bold ctermbg=209 ctermfg=fg gui=bold guibg=#ff8060 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=18 gui=NONE guibg=#bebebe guifg=#00008b
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
elseif has("gui_running") || &t_Co == 88
    CSAHi Normal term=NONE cterm=NONE ctermbg=74 ctermfg=16 gui=NONE guibg=#ffdab9 guifg=#000000
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=21 gui=NONE guibg=bg guifg=#008b8b
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=50 gui=NONE guibg=bg guifg=#cd00cd
    CSAHi Type term=underline cterm=bold ctermbg=bg ctermfg=21 gui=bold guibg=bg guifg=#2e8b57
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=38 gui=underline guibg=bg guifg=#6a5acd
    CSAHi Error term=reverse cterm=bold ctermbg=64 ctermfg=79 gui=bold guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=76 ctermfg=19 gui=NONE guibg=#ffff00 guifg=#0000ff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=19 gui=NONE guibg=bg guifg=#0000ff
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=19 gui=bold guibg=bg guifg=#0000ff
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=19 gui=NONE guibg=bg guifg=#0000ff
    CSAHi ErrorMsg term=NONE cterm=bold ctermbg=64 ctermfg=79 gui=bold guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=16 ctermfg=74 gui=reverse guibg=bg guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=72 ctermfg=fg gui=NONE guibg=#eec900 guifg=fg
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=21 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=48 gui=NONE guibg=bg guifg=#cd0000
    CSAHi Scrollbar term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Menu term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=#008b8b
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=75 ctermfg=fg gui=NONE guibg=#ffbbff guifg=fg
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=85 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=85 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=16 ctermfg=74 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=86 ctermfg=fg gui=underline guibg=#d3d3d3 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=16 ctermfg=74 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=87 ctermfg=fg gui=NONE guibg=#e5e5e5 guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=87 ctermfg=fg gui=NONE guibg=#e5e5e5 guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=21 gui=bold guibg=bg guifg=#2e8b57
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=16 ctermfg=79 gui=bold guibg=#000000 guifg=#ffffff
    CSAHi StatusLineNC term=reverse cterm=bold ctermbg=82 ctermfg=74 gui=bold guibg=#737373 guifg=#ffdab9
    CSAHi VertSplit term=reverse cterm=bold ctermbg=82 ctermfg=79 gui=bold guibg=#737373 guifg=#ffffff
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=49 gui=bold guibg=bg guifg=#cd1076
    CSAHi Visual term=reverse cterm=NONE ctermbg=58 ctermfg=16 gui=reverse guibg=#000000 guifg=#cccccc
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=bold ctermbg=bg ctermfg=64 gui=bold guibg=bg guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=76 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=57 ctermfg=16 gui=NONE guibg=#e3c1a5 guifg=#000000
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=74 ctermfg=fg gui=NONE guibg=#ffbbbb guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=16 ctermfg=74 gui=NONE guibg=#000000 guifg=#ffdab9
    CSAHi lCursor term=NONE cterm=NONE ctermbg=16 ctermfg=74 gui=NONE guibg=#000000 guifg=#ffdab9
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=31 ctermfg=fg gui=NONE guibg=#00ffff guifg=fg
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=49 gui=NONE guibg=bg guifg=#c00058
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=38 gui=NONE guibg=bg guifg=#6a5acd
    CSAHi Statement term=bold cterm=bold ctermbg=bg ctermfg=32 gui=bold guibg=bg guifg=#a52a2a
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=74 gui=NONE guibg=bg guifg=#ffdab9
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=21 gui=NONE guibg=bg guifg=#406090
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=58 ctermfg=17 gui=NONE guibg=#cccccc guifg=#00008b
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=79 ctermfg=fg gui=NONE guibg=#ffffff guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=74 ctermfg=fg gui=NONE guibg=#edb5cd guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=78 ctermfg=58 gui=bold guibg=#f6e8d0 guifg=#add8e6
    CSAHi DiffText term=reverse cterm=bold ctermbg=69 ctermfg=fg gui=bold guibg=#ff8060 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=85 ctermfg=17 gui=NONE guibg=#bebebe guifg=#00008b
    CSAHi Conceal term=NONE cterm=NONE ctermbg=84 ctermfg=86 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=64 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=19 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=67 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
endif

if 1
    delcommand CSAHi
endif
