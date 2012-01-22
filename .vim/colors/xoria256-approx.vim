" This scheme was created by CSApproxSnapshot
" on Sat, 21 Jan 2012

syntax on
let syntax_cmd="skip"
highlight clear

let g:colors_name = expand("<sfile>:t:r")
function! s:CSAHi(group, ...)
    exec "hi clear" a:group
    let hi = join(a:000, " ")
    if v:version < 700
        let hi = substitute(substitute(hi, "undercurl", "underline", "g"), "guisp\\S\\+", "", "g")
    endif
    exe "hi" a:group hi
endfunction
command! -nargs=+ CSAHi call s:CSAHi(<f-args>)

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
    CSAHi Normal ctermbg=234 ctermfg=252 guibg=#1c1c1c guifg=#d0d0d0
    CSAHi PreProc term=underline ctermfg=150 guifg=#afdf87
    CSAHi Type term=underline ctermfg=146 guifg=#afafdf
    CSAHi Underlined term=underline cterm=underline ctermfg=39 gui=underline guifg=#00afff
    CSAHi Ignore ctermfg=238 guifg=#444444
    CSAHi Error term=reverse,inverse ctermbg=88 ctermfg=231 guibg=#800000 guifg=#ffffff
    CSAHi Todo term=standout ctermbg=184 ctermfg=16 guibg=#dfdf00 guifg=#000000
    CSAHi Number ctermfg=180 guifg=#dfaf87
    CSAHi SpecialKey term=bold ctermfg=77 guifg=#5fdf5f
    CSAHi NonText term=bold cterm=bold ctermbg=233 ctermfg=247 gui=bold guibg=#121212 guifg=#9e9e9e
    CSAHi Directory term=bold ctermfg=110 guifg=#87afdf
    CSAHi ErrorMsg term=standout ctermbg=88 ctermfg=231 guibg=#800000 guifg=#ffffff
    CSAHi IncSearch term=reverse,inverse ctermbg=223 ctermfg=16 guibg=#ffdfaf guifg=#000000
    CSAHi Search term=reverse,inverse ctermbg=149 ctermfg=16 guibg=#afdf5f guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermfg=29 gui=bold guifg=SeaGreen
    CSAHi ModeMsg term=bold cterm=bold gui=bold
    CSAHi LineNr term=underline ctermbg=233 ctermfg=247 guibg=#121212 guifg=#9e9e9e
    CSAHi diffAdded ctermfg=150 guifg=#afdf87
    CSAHi diffRemoved ctermfg=174 guifg=#df8787
    CSAHi htmlTag ctermfg=146 guifg=#afafdf
    CSAHi htmlEndTag ctermfg=146 guifg=#afafdf
    CSAHi htmlArg ctermfg=182 guifg=#dfafdf
    CSAHi htmlValue ctermfg=187 guifg=#dfdfaf
    CSAHi treeCWD ctermfg=180 guifg=#dfaf87
    CSAHi SpellLocal term=underline cterm=underline ctermbg=234 ctermfg=51 gui=underline guibg=bg guifg=#875fdf guisp=Cyan
    CSAHi Pmenu ctermbg=250 ctermfg=16 guibg=#bcbcbc guifg=#000000
    CSAHi PmenuSel ctermbg=243 ctermfg=255 guibg=#767676 guifg=#eeeeee
    CSAHi PmenuSbar ctermbg=252 guibg=#d0d0d0
    CSAHi PmenuThumb cterm=reverse,inverse ctermfg=243 gui=reverse,inverse guifg=#767676
    CSAHi TabLine term=underline ctermbg=241 ctermfg=252 guibg=#666666 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold gui=bold
    CSAHi TabLineFill term=reverse,inverse ctermbg=237 ctermfg=252 guibg=#3a3a3a guifg=fg
    CSAHi CursorColumn term=reverse,inverse ctermbg=238 guibg=#444444
    CSAHi CursorLine term=underline ctermbg=237 guibg=#3a3a3a
    CSAHi Question term=standout cterm=bold ctermfg=46 gui=bold guifg=Green
    CSAHi StatusLine term=bold,reverse,inverse cterm=bold ctermbg=239 ctermfg=231 gui=bold guibg=#4e4e4e guifg=#ffffff
    CSAHi StatusLineNC term=reverse,inverse ctermbg=237 ctermfg=249 guibg=#3a3a3a guifg=#b2b2b2
    CSAHi VertSplit term=reverse,inverse ctermbg=237 ctermfg=237 guibg=#3a3a3a guifg=#3a3a3a
    CSAHi Title term=bold cterm=bold ctermfg=225 gui=bold guifg=#ffdfff
    CSAHi Visual term=reverse,inverse ctermbg=96 ctermfg=255 guibg=#875f87 guifg=#eeeeee
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=60 ctermfg=255 gui=bold,underline guibg=#5f5f87 guifg=#eeeeee
    CSAHi WarningMsg term=standout ctermfg=196 guifg=Red
    CSAHi WildMenu term=standout cterm=bold ctermbg=150 ctermfg=16 gui=bold guibg=#afdf87 guifg=#000000
    CSAHi Folded term=standout ctermbg=60 ctermfg=255 guibg=#5f5f87 guifg=#eeeeee
    CSAHi treeDirSlash ctermfg=244 guifg=#808080
    CSAHi treeLink ctermfg=182 guifg=#dfafdf
    CSAHi ColorColumn term=reverse,inverse ctermbg=88 guibg=DarkRed
    CSAHi Cursor ctermbg=214 ctermfg=234 guibg=#ffaf00 guifg=bg
    CSAHi lCursor ctermbg=252 ctermfg=234 guibg=fg guifg=bg
    CSAHi MatchParen term=reverse,inverse cterm=bold ctermbg=68 ctermfg=253 gui=bold guibg=#5f87df guifg=#dfdfdf
    CSAHi Comment term=bold ctermfg=244 guifg=#808080
    CSAHi Constant term=underline ctermfg=229 guifg=#ffffaf
    CSAHi Special term=bold ctermfg=174 guifg=#df8787
    CSAHi Identifier term=underline ctermfg=182 guifg=#dfafdf
    CSAHi Statement term=bold ctermfg=110 guifg=#87afdf
    CSAHi treeClosable ctermfg=174 guifg=#df8787
    CSAHi treeOpenable ctermfg=150 guifg=#afdf87
    CSAHi treePart ctermfg=244 guifg=#808080
    CSAHi FoldColumn term=standout ctermbg=233 ctermfg=247 guibg=#121212 guifg=#9e9e9e
    CSAHi DiffAdd term=bold ctermbg=151 ctermfg=234 guibg=#afdfaf guifg=bg
    CSAHi DiffChange term=bold ctermbg=181 ctermfg=234 guibg=#dfafaf guifg=bg
    CSAHi DiffDelete term=bold ctermbg=246 ctermfg=234 guibg=#949494 guifg=bg
    CSAHi DiffText term=reverse,inverse ctermbg=174 ctermfg=234 guibg=#df8787 guifg=bg
    CSAHi SignColumn term=standout ctermbg=250 ctermfg=248 guibg=Grey guifg=#a8a8a8
    CSAHi Conceal ctermbg=248 ctermfg=252 guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse,inverse cterm=undercurl ctermfg=160 gui=undercurl guifg=fg guisp=#df0000
    CSAHi SpellCap term=reverse,inverse cterm=underline ctermbg=234 ctermfg=21 gui=underline guibg=bg guifg=#dfdfff guisp=Blue
    CSAHi SpellRare term=reverse,inverse cterm=underline ctermbg=234 ctermfg=201 gui=underline guibg=bg guifg=#df5f87 guisp=Magenta
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
    CSAHi Normal ctermbg=234 ctermfg=252 guibg=#1c1c1c guifg=#d0d0d0
    CSAHi PreProc term=underline ctermfg=150 guifg=#afdf87
    CSAHi Type term=underline ctermfg=146 guifg=#afafdf
    CSAHi Underlined term=underline cterm=underline ctermfg=39 gui=underline guifg=#00afff
    CSAHi Ignore ctermfg=238 guifg=#444444
    CSAHi Error term=reverse,inverse ctermbg=88 ctermfg=231 guibg=#800000 guifg=#ffffff
    CSAHi Todo term=standout ctermbg=184 ctermfg=16 guibg=#dfdf00 guifg=#000000
    CSAHi Number ctermfg=180 guifg=#dfaf87
    CSAHi SpecialKey term=bold ctermfg=77 guifg=#5fdf5f
    CSAHi NonText term=bold cterm=bold ctermbg=233 ctermfg=247 gui=bold guibg=#121212 guifg=#9e9e9e
    CSAHi Directory term=bold ctermfg=110 guifg=#87afdf
    CSAHi ErrorMsg term=standout ctermbg=88 ctermfg=231 guibg=#800000 guifg=#ffffff
    CSAHi IncSearch term=reverse,inverse ctermbg=223 ctermfg=16 guibg=#ffdfaf guifg=#000000
    CSAHi Search term=reverse,inverse ctermbg=149 ctermfg=16 guibg=#afdf5f guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermfg=29 gui=bold guifg=SeaGreen
    CSAHi ModeMsg term=bold cterm=bold gui=bold
    CSAHi LineNr term=underline ctermbg=233 ctermfg=247 guibg=#121212 guifg=#9e9e9e
    CSAHi diffAdded ctermfg=150 guifg=#afdf87
    CSAHi diffRemoved ctermfg=174 guifg=#df8787
    CSAHi htmlTag ctermfg=146 guifg=#afafdf
    CSAHi htmlEndTag ctermfg=146 guifg=#afafdf
    CSAHi htmlArg ctermfg=182 guifg=#dfafdf
    CSAHi htmlValue ctermfg=187 guifg=#dfdfaf
    CSAHi treeCWD ctermfg=180 guifg=#dfaf87
    CSAHi SpellLocal term=underline cterm=underline ctermbg=234 ctermfg=51 gui=underline guibg=bg guifg=#875fdf guisp=Cyan
    CSAHi Pmenu ctermbg=250 ctermfg=16 guibg=#bcbcbc guifg=#000000
    CSAHi PmenuSel ctermbg=243 ctermfg=255 guibg=#767676 guifg=#eeeeee
    CSAHi PmenuSbar ctermbg=252 guibg=#d0d0d0
    CSAHi PmenuThumb cterm=reverse,inverse ctermfg=243 gui=reverse,inverse guifg=#767676
    CSAHi TabLine term=underline ctermbg=241 ctermfg=252 guibg=#666666 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold gui=bold
    CSAHi TabLineFill term=reverse,inverse ctermbg=237 ctermfg=252 guibg=#3a3a3a guifg=fg
    CSAHi CursorColumn term=reverse,inverse ctermbg=238 guibg=#444444
    CSAHi CursorLine term=underline ctermbg=237 guibg=#3a3a3a
    CSAHi Question term=standout cterm=bold ctermfg=46 gui=bold guifg=Green
    CSAHi StatusLine term=bold,reverse,inverse cterm=bold ctermbg=239 ctermfg=231 gui=bold guibg=#4e4e4e guifg=#ffffff
    CSAHi StatusLineNC term=reverse,inverse ctermbg=237 ctermfg=249 guibg=#3a3a3a guifg=#b2b2b2
    CSAHi VertSplit term=reverse,inverse ctermbg=237 ctermfg=237 guibg=#3a3a3a guifg=#3a3a3a
    CSAHi Title term=bold cterm=bold ctermfg=225 gui=bold guifg=#ffdfff
    CSAHi Visual term=reverse,inverse ctermbg=96 ctermfg=255 guibg=#875f87 guifg=#eeeeee
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=60 ctermfg=255 gui=bold,underline guibg=#5f5f87 guifg=#eeeeee
    CSAHi WarningMsg term=standout ctermfg=196 guifg=Red
    CSAHi WildMenu term=standout cterm=bold ctermbg=150 ctermfg=16 gui=bold guibg=#afdf87 guifg=#000000
    CSAHi Folded term=standout ctermbg=60 ctermfg=255 guibg=#5f5f87 guifg=#eeeeee
    CSAHi treeDirSlash ctermfg=244 guifg=#808080
    CSAHi treeLink ctermfg=182 guifg=#dfafdf
    CSAHi ColorColumn term=reverse,inverse ctermbg=88 guibg=DarkRed
    CSAHi Cursor ctermbg=214 ctermfg=234 guibg=#ffaf00 guifg=bg
    CSAHi lCursor ctermbg=252 ctermfg=234 guibg=fg guifg=bg
    CSAHi MatchParen term=reverse,inverse cterm=bold ctermbg=68 ctermfg=253 gui=bold guibg=#5f87df guifg=#dfdfdf
    CSAHi Comment term=bold ctermfg=244 guifg=#808080
    CSAHi Constant term=underline ctermfg=229 guifg=#ffffaf
    CSAHi Special term=bold ctermfg=174 guifg=#df8787
    CSAHi Identifier term=underline ctermfg=182 guifg=#dfafdf
    CSAHi Statement term=bold ctermfg=110 guifg=#87afdf
    CSAHi treeClosable ctermfg=174 guifg=#df8787
    CSAHi treeOpenable ctermfg=150 guifg=#afdf87
    CSAHi treePart ctermfg=244 guifg=#808080
    CSAHi FoldColumn term=standout ctermbg=233 ctermfg=247 guibg=#121212 guifg=#9e9e9e
    CSAHi DiffAdd term=bold ctermbg=151 ctermfg=234 guibg=#afdfaf guifg=bg
    CSAHi DiffChange term=bold ctermbg=181 ctermfg=234 guibg=#dfafaf guifg=bg
    CSAHi DiffDelete term=bold ctermbg=246 ctermfg=234 guibg=#949494 guifg=bg
    CSAHi DiffText term=reverse,inverse ctermbg=174 ctermfg=234 guibg=#df8787 guifg=bg
    CSAHi SignColumn term=standout ctermbg=250 ctermfg=248 guibg=Grey guifg=#a8a8a8
    CSAHi Conceal ctermbg=248 ctermfg=252 guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse,inverse cterm=undercurl ctermfg=160 gui=undercurl guifg=fg guisp=#df0000
    CSAHi SpellCap term=reverse,inverse cterm=underline ctermbg=234 ctermfg=21 gui=underline guibg=bg guifg=#dfdfff guisp=Blue
    CSAHi SpellRare term=reverse,inverse cterm=underline ctermbg=234 ctermfg=201 gui=underline guibg=bg guifg=#df5f87 guisp=Magenta
elseif has("gui_running") || &t_Co == 256
    CSAHi Normal ctermbg=234 ctermfg=252 guibg=#1c1c1c guifg=#d0d0d0
    CSAHi PreProc term=underline ctermfg=150 guifg=#afdf87
    CSAHi Type term=underline ctermfg=146 guifg=#afafdf
    CSAHi Underlined term=underline cterm=underline ctermfg=39 gui=underline guifg=#00afff
    CSAHi Ignore ctermfg=238 guifg=#444444
    CSAHi Error term=reverse,inverse ctermbg=88 ctermfg=231 guibg=#800000 guifg=#ffffff
    CSAHi Todo term=standout ctermbg=184 ctermfg=16 guibg=#dfdf00 guifg=#000000
    CSAHi Number ctermfg=180 guifg=#dfaf87
    CSAHi SpecialKey term=bold ctermfg=77 guifg=#5fdf5f
    CSAHi NonText term=bold cterm=bold ctermbg=233 ctermfg=247 gui=bold guibg=#121212 guifg=#9e9e9e
    CSAHi Directory term=bold ctermfg=110 guifg=#87afdf
    CSAHi ErrorMsg term=standout ctermbg=88 ctermfg=231 guibg=#800000 guifg=#ffffff
    CSAHi IncSearch term=reverse,inverse ctermbg=223 ctermfg=16 guibg=#ffdfaf guifg=#000000
    CSAHi Search term=reverse,inverse ctermbg=149 ctermfg=16 guibg=#afdf5f guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermfg=29 gui=bold guifg=SeaGreen
    CSAHi ModeMsg term=bold cterm=bold gui=bold
    CSAHi LineNr term=underline ctermbg=233 ctermfg=247 guibg=#121212 guifg=#9e9e9e
    CSAHi diffAdded ctermfg=150 guifg=#afdf87
    CSAHi diffRemoved ctermfg=174 guifg=#df8787
    CSAHi htmlTag ctermfg=146 guifg=#afafdf
    CSAHi htmlEndTag ctermfg=146 guifg=#afafdf
    CSAHi htmlArg ctermfg=182 guifg=#dfafdf
    CSAHi htmlValue ctermfg=187 guifg=#dfdfaf
    CSAHi treeCWD ctermfg=180 guifg=#dfaf87
    CSAHi SpellLocal term=underline cterm=underline ctermbg=234 ctermfg=51 gui=underline guibg=bg guifg=#875fdf guisp=Cyan
    CSAHi Pmenu ctermbg=250 ctermfg=16 guibg=#bcbcbc guifg=#000000
    CSAHi PmenuSel ctermbg=243 ctermfg=255 guibg=#767676 guifg=#eeeeee
    CSAHi PmenuSbar ctermbg=252 guibg=#d0d0d0
    CSAHi PmenuThumb cterm=reverse,inverse ctermfg=243 gui=reverse,inverse guifg=#767676
    CSAHi TabLine term=underline ctermbg=241 ctermfg=252 guibg=#666666 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold gui=bold
    CSAHi TabLineFill term=reverse,inverse ctermbg=237 ctermfg=252 guibg=#3a3a3a guifg=fg
    CSAHi CursorColumn term=reverse,inverse ctermbg=238 guibg=#444444
    CSAHi CursorLine term=underline ctermbg=237 guibg=#3a3a3a
    CSAHi Question term=standout cterm=bold ctermfg=46 gui=bold guifg=Green
    CSAHi StatusLine term=bold,reverse,inverse cterm=bold ctermbg=239 ctermfg=231 gui=bold guibg=#4e4e4e guifg=#ffffff
    CSAHi StatusLineNC term=reverse,inverse ctermbg=237 ctermfg=249 guibg=#3a3a3a guifg=#b2b2b2
    CSAHi VertSplit term=reverse,inverse ctermbg=237 ctermfg=237 guibg=#3a3a3a guifg=#3a3a3a
    CSAHi Title term=bold cterm=bold ctermfg=225 gui=bold guifg=#ffdfff
    CSAHi Visual term=reverse,inverse ctermbg=96 ctermfg=255 guibg=#875f87 guifg=#eeeeee
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=60 ctermfg=255 gui=bold,underline guibg=#5f5f87 guifg=#eeeeee
    CSAHi WarningMsg term=standout ctermfg=196 guifg=Red
    CSAHi WildMenu term=standout cterm=bold ctermbg=150 ctermfg=16 gui=bold guibg=#afdf87 guifg=#000000
    CSAHi Folded term=standout ctermbg=60 ctermfg=255 guibg=#5f5f87 guifg=#eeeeee
    CSAHi treeDirSlash ctermfg=244 guifg=#808080
    CSAHi treeLink ctermfg=182 guifg=#dfafdf
    CSAHi ColorColumn term=reverse,inverse ctermbg=88 guibg=DarkRed
    CSAHi Cursor ctermbg=214 ctermfg=234 guibg=#ffaf00 guifg=bg
    CSAHi lCursor ctermbg=252 ctermfg=234 guibg=fg guifg=bg
    CSAHi MatchParen term=reverse,inverse cterm=bold ctermbg=68 ctermfg=253 gui=bold guibg=#5f87df guifg=#dfdfdf
    CSAHi Comment term=bold ctermfg=244 guifg=#808080
    CSAHi Constant term=underline ctermfg=229 guifg=#ffffaf
    CSAHi Special term=bold ctermfg=174 guifg=#df8787
    CSAHi Identifier term=underline ctermfg=182 guifg=#dfafdf
    CSAHi Statement term=bold ctermfg=110 guifg=#87afdf
    CSAHi treeClosable ctermfg=174 guifg=#df8787
    CSAHi treeOpenable ctermfg=150 guifg=#afdf87
    CSAHi treePart ctermfg=244 guifg=#808080
    CSAHi FoldColumn term=standout ctermbg=233 ctermfg=247 guibg=#121212 guifg=#9e9e9e
    CSAHi DiffAdd term=bold ctermbg=151 ctermfg=234 guibg=#afdfaf guifg=bg
    CSAHi DiffChange term=bold ctermbg=181 ctermfg=234 guibg=#dfafaf guifg=bg
    CSAHi DiffDelete term=bold ctermbg=246 ctermfg=234 guibg=#949494 guifg=bg
    CSAHi DiffText term=reverse,inverse ctermbg=174 ctermfg=234 guibg=#df8787 guifg=bg
    CSAHi SignColumn term=standout ctermbg=250 ctermfg=248 guibg=Grey guifg=#a8a8a8
    CSAHi Conceal ctermbg=248 ctermfg=252 guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse,inverse cterm=undercurl ctermfg=160 gui=undercurl guifg=fg guisp=#df0000
    CSAHi SpellCap term=reverse,inverse cterm=underline ctermbg=234 ctermfg=21 gui=underline guibg=bg guifg=#dfdfff guisp=Blue
    CSAHi SpellRare term=reverse,inverse cterm=underline ctermbg=234 ctermfg=201 gui=underline guibg=bg guifg=#df5f87 guisp=Magenta
elseif has("gui_running") || &t_Co == 88
    CSAHi Normal ctermbg=80 ctermfg=86 guibg=#1c1c1c guifg=#d0d0d0
    CSAHi PreProc term=underline ctermfg=57 guifg=#afdf87
    CSAHi Type term=underline ctermfg=58 guifg=#afafdf
    CSAHi Underlined term=underline cterm=underline ctermfg=27 gui=underline guifg=#00afff
    CSAHi Ignore ctermfg=80 guifg=#444444
    CSAHi Error term=reverse,inverse ctermbg=32 ctermfg=79 guibg=#800000 guifg=#ffffff
    CSAHi Todo term=standout ctermbg=56 ctermfg=16 guibg=#dfdf00 guifg=#000000
    CSAHi Number ctermfg=57 guifg=#dfaf87
    CSAHi SpecialKey term=bold ctermfg=41 guifg=#5fdf5f
    CSAHi NonText term=bold cterm=bold ctermbg=16 ctermfg=84 gui=bold guibg=#121212 guifg=#9e9e9e
    CSAHi Directory term=bold ctermfg=42 guifg=#87afdf
    CSAHi ErrorMsg term=standout ctermbg=32 ctermfg=79 guibg=#800000 guifg=#ffffff
    CSAHi IncSearch term=reverse,inverse ctermbg=74 ctermfg=16 guibg=#ffdfaf guifg=#000000
    CSAHi Search term=reverse,inverse ctermbg=57 ctermfg=16 guibg=#afdf5f guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermfg=21 gui=bold guifg=SeaGreen
    CSAHi ModeMsg term=bold cterm=bold gui=bold
    CSAHi LineNr term=underline ctermbg=16 ctermfg=84 guibg=#121212 guifg=#9e9e9e
    CSAHi diffAdded ctermfg=57 guifg=#afdf87
    CSAHi diffRemoved ctermfg=53 guifg=#df8787
    CSAHi htmlTag ctermfg=58 guifg=#afafdf
    CSAHi htmlEndTag ctermfg=58 guifg=#afafdf
    CSAHi htmlArg ctermfg=58 guifg=#dfafdf
    CSAHi htmlValue ctermfg=58 guifg=#dfdfaf
    CSAHi treeCWD ctermfg=57 guifg=#dfaf87
    CSAHi SpellLocal term=underline cterm=underline ctermbg=80 ctermfg=31 gui=underline guibg=bg guifg=#875fdf guisp=Cyan
    CSAHi Pmenu ctermbg=85 ctermfg=16 guibg=#bcbcbc guifg=#000000
    CSAHi PmenuSel ctermbg=82 ctermfg=87 guibg=#767676 guifg=#eeeeee
    CSAHi PmenuSbar ctermbg=86 guibg=#d0d0d0
    CSAHi PmenuThumb cterm=reverse,inverse ctermfg=82 gui=reverse,inverse guifg=#767676
    CSAHi TabLine term=underline ctermbg=81 ctermfg=86 guibg=#666666 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold gui=bold
    CSAHi TabLineFill term=reverse,inverse ctermbg=80 ctermfg=86 guibg=#3a3a3a guifg=fg
    CSAHi CursorColumn term=reverse,inverse ctermbg=80 guibg=#444444
    CSAHi CursorLine term=underline ctermbg=80 guibg=#3a3a3a
    CSAHi Question term=standout cterm=bold ctermfg=28 gui=bold guifg=Green
    CSAHi StatusLine term=bold,reverse,inverse cterm=bold ctermbg=81 ctermfg=79 gui=bold guibg=#4e4e4e guifg=#ffffff
    CSAHi StatusLineNC term=reverse,inverse ctermbg=80 ctermfg=85 guibg=#3a3a3a guifg=#b2b2b2
    CSAHi VertSplit term=reverse,inverse ctermbg=80 ctermfg=80 guibg=#3a3a3a guifg=#3a3a3a
    CSAHi Title term=bold cterm=bold ctermfg=75 gui=bold guifg=#ffdfff
    CSAHi Visual term=reverse,inverse ctermbg=37 ctermfg=87 guibg=#875f87 guifg=#eeeeee
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=37 ctermfg=87 gui=bold,underline guibg=#5f5f87 guifg=#eeeeee
    CSAHi WarningMsg term=standout ctermfg=64 guifg=Red
    CSAHi WildMenu term=standout cterm=bold ctermbg=57 ctermfg=16 gui=bold guibg=#afdf87 guifg=#000000
    CSAHi Folded term=standout ctermbg=37 ctermfg=87 guibg=#5f5f87 guifg=#eeeeee
    CSAHi treeDirSlash ctermfg=83 guifg=#808080
    CSAHi treeLink ctermfg=58 guifg=#dfafdf
    CSAHi ColorColumn term=reverse,inverse ctermbg=32 guibg=DarkRed
    CSAHi Cursor ctermbg=72 ctermfg=80 guibg=#ffaf00 guifg=bg
    CSAHi lCursor ctermbg=86 ctermfg=80 guibg=fg guifg=bg
    CSAHi MatchParen term=reverse,inverse cterm=bold ctermbg=38 ctermfg=87 gui=bold guibg=#5f87df guifg=#dfdfdf
    CSAHi Comment term=bold ctermfg=83 guifg=#808080
    CSAHi Constant term=underline ctermfg=78 guifg=#ffffaf
    CSAHi Special term=bold ctermfg=53 guifg=#df8787
    CSAHi Identifier term=underline ctermfg=58 guifg=#dfafdf
    CSAHi Statement term=bold ctermfg=42 guifg=#87afdf
    CSAHi treeClosable ctermfg=53 guifg=#df8787
    CSAHi treeOpenable ctermfg=57 guifg=#afdf87
    CSAHi treePart ctermfg=83 guifg=#808080
    CSAHi FoldColumn term=standout ctermbg=16 ctermfg=84 guibg=#121212 guifg=#9e9e9e
    CSAHi DiffAdd term=bold ctermbg=58 ctermfg=80 guibg=#afdfaf guifg=bg
    CSAHi DiffChange term=bold ctermbg=58 ctermfg=80 guibg=#dfafaf guifg=bg
    CSAHi DiffDelete term=bold ctermbg=83 ctermfg=80 guibg=#949494 guifg=bg
    CSAHi DiffText term=reverse,inverse ctermbg=53 ctermfg=80 guibg=#df8787 guifg=bg
    CSAHi SignColumn term=standout ctermbg=85 ctermfg=84 guibg=Grey guifg=#a8a8a8
    CSAHi Conceal ctermbg=84 ctermfg=86 guibg=DarkGrey guifg=LightGrey
    CSAHi SpellBad term=reverse,inverse cterm=undercurl ctermfg=48 gui=undercurl guifg=fg guisp=#df0000
    CSAHi SpellCap term=reverse,inverse cterm=underline ctermbg=80 ctermfg=19 gui=underline guibg=bg guifg=#dfdfff guisp=Blue
    CSAHi SpellRare term=reverse,inverse cterm=underline ctermbg=80 ctermfg=67 gui=underline guibg=bg guifg=#df5f87 guisp=Magenta
endif

delcommand CSAHi
delfunction s:CSAHi
let syntax_cmd="on"
