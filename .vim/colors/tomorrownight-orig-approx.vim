" This scheme was created by CSApproxSnapshot
" on Sat, 21 Jan 2012

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

function! s:old_kde()
  " Konsole only used its own palette up til KDE 4.2.0
  if executable('kde4-config') && system('kde4-config --kde-version') =~ '^4.[10].'
    return 1
  elseif executable('kde-config') && system('kde-config --version') =~# 'KDE: 3.'
    return 1
  else
    return 0
  endif
endfunction

if 0
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_konsole") && g:CSApprox_konsole) || (&term =~? "^konsole" && s:old_kde())
    CSAHi Normal term=NONE cterm=NONE ctermbg=236 ctermfg=251 gui=NONE guibg=#303030 guifg=#c5c8c6
    CSAHi diffRemoved term=NONE cterm=NONE ctermbg=bg ctermfg=167 gui=NONE guibg=bg guifg=#cc6666
    CSAHi javaScriptFunction term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi javaScriptConditional term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi Type term=underline cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=111 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=236 gui=NONE guibg=bg guifg=bg
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=Red guifg=White
    CSAHi Todo term=NONE cterm=NONE ctermbg=236 ctermfg=246 gui=NONE guibg=#303030 guifg=#969896
    CSAHi String term=NONE cterm=NONE ctermbg=bg ctermfg=143 gui=NONE guibg=bg guifg=#b5bd68
    CSAHi javaScriptNumber term=NONE cterm=NONE ctermbg=bg ctermfg=173 gui=NONE guibg=bg guifg=#de935f
    CSAHi Include term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi javaScriptMember term=NONE cterm=NONE ctermbg=bg ctermfg=173 gui=NONE guibg=bg guifg=#de935f
    CSAHi Define term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi diffAdded term=NONE cterm=NONE ctermbg=bg ctermfg=143 gui=NONE guibg=bg guifg=#b5bd68
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=240 gui=NONE guibg=bg guifg=#585858
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=240 gui=bold guibg=bg guifg=#585858
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=Red guifg=White
    CSAHi IncSearch term=reverse cterm=reverse ctermbg=bg ctermfg=fg gui=reverse guibg=bg guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=222 ctermfg=236 gui=NONE guibg=#f0c674 guifg=#303030
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=143 gui=bold guibg=bg guifg=#b5bd68
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=143 gui=bold guibg=bg guifg=#b5bd68
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=240 gui=NONE guibg=bg guifg=#585858
    CSAHi rubyRepeat term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi pythonInclude term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi vimCommand term=NONE cterm=NONE ctermbg=bg ctermfg=167 gui=NONE guibg=bg guifg=#cc6666
    CSAHi cType term=NONE cterm=NONE ctermbg=bg ctermfg=222 gui=NONE guibg=bg guifg=#f0c674
    CSAHi cStorageClass term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpVarSelector term=NONE cterm=NONE ctermbg=bg ctermfg=167 gui=NONE guibg=bg guifg=#cc6666
    CSAHi phpKeyword term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpRepeat term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpConditional term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=30 gui=undercurl guibg=bg guifg=fg guisp=DarkCyan
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=240 ctermfg=251 gui=NONE guibg=#585858 guifg=#c5c8c6
    CSAHi PmenuSel term=NONE cterm=reverse ctermbg=240 ctermfg=251 gui=reverse guibg=#585858 guifg=#c5c8c6
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=Grey guifg=fg
    CSAHi PmenuThumb term=NONE cterm=reverse ctermbg=bg ctermfg=fg gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=reverse ctermbg=236 ctermfg=251 gui=reverse guibg=#303030 guifg=#c5c8c6
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=reverse ctermbg=bg ctermfg=fg gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=237 ctermfg=fg gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=237 ctermfg=fg gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi Function term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi Conditional term=NONE cterm=NONE ctermbg=bg ctermfg=251 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi Repeat term=NONE cterm=NONE ctermbg=bg ctermfg=251 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi Operator term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#8abeb7
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=143 gui=bold guibg=bg guifg=#b5bd68
    CSAHi StatusLine term=bold,reverse cterm=reverse ctermbg=222 ctermfg=59 gui=reverse guibg=#f0c674 guifg=#5e5e5e
    CSAHi StatusLineNC term=reverse cterm=reverse ctermbg=251 ctermfg=59 gui=reverse guibg=#c5c8c6 guifg=#5e5e5e
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=59 ctermfg=59 gui=NONE guibg=#5e5e5e guifg=#5e5e5e
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=246 gui=bold guibg=bg guifg=#969896
    CSAHi Visual term=reverse cterm=NONE ctermbg=240 ctermfg=fg gui=NONE guibg=#585858 guifg=fg
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=167 gui=NONE guibg=bg guifg=#cc6666
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=Yellow guifg=Black
    CSAHi Folded term=NONE cterm=NONE ctermbg=236 ctermfg=246 gui=NONE guibg=#303030 guifg=#969896
    CSAHi javaScriptRepeat term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi pythonStatement term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi pythonConditional term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi pythonFunction term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi javaScriptBraces term=NONE cterm=NONE ctermbg=bg ctermfg=251 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi rubyConstant term=NONE cterm=NONE ctermbg=bg ctermfg=222 gui=NONE guibg=bg guifg=#f0c674
    CSAHi rubyAttribute term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi rubyInclude term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi rubyLocalVariableOrMethod term=NONE cterm=NONE ctermbg=bg ctermfg=173 gui=NONE guibg=bg guifg=#de935f
    CSAHi rubyCurlyBlock term=NONE cterm=NONE ctermbg=bg ctermfg=173 gui=NONE guibg=bg guifg=#de935f
    CSAHi rubyStringDelimiter term=NONE cterm=NONE ctermbg=bg ctermfg=143 gui=NONE guibg=bg guifg=#b5bd68
    CSAHi rubyInterpolationDelimiter term=NONE cterm=NONE ctermbg=bg ctermfg=173 gui=NONE guibg=bg guifg=#de935f
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=237 ctermfg=fg gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=251 ctermfg=236 gui=NONE guibg=fg guifg=bg
    CSAHi lCursor term=NONE cterm=NONE ctermbg=251 ctermfg=236 gui=NONE guibg=fg guifg=bg
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=240 ctermfg=fg gui=NONE guibg=#585858 guifg=fg
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=246 gui=NONE guibg=bg guifg=#969896
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=173 gui=NONE guibg=bg guifg=#de935f
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=251 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=167 gui=NONE guibg=bg guifg=#cc6666
    CSAHi Statement term=bold cterm=bold ctermbg=bg ctermfg=251 gui=bold guibg=bg guifg=#c5c8c6
    CSAHi rubyConditional term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpStatement term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpMemberSelector term=NONE cterm=NONE ctermbg=bg ctermfg=251 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi Structure term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi rubySymbol term=NONE cterm=NONE ctermbg=bg ctermfg=143 gui=NONE guibg=bg guifg=#b5bd68
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=236 ctermfg=51 gui=NONE guibg=#303030 guifg=Cyan
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=152 ctermfg=fg gui=NONE guibg=LightBlue guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=219 ctermfg=fg gui=NONE guibg=LightMagenta guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=195 ctermfg=21 gui=bold guibg=LightCyan guifg=Blue
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=fg gui=bold guibg=Red guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=18 gui=NONE guibg=Grey guifg=DarkBlue
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=Red
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=Blue
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=Magenta
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
    CSAHi Normal term=NONE cterm=NONE ctermbg=236 ctermfg=251 gui=NONE guibg=#303030 guifg=#c5c8c6
    CSAHi diffRemoved term=NONE cterm=NONE ctermbg=bg ctermfg=167 gui=NONE guibg=bg guifg=#cc6666
    CSAHi javaScriptFunction term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi javaScriptConditional term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi Type term=underline cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=111 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=236 gui=NONE guibg=bg guifg=bg
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=Red guifg=White
    CSAHi Todo term=NONE cterm=NONE ctermbg=236 ctermfg=246 gui=NONE guibg=#303030 guifg=#969896
    CSAHi String term=NONE cterm=NONE ctermbg=bg ctermfg=143 gui=NONE guibg=bg guifg=#b5bd68
    CSAHi javaScriptNumber term=NONE cterm=NONE ctermbg=bg ctermfg=173 gui=NONE guibg=bg guifg=#de935f
    CSAHi Include term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi javaScriptMember term=NONE cterm=NONE ctermbg=bg ctermfg=173 gui=NONE guibg=bg guifg=#de935f
    CSAHi Define term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi diffAdded term=NONE cterm=NONE ctermbg=bg ctermfg=143 gui=NONE guibg=bg guifg=#b5bd68
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=240 gui=NONE guibg=bg guifg=#585858
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=240 gui=bold guibg=bg guifg=#585858
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=Red guifg=White
    CSAHi IncSearch term=reverse cterm=reverse ctermbg=bg ctermfg=fg gui=reverse guibg=bg guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=222 ctermfg=236 gui=NONE guibg=#f0c674 guifg=#303030
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=143 gui=bold guibg=bg guifg=#b5bd68
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=143 gui=bold guibg=bg guifg=#b5bd68
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=240 gui=NONE guibg=bg guifg=#585858
    CSAHi rubyRepeat term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi pythonInclude term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi vimCommand term=NONE cterm=NONE ctermbg=bg ctermfg=167 gui=NONE guibg=bg guifg=#cc6666
    CSAHi cType term=NONE cterm=NONE ctermbg=bg ctermfg=222 gui=NONE guibg=bg guifg=#f0c674
    CSAHi cStorageClass term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpVarSelector term=NONE cterm=NONE ctermbg=bg ctermfg=167 gui=NONE guibg=bg guifg=#cc6666
    CSAHi phpKeyword term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpRepeat term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpConditional term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=30 gui=undercurl guibg=bg guifg=fg guisp=DarkCyan
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=240 ctermfg=251 gui=NONE guibg=#585858 guifg=#c5c8c6
    CSAHi PmenuSel term=NONE cterm=reverse ctermbg=240 ctermfg=251 gui=reverse guibg=#585858 guifg=#c5c8c6
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=Grey guifg=fg
    CSAHi PmenuThumb term=NONE cterm=reverse ctermbg=bg ctermfg=fg gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=reverse ctermbg=236 ctermfg=251 gui=reverse guibg=#303030 guifg=#c5c8c6
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=reverse ctermbg=bg ctermfg=fg gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=237 ctermfg=fg gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=237 ctermfg=fg gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi Function term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi Conditional term=NONE cterm=NONE ctermbg=bg ctermfg=251 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi Repeat term=NONE cterm=NONE ctermbg=bg ctermfg=251 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi Operator term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#8abeb7
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=143 gui=bold guibg=bg guifg=#b5bd68
    CSAHi StatusLine term=bold,reverse cterm=reverse ctermbg=222 ctermfg=59 gui=reverse guibg=#f0c674 guifg=#5e5e5e
    CSAHi StatusLineNC term=reverse cterm=reverse ctermbg=251 ctermfg=59 gui=reverse guibg=#c5c8c6 guifg=#5e5e5e
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=59 ctermfg=59 gui=NONE guibg=#5e5e5e guifg=#5e5e5e
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=246 gui=bold guibg=bg guifg=#969896
    CSAHi Visual term=reverse cterm=NONE ctermbg=240 ctermfg=fg gui=NONE guibg=#585858 guifg=fg
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=167 gui=NONE guibg=bg guifg=#cc6666
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=Yellow guifg=Black
    CSAHi Folded term=NONE cterm=NONE ctermbg=236 ctermfg=246 gui=NONE guibg=#303030 guifg=#969896
    CSAHi javaScriptRepeat term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi pythonStatement term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi pythonConditional term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi pythonFunction term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi javaScriptBraces term=NONE cterm=NONE ctermbg=bg ctermfg=251 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi rubyConstant term=NONE cterm=NONE ctermbg=bg ctermfg=222 gui=NONE guibg=bg guifg=#f0c674
    CSAHi rubyAttribute term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi rubyInclude term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi rubyLocalVariableOrMethod term=NONE cterm=NONE ctermbg=bg ctermfg=173 gui=NONE guibg=bg guifg=#de935f
    CSAHi rubyCurlyBlock term=NONE cterm=NONE ctermbg=bg ctermfg=173 gui=NONE guibg=bg guifg=#de935f
    CSAHi rubyStringDelimiter term=NONE cterm=NONE ctermbg=bg ctermfg=143 gui=NONE guibg=bg guifg=#b5bd68
    CSAHi rubyInterpolationDelimiter term=NONE cterm=NONE ctermbg=bg ctermfg=173 gui=NONE guibg=bg guifg=#de935f
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=237 ctermfg=fg gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=251 ctermfg=236 gui=NONE guibg=fg guifg=bg
    CSAHi lCursor term=NONE cterm=NONE ctermbg=251 ctermfg=236 gui=NONE guibg=fg guifg=bg
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=240 ctermfg=fg gui=NONE guibg=#585858 guifg=fg
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=246 gui=NONE guibg=bg guifg=#969896
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=173 gui=NONE guibg=bg guifg=#de935f
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=251 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=167 gui=NONE guibg=bg guifg=#cc6666
    CSAHi Statement term=bold cterm=bold ctermbg=bg ctermfg=251 gui=bold guibg=bg guifg=#c5c8c6
    CSAHi rubyConditional term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpStatement term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpMemberSelector term=NONE cterm=NONE ctermbg=bg ctermfg=251 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi Structure term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi rubySymbol term=NONE cterm=NONE ctermbg=bg ctermfg=143 gui=NONE guibg=bg guifg=#b5bd68
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=236 ctermfg=51 gui=NONE guibg=#303030 guifg=Cyan
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=152 ctermfg=fg gui=NONE guibg=LightBlue guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=219 ctermfg=fg gui=NONE guibg=LightMagenta guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=195 ctermfg=21 gui=bold guibg=LightCyan guifg=Blue
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=fg gui=bold guibg=Red guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=18 gui=NONE guibg=Grey guifg=DarkBlue
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=Red
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=Blue
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=Magenta
elseif has("gui_running") || &t_Co == 256
    CSAHi Normal term=NONE cterm=NONE ctermbg=236 ctermfg=251 gui=NONE guibg=#303030 guifg=#c5c8c6
    CSAHi diffRemoved term=NONE cterm=NONE ctermbg=bg ctermfg=167 gui=NONE guibg=bg guifg=#cc6666
    CSAHi javaScriptFunction term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi javaScriptConditional term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi Type term=underline cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=111 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=236 gui=NONE guibg=bg guifg=bg
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=Red guifg=White
    CSAHi Todo term=NONE cterm=NONE ctermbg=236 ctermfg=246 gui=NONE guibg=#303030 guifg=#969896
    CSAHi String term=NONE cterm=NONE ctermbg=bg ctermfg=143 gui=NONE guibg=bg guifg=#b5bd68
    CSAHi javaScriptNumber term=NONE cterm=NONE ctermbg=bg ctermfg=173 gui=NONE guibg=bg guifg=#de935f
    CSAHi Include term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi javaScriptMember term=NONE cterm=NONE ctermbg=bg ctermfg=173 gui=NONE guibg=bg guifg=#de935f
    CSAHi Define term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi diffAdded term=NONE cterm=NONE ctermbg=bg ctermfg=143 gui=NONE guibg=bg guifg=#b5bd68
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=240 gui=NONE guibg=bg guifg=#585858
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=240 gui=bold guibg=bg guifg=#585858
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=Red guifg=White
    CSAHi IncSearch term=reverse cterm=reverse ctermbg=bg ctermfg=fg gui=reverse guibg=bg guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=222 ctermfg=236 gui=NONE guibg=#f0c674 guifg=#303030
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=143 gui=bold guibg=bg guifg=#b5bd68
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=143 gui=bold guibg=bg guifg=#b5bd68
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=240 gui=NONE guibg=bg guifg=#585858
    CSAHi rubyRepeat term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi pythonInclude term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi vimCommand term=NONE cterm=NONE ctermbg=bg ctermfg=167 gui=NONE guibg=bg guifg=#cc6666
    CSAHi cType term=NONE cterm=NONE ctermbg=bg ctermfg=222 gui=NONE guibg=bg guifg=#f0c674
    CSAHi cStorageClass term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpVarSelector term=NONE cterm=NONE ctermbg=bg ctermfg=167 gui=NONE guibg=bg guifg=#cc6666
    CSAHi phpKeyword term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpRepeat term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpConditional term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=30 gui=undercurl guibg=bg guifg=fg guisp=DarkCyan
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=240 ctermfg=251 gui=NONE guibg=#585858 guifg=#c5c8c6
    CSAHi PmenuSel term=NONE cterm=reverse ctermbg=240 ctermfg=251 gui=reverse guibg=#585858 guifg=#c5c8c6
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=Grey guifg=fg
    CSAHi PmenuThumb term=NONE cterm=reverse ctermbg=bg ctermfg=fg gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=reverse ctermbg=236 ctermfg=251 gui=reverse guibg=#303030 guifg=#c5c8c6
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=reverse ctermbg=bg ctermfg=fg gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=237 ctermfg=fg gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=237 ctermfg=fg gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi Function term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi Conditional term=NONE cterm=NONE ctermbg=bg ctermfg=251 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi Repeat term=NONE cterm=NONE ctermbg=bg ctermfg=251 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi Operator term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#8abeb7
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=143 gui=bold guibg=bg guifg=#b5bd68
    CSAHi StatusLine term=bold,reverse cterm=reverse ctermbg=222 ctermfg=59 gui=reverse guibg=#f0c674 guifg=#5e5e5e
    CSAHi StatusLineNC term=reverse cterm=reverse ctermbg=251 ctermfg=59 gui=reverse guibg=#c5c8c6 guifg=#5e5e5e
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=59 ctermfg=59 gui=NONE guibg=#5e5e5e guifg=#5e5e5e
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=246 gui=bold guibg=bg guifg=#969896
    CSAHi Visual term=reverse cterm=NONE ctermbg=240 ctermfg=fg gui=NONE guibg=#585858 guifg=fg
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=167 gui=NONE guibg=bg guifg=#cc6666
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=Yellow guifg=Black
    CSAHi Folded term=NONE cterm=NONE ctermbg=236 ctermfg=246 gui=NONE guibg=#303030 guifg=#969896
    CSAHi javaScriptRepeat term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi pythonStatement term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi pythonConditional term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi pythonFunction term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi javaScriptBraces term=NONE cterm=NONE ctermbg=bg ctermfg=251 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi rubyConstant term=NONE cterm=NONE ctermbg=bg ctermfg=222 gui=NONE guibg=bg guifg=#f0c674
    CSAHi rubyAttribute term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi rubyInclude term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#81a2be
    CSAHi rubyLocalVariableOrMethod term=NONE cterm=NONE ctermbg=bg ctermfg=173 gui=NONE guibg=bg guifg=#de935f
    CSAHi rubyCurlyBlock term=NONE cterm=NONE ctermbg=bg ctermfg=173 gui=NONE guibg=bg guifg=#de935f
    CSAHi rubyStringDelimiter term=NONE cterm=NONE ctermbg=bg ctermfg=143 gui=NONE guibg=bg guifg=#b5bd68
    CSAHi rubyInterpolationDelimiter term=NONE cterm=NONE ctermbg=bg ctermfg=173 gui=NONE guibg=bg guifg=#de935f
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=237 ctermfg=fg gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=251 ctermfg=236 gui=NONE guibg=fg guifg=bg
    CSAHi lCursor term=NONE cterm=NONE ctermbg=251 ctermfg=236 gui=NONE guibg=fg guifg=bg
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=240 ctermfg=fg gui=NONE guibg=#585858 guifg=fg
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=246 gui=NONE guibg=bg guifg=#969896
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=173 gui=NONE guibg=bg guifg=#de935f
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=251 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=167 gui=NONE guibg=bg guifg=#cc6666
    CSAHi Statement term=bold cterm=bold ctermbg=bg ctermfg=251 gui=bold guibg=bg guifg=#c5c8c6
    CSAHi rubyConditional term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpStatement term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpMemberSelector term=NONE cterm=NONE ctermbg=bg ctermfg=251 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi Structure term=NONE cterm=NONE ctermbg=bg ctermfg=139 gui=NONE guibg=bg guifg=#b294bb
    CSAHi rubySymbol term=NONE cterm=NONE ctermbg=bg ctermfg=143 gui=NONE guibg=bg guifg=#b5bd68
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=236 ctermfg=51 gui=NONE guibg=#303030 guifg=Cyan
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=152 ctermfg=fg gui=NONE guibg=LightBlue guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=219 ctermfg=fg gui=NONE guibg=LightMagenta guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=195 ctermfg=21 gui=bold guibg=LightCyan guifg=Blue
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=fg gui=bold guibg=Red guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=18 gui=NONE guibg=Grey guifg=DarkBlue
    CSAHi Conceal term=NONE cterm=NONE ctermbg=248 ctermfg=252 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=Red
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=Blue
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=Magenta
elseif has("gui_running") || &t_Co == 88
    CSAHi Normal term=NONE cterm=NONE ctermbg=80 ctermfg=58 gui=NONE guibg=#303030 guifg=#c5c8c6
    CSAHi diffRemoved term=NONE cterm=NONE ctermbg=bg ctermfg=53 gui=NONE guibg=bg guifg=#cc6666
    CSAHi javaScriptFunction term=NONE cterm=NONE ctermbg=bg ctermfg=54 gui=NONE guibg=bg guifg=#b294bb
    CSAHi javaScriptConditional term=NONE cterm=NONE ctermbg=bg ctermfg=54 gui=NONE guibg=bg guifg=#b294bb
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=54 gui=NONE guibg=bg guifg=#b294bb
    CSAHi Type term=underline cterm=NONE ctermbg=bg ctermfg=38 gui=NONE guibg=bg guifg=#81a2be
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=39 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=80 gui=NONE guibg=bg guifg=bg
    CSAHi Error term=reverse cterm=NONE ctermbg=64 ctermfg=79 gui=NONE guibg=Red guifg=White
    CSAHi Todo term=NONE cterm=NONE ctermbg=80 ctermfg=37 gui=NONE guibg=#303030 guifg=#969896
    CSAHi String term=NONE cterm=NONE ctermbg=bg ctermfg=57 gui=NONE guibg=bg guifg=#b5bd68
    CSAHi javaScriptNumber term=NONE cterm=NONE ctermbg=bg ctermfg=53 gui=NONE guibg=bg guifg=#de935f
    CSAHi Include term=NONE cterm=NONE ctermbg=bg ctermfg=38 gui=NONE guibg=bg guifg=#81a2be
    CSAHi javaScriptMember term=NONE cterm=NONE ctermbg=bg ctermfg=53 gui=NONE guibg=bg guifg=#de935f
    CSAHi Define term=NONE cterm=NONE ctermbg=bg ctermfg=54 gui=NONE guibg=bg guifg=#b294bb
    CSAHi diffAdded term=NONE cterm=NONE ctermbg=bg ctermfg=57 gui=NONE guibg=bg guifg=#b5bd68
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=bg ctermfg=81 gui=NONE guibg=bg guifg=#585858
    CSAHi NonText term=bold cterm=bold ctermbg=bg ctermfg=81 gui=bold guibg=bg guifg=#585858
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=38 gui=NONE guibg=bg guifg=#81a2be
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=64 ctermfg=79 gui=NONE guibg=Red guifg=White
    CSAHi IncSearch term=reverse cterm=reverse ctermbg=bg ctermfg=fg gui=reverse guibg=bg guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=73 ctermfg=80 gui=NONE guibg=#f0c674 guifg=#303030
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=57 gui=bold guibg=bg guifg=#b5bd68
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=57 gui=bold guibg=bg guifg=#b5bd68
    CSAHi LineNr term=underline cterm=NONE ctermbg=bg ctermfg=81 gui=NONE guibg=bg guifg=#585858
    CSAHi rubyRepeat term=NONE cterm=NONE ctermbg=bg ctermfg=54 gui=NONE guibg=bg guifg=#b294bb
    CSAHi pythonInclude term=NONE cterm=NONE ctermbg=bg ctermfg=54 gui=NONE guibg=bg guifg=#b294bb
    CSAHi vimCommand term=NONE cterm=NONE ctermbg=bg ctermfg=53 gui=NONE guibg=bg guifg=#cc6666
    CSAHi cType term=NONE cterm=NONE ctermbg=bg ctermfg=73 gui=NONE guibg=bg guifg=#f0c674
    CSAHi cStorageClass term=NONE cterm=NONE ctermbg=bg ctermfg=54 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpVarSelector term=NONE cterm=NONE ctermbg=bg ctermfg=53 gui=NONE guibg=bg guifg=#cc6666
    CSAHi phpKeyword term=NONE cterm=NONE ctermbg=bg ctermfg=54 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpRepeat term=NONE cterm=NONE ctermbg=bg ctermfg=54 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpConditional term=NONE cterm=NONE ctermbg=bg ctermfg=54 gui=NONE guibg=bg guifg=#b294bb
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=DarkCyan
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=81 ctermfg=58 gui=NONE guibg=#585858 guifg=#c5c8c6
    CSAHi PmenuSel term=NONE cterm=reverse ctermbg=81 ctermfg=58 gui=reverse guibg=#585858 guifg=#c5c8c6
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=85 ctermfg=fg gui=NONE guibg=Grey guifg=fg
    CSAHi PmenuThumb term=NONE cterm=reverse ctermbg=bg ctermfg=fg gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=reverse ctermbg=80 ctermfg=58 gui=reverse guibg=#303030 guifg=#c5c8c6
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=reverse ctermbg=bg ctermfg=fg gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=80 ctermfg=fg gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=80 ctermfg=fg gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi Function term=NONE cterm=NONE ctermbg=bg ctermfg=38 gui=NONE guibg=bg guifg=#81a2be
    CSAHi Conditional term=NONE cterm=NONE ctermbg=bg ctermfg=58 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi Repeat term=NONE cterm=NONE ctermbg=bg ctermfg=58 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi Operator term=NONE cterm=NONE ctermbg=bg ctermfg=42 gui=NONE guibg=bg guifg=#8abeb7
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=57 gui=bold guibg=bg guifg=#b5bd68
    CSAHi StatusLine term=bold,reverse cterm=reverse ctermbg=73 ctermfg=81 gui=reverse guibg=#f0c674 guifg=#5e5e5e
    CSAHi StatusLineNC term=reverse cterm=reverse ctermbg=58 ctermfg=81 gui=reverse guibg=#c5c8c6 guifg=#5e5e5e
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=81 ctermfg=81 gui=NONE guibg=#5e5e5e guifg=#5e5e5e
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=37 gui=bold guibg=bg guifg=#969896
    CSAHi Visual term=reverse cterm=NONE ctermbg=81 ctermfg=fg gui=NONE guibg=#585858 guifg=fg
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=53 gui=NONE guibg=bg guifg=#cc6666
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=76 ctermfg=16 gui=NONE guibg=Yellow guifg=Black
    CSAHi Folded term=NONE cterm=NONE ctermbg=80 ctermfg=37 gui=NONE guibg=#303030 guifg=#969896
    CSAHi javaScriptRepeat term=NONE cterm=NONE ctermbg=bg ctermfg=54 gui=NONE guibg=bg guifg=#b294bb
    CSAHi pythonStatement term=NONE cterm=NONE ctermbg=bg ctermfg=54 gui=NONE guibg=bg guifg=#b294bb
    CSAHi pythonConditional term=NONE cterm=NONE ctermbg=bg ctermfg=54 gui=NONE guibg=bg guifg=#b294bb
    CSAHi pythonFunction term=NONE cterm=NONE ctermbg=bg ctermfg=38 gui=NONE guibg=bg guifg=#81a2be
    CSAHi javaScriptBraces term=NONE cterm=NONE ctermbg=bg ctermfg=58 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi rubyConstant term=NONE cterm=NONE ctermbg=bg ctermfg=73 gui=NONE guibg=bg guifg=#f0c674
    CSAHi rubyAttribute term=NONE cterm=NONE ctermbg=bg ctermfg=38 gui=NONE guibg=bg guifg=#81a2be
    CSAHi rubyInclude term=NONE cterm=NONE ctermbg=bg ctermfg=38 gui=NONE guibg=bg guifg=#81a2be
    CSAHi rubyLocalVariableOrMethod term=NONE cterm=NONE ctermbg=bg ctermfg=53 gui=NONE guibg=bg guifg=#de935f
    CSAHi rubyCurlyBlock term=NONE cterm=NONE ctermbg=bg ctermfg=53 gui=NONE guibg=bg guifg=#de935f
    CSAHi rubyStringDelimiter term=NONE cterm=NONE ctermbg=bg ctermfg=57 gui=NONE guibg=bg guifg=#b5bd68
    CSAHi rubyInterpolationDelimiter term=NONE cterm=NONE ctermbg=bg ctermfg=53 gui=NONE guibg=bg guifg=#de935f
    CSAHi ColorColumn term=reverse cterm=NONE ctermbg=80 ctermfg=fg gui=NONE guibg=#3a3a3a guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=58 ctermfg=80 gui=NONE guibg=fg guifg=bg
    CSAHi lCursor term=NONE cterm=NONE ctermbg=58 ctermfg=80 gui=NONE guibg=fg guifg=bg
    CSAHi MatchParen term=reverse cterm=NONE ctermbg=81 ctermfg=fg gui=NONE guibg=#585858 guifg=fg
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=37 gui=NONE guibg=bg guifg=#969896
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=53 gui=NONE guibg=bg guifg=#de935f
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=58 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=53 gui=NONE guibg=bg guifg=#cc6666
    CSAHi Statement term=bold cterm=bold ctermbg=bg ctermfg=58 gui=bold guibg=bg guifg=#c5c8c6
    CSAHi rubyConditional term=NONE cterm=NONE ctermbg=bg ctermfg=54 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpStatement term=NONE cterm=NONE ctermbg=bg ctermfg=54 gui=NONE guibg=bg guifg=#b294bb
    CSAHi phpMemberSelector term=NONE cterm=NONE ctermbg=bg ctermfg=58 gui=NONE guibg=bg guifg=#c5c8c6
    CSAHi Structure term=NONE cterm=NONE ctermbg=bg ctermfg=54 gui=NONE guibg=bg guifg=#b294bb
    CSAHi rubySymbol term=NONE cterm=NONE ctermbg=bg ctermfg=57 gui=NONE guibg=bg guifg=#b5bd68
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=80 ctermfg=31 gui=NONE guibg=#303030 guifg=Cyan
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=58 ctermfg=fg gui=NONE guibg=LightBlue guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=75 ctermfg=fg gui=NONE guibg=LightMagenta guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=63 ctermfg=19 gui=bold guibg=LightCyan guifg=Blue
    CSAHi DiffText term=reverse cterm=bold ctermbg=64 ctermfg=fg gui=bold guibg=Red guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=85 ctermfg=17 gui=NONE guibg=Grey guifg=DarkBlue
    CSAHi Conceal term=NONE cterm=NONE ctermbg=84 ctermfg=86 gui=NONE guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=64 gui=undercurl guibg=bg guifg=fg guisp=Red
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=19 gui=undercurl guibg=bg guifg=fg guisp=Blue
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=67 gui=undercurl guibg=bg guifg=fg guisp=Magenta
endif

if 1
    delcommand CSAHi
endif
