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
    CSAHi Normal term=NONE cterm=NONE ctermbg=231 ctermfg=16 gui=NONE guibg=#ffffff guifg=#000000
    CSAHi Identifier term=underline cterm=NONE ctermbg=231 ctermfg=37 gui=NONE guibg=#ffffff guifg=#008b8b
    CSAHi PreProc term=underline cterm=NONE ctermbg=231 ctermfg=135 gui=NONE guibg=#ffffff guifg=#a020f0
    CSAHi Type term=underline cterm=bold ctermbg=231 ctermfg=72 gui=bold guibg=#ffffff guifg=#2e8b57
    CSAHi Underlined term=underline cterm=underline ctermbg=231 ctermfg=104 gui=underline guibg=#ffffff guifg=#6a5acd
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=226 ctermfg=21 gui=NONE guibg=#ffff00 guifg=#0000ff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=231 ctermfg=21 gui=NONE guibg=#ffffff guifg=#0000ff
    CSAHi NonText term=bold cterm=bold ctermbg=231 ctermfg=21 gui=bold guibg=#ffffff guifg=#0000ff
    CSAHi Directory term=bold cterm=NONE ctermbg=231 ctermfg=21 gui=NONE guibg=#ffffff guifg=#0000ff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=16 ctermfg=231 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi Search term=reverse cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=231 ctermfg=72 gui=bold guibg=#ffffff guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=231 ctermfg=16 gui=bold guibg=#ffffff guifg=#000000
    CSAHi LineNr term=underline cterm=NONE ctermbg=231 ctermfg=131 gui=NONE guibg=#ffffff guifg=#a52a2a
    CSAHi Scrollbar term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Menu term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellErrors term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=231 ctermfg=37 gui=undercurl guibg=#ffffff guifg=#000000 guisp=#008b8b
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=225 ctermfg=16 gui=NONE guibg=#ffbbff guifg=#000000
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=250 ctermfg=16 gui=NONE guibg=#bebebe guifg=#000000
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=16 gui=NONE guibg=#bebebe guifg=#000000
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=16 ctermfg=231 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi TabLine term=underline cterm=underline ctermbg=252 ctermfg=16 gui=underline guibg=#d3d3d3 guifg=#000000
    CSAHi TabLineSel term=bold cterm=bold ctermbg=231 ctermfg=16 gui=bold guibg=#ffffff guifg=#000000
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=16 ctermfg=231 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=254 ctermfg=16 gui=NONE guibg=#e5e5e5 guifg=#000000
    CSAHi CursorLine term=underline cterm=NONE ctermbg=254 ctermfg=16 gui=NONE guibg=#e5e5e5 guifg=#000000
    CSAHi Question term=NONE cterm=bold ctermbg=231 ctermfg=72 gui=bold guibg=#ffffff guifg=#2e8b57
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=16 ctermfg=231 gui=reverse,bold guibg=#ffffff guifg=#000000
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=16 ctermfg=231 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=16 ctermfg=231 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi Title term=bold cterm=bold ctermbg=231 ctermfg=201 gui=bold guibg=#ffffff guifg=#ff00ff
    CSAHi Visual term=reverse cterm=NONE ctermbg=252 ctermfg=16 gui=NONE guibg=#d3d3d3 guifg=#000000
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=231 ctermfg=16 gui=bold,underline guibg=#ffffff guifg=#000000
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=231 ctermfg=196 gui=NONE guibg=#ffffff guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=252 ctermfg=19 gui=NONE guibg=#d3d3d3 guifg=#00008b
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=224 ctermfg=16 gui=NONE guibg=#ffbbbb guifg=#000000
    CSAHi Cursor term=NONE cterm=NONE ctermbg=16 ctermfg=231 gui=NONE guibg=#000000 guifg=#ffffff
    CSAHi lCursor term=NONE cterm=NONE ctermbg=16 ctermfg=231 gui=NONE guibg=#000000 guifg=#ffffff
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=51 ctermfg=16 gui=NONE guibg=#00ffff guifg=#000000
    CSAHi Constant term=underline cterm=NONE ctermbg=231 ctermfg=201 gui=NONE guibg=#ffffff guifg=#ff00ff
    CSAHi Special term=bold cterm=NONE ctermbg=231 ctermfg=104 gui=NONE guibg=#ffffff guifg=#6a5acd
    CSAHi Statement term=bold cterm=bold ctermbg=231 ctermfg=131 gui=bold guibg=#ffffff guifg=#a52a2a
    CSAHi Ignore term=NONE cterm=NONE ctermbg=231 ctermfg=231 gui=NONE guibg=#ffffff guifg=#ffffff
    CSAHi Comment term=bold cterm=NONE ctermbg=231 ctermfg=21 gui=NONE guibg=#ffffff guifg=#0000ff
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=250 ctermfg=19 gui=NONE guibg=#bebebe guifg=#00008b
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=153 ctermfg=16 gui=NONE guibg=#add8e6 guifg=#000000
    CSAHi DiffChange term=bold cterm=NONE ctermbg=225 ctermfg=16 gui=NONE guibg=#ffbbff guifg=#000000
    CSAHi DiffDelete term=bold cterm=bold ctermbg=195 ctermfg=21 gui=bold guibg=#e0ffff guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=16 gui=bold guibg=#ff0000 guifg=#000000
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=19 gui=NONE guibg=#bebebe guifg=#00008b
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=231 ctermfg=196 gui=undercurl guibg=#ffffff guifg=#000000 guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=231 ctermfg=21 gui=undercurl guibg=#ffffff guifg=#000000 guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=231 ctermfg=201 gui=undercurl guibg=#ffffff guifg=#000000 guisp=#ff00ff
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
    CSAHi Normal term=NONE cterm=NONE ctermbg=255 ctermfg=16 gui=NONE guibg=#ffffff guifg=#000000
    CSAHi Identifier term=underline cterm=NONE ctermbg=255 ctermfg=37 gui=NONE guibg=#ffffff guifg=#008b8b
    CSAHi PreProc term=underline cterm=NONE ctermbg=255 ctermfg=171 gui=NONE guibg=#ffffff guifg=#a020f0
    CSAHi Type term=underline cterm=bold ctermbg=255 ctermfg=72 gui=bold guibg=#ffffff guifg=#2e8b57
    CSAHi Underlined term=underline cterm=underline ctermbg=255 ctermfg=105 gui=underline guibg=#ffffff guifg=#6a5acd
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=255 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=226 ctermfg=21 gui=NONE guibg=#ffff00 guifg=#0000ff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=255 ctermfg=21 gui=NONE guibg=#ffffff guifg=#0000ff
    CSAHi NonText term=bold cterm=bold ctermbg=255 ctermfg=21 gui=bold guibg=#ffffff guifg=#0000ff
    CSAHi Directory term=bold cterm=NONE ctermbg=255 ctermfg=21 gui=NONE guibg=#ffffff guifg=#0000ff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=255 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=16 ctermfg=255 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi Search term=reverse cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=255 ctermfg=72 gui=bold guibg=#ffffff guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=255 ctermfg=16 gui=bold guibg=#ffffff guifg=#000000
    CSAHi LineNr term=underline cterm=NONE ctermbg=255 ctermfg=167 gui=NONE guibg=#ffffff guifg=#a52a2a
    CSAHi Scrollbar term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Menu term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellErrors term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=255 ctermfg=37 gui=undercurl guibg=#ffffff guifg=#000000 guisp=#008b8b
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=225 ctermfg=16 gui=NONE guibg=#ffbbff guifg=#000000
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=250 ctermfg=16 gui=NONE guibg=#bebebe guifg=#000000
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=16 gui=NONE guibg=#bebebe guifg=#000000
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=16 ctermfg=255 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi TabLine term=underline cterm=underline ctermbg=231 ctermfg=16 gui=underline guibg=#d3d3d3 guifg=#000000
    CSAHi TabLineSel term=bold cterm=bold ctermbg=255 ctermfg=16 gui=bold guibg=#ffffff guifg=#000000
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=16 ctermfg=255 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=254 ctermfg=16 gui=NONE guibg=#e5e5e5 guifg=#000000
    CSAHi CursorLine term=underline cterm=NONE ctermbg=254 ctermfg=16 gui=NONE guibg=#e5e5e5 guifg=#000000
    CSAHi Question term=NONE cterm=bold ctermbg=255 ctermfg=72 gui=bold guibg=#ffffff guifg=#2e8b57
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=16 ctermfg=255 gui=reverse,bold guibg=#ffffff guifg=#000000
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=16 ctermfg=255 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=16 ctermfg=255 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi Title term=bold cterm=bold ctermbg=255 ctermfg=201 gui=bold guibg=#ffffff guifg=#ff00ff
    CSAHi Visual term=reverse cterm=NONE ctermbg=231 ctermfg=16 gui=NONE guibg=#d3d3d3 guifg=#000000
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=255 ctermfg=16 gui=bold,underline guibg=#ffffff guifg=#000000
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=255 ctermfg=196 gui=NONE guibg=#ffffff guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=231 ctermfg=19 gui=NONE guibg=#d3d3d3 guifg=#00008b
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=224 ctermfg=16 gui=NONE guibg=#ffbbbb guifg=#000000
    CSAHi Cursor term=NONE cterm=NONE ctermbg=16 ctermfg=255 gui=NONE guibg=#000000 guifg=#ffffff
    CSAHi lCursor term=NONE cterm=NONE ctermbg=16 ctermfg=255 gui=NONE guibg=#000000 guifg=#ffffff
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=51 ctermfg=16 gui=NONE guibg=#00ffff guifg=#000000
    CSAHi Constant term=underline cterm=NONE ctermbg=255 ctermfg=201 gui=NONE guibg=#ffffff guifg=#ff00ff
    CSAHi Special term=bold cterm=NONE ctermbg=255 ctermfg=105 gui=NONE guibg=#ffffff guifg=#6a5acd
    CSAHi Statement term=bold cterm=bold ctermbg=255 ctermfg=167 gui=bold guibg=#ffffff guifg=#a52a2a
    CSAHi Ignore term=NONE cterm=NONE ctermbg=255 ctermfg=255 gui=NONE guibg=#ffffff guifg=#ffffff
    CSAHi Comment term=bold cterm=NONE ctermbg=255 ctermfg=21 gui=NONE guibg=#ffffff guifg=#0000ff
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=250 ctermfg=19 gui=NONE guibg=#bebebe guifg=#00008b
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=195 ctermfg=16 gui=NONE guibg=#add8e6 guifg=#000000
    CSAHi DiffChange term=bold cterm=NONE ctermbg=225 ctermfg=16 gui=NONE guibg=#ffbbff guifg=#000000
    CSAHi DiffDelete term=bold cterm=bold ctermbg=231 ctermfg=21 gui=bold guibg=#e0ffff guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=16 gui=bold guibg=#ff0000 guifg=#000000
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=19 gui=NONE guibg=#bebebe guifg=#00008b
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=231 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=255 ctermfg=196 gui=undercurl guibg=#ffffff guifg=#000000 guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=255 ctermfg=21 gui=undercurl guibg=#ffffff guifg=#000000 guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=255 ctermfg=201 gui=undercurl guibg=#ffffff guifg=#000000 guisp=#ff00ff
elseif has("gui_running") || &t_Co == 256
    CSAHi Normal term=NONE cterm=NONE ctermbg=231 ctermfg=16 gui=NONE guibg=#ffffff guifg=#000000
    CSAHi Identifier term=underline cterm=NONE ctermbg=231 ctermfg=30 gui=NONE guibg=#ffffff guifg=#008b8b
    CSAHi PreProc term=underline cterm=NONE ctermbg=231 ctermfg=129 gui=NONE guibg=#ffffff guifg=#a020f0
    CSAHi Type term=underline cterm=bold ctermbg=231 ctermfg=29 gui=bold guibg=#ffffff guifg=#2e8b57
    CSAHi Underlined term=underline cterm=underline ctermbg=231 ctermfg=62 gui=underline guibg=#ffffff guifg=#6a5acd
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=226 ctermfg=21 gui=NONE guibg=#ffff00 guifg=#0000ff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=231 ctermfg=21 gui=NONE guibg=#ffffff guifg=#0000ff
    CSAHi NonText term=bold cterm=bold ctermbg=231 ctermfg=21 gui=bold guibg=#ffffff guifg=#0000ff
    CSAHi Directory term=bold cterm=NONE ctermbg=231 ctermfg=21 gui=NONE guibg=#ffffff guifg=#0000ff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=16 ctermfg=231 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi Search term=reverse cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=231 ctermfg=29 gui=bold guibg=#ffffff guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=231 ctermfg=16 gui=bold guibg=#ffffff guifg=#000000
    CSAHi LineNr term=underline cterm=NONE ctermbg=231 ctermfg=124 gui=NONE guibg=#ffffff guifg=#a52a2a
    CSAHi Scrollbar term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Menu term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellErrors term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=231 ctermfg=30 gui=undercurl guibg=#ffffff guifg=#000000 guisp=#008b8b
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=219 ctermfg=16 gui=NONE guibg=#ffbbff guifg=#000000
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=250 ctermfg=16 gui=NONE guibg=#bebebe guifg=#000000
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=16 gui=NONE guibg=#bebebe guifg=#000000
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=16 ctermfg=231 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi TabLine term=underline cterm=underline ctermbg=252 ctermfg=16 gui=underline guibg=#d3d3d3 guifg=#000000
    CSAHi TabLineSel term=bold cterm=bold ctermbg=231 ctermfg=16 gui=bold guibg=#ffffff guifg=#000000
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=16 ctermfg=231 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=254 ctermfg=16 gui=NONE guibg=#e5e5e5 guifg=#000000
    CSAHi CursorLine term=underline cterm=NONE ctermbg=254 ctermfg=16 gui=NONE guibg=#e5e5e5 guifg=#000000
    CSAHi Question term=NONE cterm=bold ctermbg=231 ctermfg=29 gui=bold guibg=#ffffff guifg=#2e8b57
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=16 ctermfg=231 gui=reverse,bold guibg=#ffffff guifg=#000000
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=16 ctermfg=231 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=16 ctermfg=231 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi Title term=bold cterm=bold ctermbg=231 ctermfg=201 gui=bold guibg=#ffffff guifg=#ff00ff
    CSAHi Visual term=reverse cterm=NONE ctermbg=252 ctermfg=16 gui=NONE guibg=#d3d3d3 guifg=#000000
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=231 ctermfg=16 gui=bold,underline guibg=#ffffff guifg=#000000
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=231 ctermfg=196 gui=NONE guibg=#ffffff guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=252 ctermfg=18 gui=NONE guibg=#d3d3d3 guifg=#00008b
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=217 ctermfg=16 gui=NONE guibg=#ffbbbb guifg=#000000
    CSAHi Cursor term=NONE cterm=NONE ctermbg=16 ctermfg=231 gui=NONE guibg=#000000 guifg=#ffffff
    CSAHi lCursor term=NONE cterm=NONE ctermbg=16 ctermfg=231 gui=NONE guibg=#000000 guifg=#ffffff
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=51 ctermfg=16 gui=NONE guibg=#00ffff guifg=#000000
    CSAHi Constant term=underline cterm=NONE ctermbg=231 ctermfg=201 gui=NONE guibg=#ffffff guifg=#ff00ff
    CSAHi Special term=bold cterm=NONE ctermbg=231 ctermfg=62 gui=NONE guibg=#ffffff guifg=#6a5acd
    CSAHi Statement term=bold cterm=bold ctermbg=231 ctermfg=124 gui=bold guibg=#ffffff guifg=#a52a2a
    CSAHi Ignore term=NONE cterm=NONE ctermbg=231 ctermfg=231 gui=NONE guibg=#ffffff guifg=#ffffff
    CSAHi Comment term=bold cterm=NONE ctermbg=231 ctermfg=21 gui=NONE guibg=#ffffff guifg=#0000ff
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=250 ctermfg=18 gui=NONE guibg=#bebebe guifg=#00008b
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=152 ctermfg=16 gui=NONE guibg=#add8e6 guifg=#000000
    CSAHi DiffChange term=bold cterm=NONE ctermbg=219 ctermfg=16 gui=NONE guibg=#ffbbff guifg=#000000
    CSAHi DiffDelete term=bold cterm=bold ctermbg=195 ctermfg=21 gui=bold guibg=#e0ffff guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=16 gui=bold guibg=#ff0000 guifg=#000000
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=18 gui=NONE guibg=#bebebe guifg=#00008b
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=231 ctermfg=196 gui=undercurl guibg=#ffffff guifg=#000000 guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=231 ctermfg=21 gui=undercurl guibg=#ffffff guifg=#000000 guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=231 ctermfg=201 gui=undercurl guibg=#ffffff guifg=#000000 guisp=#ff00ff
elseif has("gui_running") || &t_Co == 88
    CSAHi Normal term=NONE cterm=NONE ctermbg=79 ctermfg=16 gui=NONE guibg=#ffffff guifg=#000000
    CSAHi Identifier term=underline cterm=NONE ctermbg=79 ctermfg=21 gui=NONE guibg=#ffffff guifg=#008b8b
    CSAHi PreProc term=underline cterm=NONE ctermbg=79 ctermfg=35 gui=NONE guibg=#ffffff guifg=#a020f0
    CSAHi Type term=underline cterm=bold ctermbg=79 ctermfg=21 gui=bold guibg=#ffffff guifg=#2e8b57
    CSAHi Underlined term=underline cterm=underline ctermbg=79 ctermfg=38 gui=underline guibg=#ffffff guifg=#6a5acd
    CSAHi Error term=reverse cterm=NONE ctermbg=64 ctermfg=79 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=76 ctermfg=19 gui=NONE guibg=#ffff00 guifg=#0000ff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=79 ctermfg=19 gui=NONE guibg=#ffffff guifg=#0000ff
    CSAHi NonText term=bold cterm=bold ctermbg=79 ctermfg=19 gui=bold guibg=#ffffff guifg=#0000ff
    CSAHi Directory term=bold cterm=NONE ctermbg=79 ctermfg=19 gui=NONE guibg=#ffffff guifg=#0000ff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=64 ctermfg=79 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=16 ctermfg=79 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi Search term=reverse cterm=NONE ctermbg=76 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=79 ctermfg=21 gui=bold guibg=#ffffff guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=79 ctermfg=16 gui=bold guibg=#ffffff guifg=#000000
    CSAHi LineNr term=underline cterm=NONE ctermbg=79 ctermfg=32 gui=NONE guibg=#ffffff guifg=#a52a2a
    CSAHi Scrollbar term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Menu term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cIf0 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellErrors term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=79 ctermfg=21 gui=undercurl guibg=#ffffff guifg=#000000 guisp=#008b8b
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=75 ctermfg=16 gui=NONE guibg=#ffbbff guifg=#000000
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=85 ctermfg=16 gui=NONE guibg=#bebebe guifg=#000000
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=85 ctermfg=16 gui=NONE guibg=#bebebe guifg=#000000
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=16 ctermfg=79 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi TabLine term=underline cterm=underline ctermbg=86 ctermfg=16 gui=underline guibg=#d3d3d3 guifg=#000000
    CSAHi TabLineSel term=bold cterm=bold ctermbg=79 ctermfg=16 gui=bold guibg=#ffffff guifg=#000000
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=16 ctermfg=79 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=87 ctermfg=16 gui=NONE guibg=#e5e5e5 guifg=#000000
    CSAHi CursorLine term=underline cterm=NONE ctermbg=87 ctermfg=16 gui=NONE guibg=#e5e5e5 guifg=#000000
    CSAHi Question term=NONE cterm=bold ctermbg=79 ctermfg=21 gui=bold guibg=#ffffff guifg=#2e8b57
    CSAHi StatusLine term=reverse,bold cterm=bold ctermbg=16 ctermfg=79 gui=reverse,bold guibg=#ffffff guifg=#000000
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=16 ctermfg=79 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=16 ctermfg=79 gui=reverse guibg=#ffffff guifg=#000000
    CSAHi Title term=bold cterm=bold ctermbg=79 ctermfg=67 gui=bold guibg=#ffffff guifg=#ff00ff
    CSAHi Visual term=reverse cterm=NONE ctermbg=86 ctermfg=16 gui=NONE guibg=#d3d3d3 guifg=#000000
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=79 ctermfg=16 gui=bold,underline guibg=#ffffff guifg=#000000
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=79 ctermfg=64 gui=NONE guibg=#ffffff guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=76 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=86 ctermfg=17 gui=NONE guibg=#d3d3d3 guifg=#00008b
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=74 ctermfg=16 gui=NONE guibg=#ffbbbb guifg=#000000
    CSAHi Cursor term=NONE cterm=NONE ctermbg=16 ctermfg=79 gui=NONE guibg=#000000 guifg=#ffffff
    CSAHi lCursor term=NONE cterm=NONE ctermbg=16 ctermfg=79 gui=NONE guibg=#000000 guifg=#ffffff
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=31 ctermfg=16 gui=NONE guibg=#00ffff guifg=#000000
    CSAHi Constant term=underline cterm=NONE ctermbg=79 ctermfg=67 gui=NONE guibg=#ffffff guifg=#ff00ff
    CSAHi Special term=bold cterm=NONE ctermbg=79 ctermfg=38 gui=NONE guibg=#ffffff guifg=#6a5acd
    CSAHi Statement term=bold cterm=bold ctermbg=79 ctermfg=32 gui=bold guibg=#ffffff guifg=#a52a2a
    CSAHi Ignore term=NONE cterm=NONE ctermbg=79 ctermfg=79 gui=NONE guibg=#ffffff guifg=#ffffff
    CSAHi Comment term=bold cterm=NONE ctermbg=79 ctermfg=19 gui=NONE guibg=#ffffff guifg=#0000ff
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=85 ctermfg=17 gui=NONE guibg=#bebebe guifg=#00008b
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=58 ctermfg=16 gui=NONE guibg=#add8e6 guifg=#000000
    CSAHi DiffChange term=bold cterm=NONE ctermbg=75 ctermfg=16 gui=NONE guibg=#ffbbff guifg=#000000
    CSAHi DiffDelete term=bold cterm=bold ctermbg=63 ctermfg=19 gui=bold guibg=#e0ffff guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=64 ctermfg=16 gui=bold guibg=#ff0000 guifg=#000000
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=85 ctermfg=17 gui=NONE guibg=#bebebe guifg=#00008b
    CSAHi Conceal term=NONE cterm=NONE ctermbg=84 ctermfg=86 gui=NONE guibg=#a9a9a9 guifg=#d3d3d3
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=79 ctermfg=64 gui=undercurl guibg=#ffffff guifg=#000000 guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=79 ctermfg=19 gui=undercurl guibg=#ffffff guifg=#000000 guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=79 ctermfg=67 gui=undercurl guibg=#ffffff guifg=#000000 guisp=#ff00ff
endif

if 1
    delcommand CSAHi
endif
