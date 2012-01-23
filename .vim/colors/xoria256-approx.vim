" This scheme was created by CSApproxSnapshot
" on Mon, 23 Jan 2012

syntax on
let syntax_cmd="skip"
highlight clear

let g:colors_name = expand("<sfile>:t:r")
function! s:CSAhi(group, ...)
    exe "hi clear" a:group
    let hi = join(a:000, " ")
    if v:version < 700
        let hi = substitute(substitute(hi, "undercurl", "underline", "g"), "guisp=\\S\\+", "", "g")
    endif
    exe "hi" a:group hi
endfunction
command! -nargs=+ CSAhi call s:CSAhi(<f-args>)

function! s:CSAlink(from, to)
    exe "hi clear" a:from
    exe "hi! link" a:from a:to
endfunction
command! -nargs=+ CSAlink call s:CSAlink(<f-args>)

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

if has("gui_running") || &t_Co == 256
    CSAhi Normal ctermbg=234 ctermfg=252 guibg=#1c1c1c guifg=#d0d0d0
    CSAhi ColorColumn term=reverse ctermbg=88 guibg=DarkRed
    CSAhi Comment term=bold ctermfg=244 guifg=#808080
    CSAhi Conceal ctermbg=248 ctermfg=252 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline ctermfg=229 guifg=#ffffaf
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink String Constant
    CSAhi Cursor ctermbg=214 ctermfg=234 guibg=#ffaf00 guifg=bg
    CSAhi CursorColumn term=reverse ctermbg=238 guibg=#444444
    CSAhi CursorLine term=underline ctermbg=237 guibg=#3a3a3a
    CSAhi DiffAdd term=bold ctermbg=151 ctermfg=234 guibg=#afdfaf guifg=bg
    CSAhi DiffChange term=bold ctermbg=181 ctermfg=234 guibg=#dfafaf guifg=bg
    CSAhi DiffDelete term=bold ctermbg=246 ctermfg=234 guibg=#949494 guifg=bg
    CSAhi DiffText term=reverse ctermbg=174 ctermfg=234 guibg=#df8787 guifg=bg
    CSAhi Directory term=bold ctermfg=110 guifg=#87afdf
    CSAhi Error term=reverse ctermbg=88 ctermfg=231 guibg=#800000 guifg=#ffffff
    CSAhi ErrorMsg term=standout ctermbg=88 ctermfg=231 guibg=#800000 guifg=#ffffff
    CSAhi FoldColumn term=standout ctermbg=233 ctermfg=247 guibg=#121212 guifg=#9e9e9e
    CSAhi Folded term=standout ctermbg=60 ctermfg=255 guibg=#5f5f87 guifg=#eeeeee
    CSAhi Identifier term=underline ctermfg=182 guifg=#dfafdf
      CSAlink Function Identifier
    CSAhi Ignore ctermfg=238 guifg=#444444
    CSAhi IncSearch term=reverse ctermbg=223 ctermfg=16 guibg=#ffdfaf guifg=#000000
    CSAhi LineNr term=underline ctermbg=233 ctermfg=247 guibg=#121212 guifg=#9e9e9e
    CSAhi MatchParen term=reverse cterm=bold ctermbg=68 ctermfg=253 gui=bold guibg=#5f87df guifg=#dfdfdf
    CSAhi ModeMsg term=bold cterm=bold gui=bold
    CSAhi MoreMsg term=bold cterm=bold ctermfg=29 gui=bold guifg=SeaGreen
    CSAhi NonText term=bold cterm=bold ctermbg=233 ctermfg=247 gui=bold guibg=#121212 guifg=#9e9e9e
    CSAhi Number ctermfg=180 guifg=#dfaf87
      CSAlink Float Number
    CSAhi Pmenu ctermbg=250 ctermfg=16 guibg=#bcbcbc guifg=#000000
    CSAhi PmenuSbar ctermbg=252 guibg=#d0d0d0
    CSAhi PmenuSel ctermbg=243 ctermfg=255 guibg=#767676 guifg=#eeeeee
    CSAhi PmenuThumb cterm=reverse ctermfg=243 gui=reverse guifg=#767676
    CSAhi PreProc term=underline ctermfg=150 guifg=#afdf87
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=46 gui=bold guifg=Green
    CSAhi Search term=reverse ctermbg=149 ctermfg=16 guibg=#afdf5f guifg=#000000
    CSAhi SignColumn term=standout ctermbg=250 ctermfg=248 guibg=Grey guifg=#a8a8a8
    CSAhi Special term=bold ctermfg=174 guifg=#df8787
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermfg=77 guifg=#5fdf5f
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=160 gui=undercurl guifg=fg guisp=#df0000
    CSAhi SpellCap term=reverse cterm=underline ctermbg=234 ctermfg=21 gui=underline guibg=bg guifg=#dfdfff guisp=Blue
    CSAhi SpellLocal term=underline cterm=underline ctermbg=234 ctermfg=51 gui=underline guibg=bg guifg=#875fdf guisp=Cyan
    CSAhi SpellRare term=reverse cterm=underline ctermbg=234 ctermfg=201 gui=underline guibg=bg guifg=#df5f87 guisp=Magenta
    CSAhi Statement term=bold ctermfg=110 guifg=#87afdf
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Label Statement
      CSAlink Operator Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse cterm=bold ctermbg=239 ctermfg=231 gui=bold guibg=#4e4e4e guifg=#ffffff
    CSAhi StatusLineNC term=reverse ctermbg=237 ctermfg=249 guibg=#3a3a3a guifg=#b2b2b2
    CSAhi TabLine term=underline ctermbg=241 ctermfg=252 guibg=#666666 guifg=fg
    CSAhi TabLineFill term=reverse ctermbg=237 ctermfg=252 guibg=#3a3a3a guifg=fg
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=225 gui=bold guifg=#ffdfff
    CSAhi Todo term=standout ctermbg=184 ctermfg=16 guibg=#dfdf00 guifg=#000000
    CSAhi Type term=underline ctermfg=146 guifg=#afafdf
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=39 gui=underline guifg=#00afff
    CSAhi VertSplit term=reverse ctermbg=237 ctermfg=237 guibg=#3a3a3a guifg=#3a3a3a
    CSAhi Visual term=reverse ctermbg=96 ctermfg=255 guibg=#875f87 guifg=#eeeeee
    CSAhi VisualNOS term=bold,underline cterm=bold,underline ctermbg=60 ctermfg=255 gui=bold,underline guibg=#5f5f87 guifg=#eeeeee
    CSAhi WarningMsg term=standout ctermfg=196 guifg=Red
    CSAhi WildMenu term=standout cterm=bold ctermbg=150 ctermfg=16 gui=bold guibg=#afdf87 guifg=#000000
    CSAhi diffAdded ctermfg=150 guifg=#afdf87
    CSAhi diffRemoved ctermfg=174 guifg=#df8787
    CSAhi htmlArg ctermfg=182 guifg=#dfafdf
    CSAhi htmlEndTag ctermfg=146 guifg=#afafdf
    CSAhi htmlTag ctermfg=146 guifg=#afafdf
    CSAhi htmlValue ctermfg=187 guifg=#dfdfaf
    CSAhi lCursor ctermbg=252 ctermfg=234 guibg=fg guifg=bg
    CSAhi treeCWD ctermfg=180 guifg=#dfaf87
    CSAhi treeClosable ctermfg=174 guifg=#df8787
    CSAhi treeDirSlash ctermfg=244 guifg=#808080
    CSAhi treeLink ctermfg=182 guifg=#dfafdf
    CSAhi treeOpenable ctermfg=150 guifg=#afdf87
    CSAhi treePart ctermfg=244 guifg=#808080

    if &term =~# "^xterm" || &term =~# "^screen"
        " that's an ambiguous terminal setting
        if (exists("g:CSApprox_konsole") && g:CSApprox_konsole) || (&term =~? "^konsole" && s:old_kde())
        elseif (exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
        endif
    endif

elseif &t_Co == 88
    CSAhi Normal ctermbg=80 ctermfg=86 guibg=#1c1c1c guifg=#d0d0d0
    CSAhi ColorColumn term=reverse ctermbg=32 guibg=DarkRed
    CSAhi Comment term=bold ctermfg=83 guifg=#808080
    CSAhi Conceal ctermbg=84 ctermfg=86 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline ctermfg=78 guifg=#ffffaf
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink String Constant
    CSAhi Cursor ctermbg=72 ctermfg=80 guibg=#ffaf00 guifg=bg
    CSAhi CursorColumn term=reverse ctermbg=80 guibg=#444444
    CSAhi CursorLine term=underline ctermbg=80 guibg=#3a3a3a
    CSAhi DiffAdd term=bold ctermbg=58 ctermfg=80 guibg=#afdfaf guifg=bg
    CSAhi DiffChange term=bold ctermbg=58 ctermfg=80 guibg=#dfafaf guifg=bg
    CSAhi DiffDelete term=bold ctermbg=83 ctermfg=80 guibg=#949494 guifg=bg
    CSAhi DiffText term=reverse ctermbg=53 ctermfg=80 guibg=#df8787 guifg=bg
    CSAhi Directory term=bold ctermfg=42 guifg=#87afdf
    CSAhi Error term=reverse ctermbg=32 ctermfg=79 guibg=#800000 guifg=#ffffff
    CSAhi ErrorMsg term=standout ctermbg=32 ctermfg=79 guibg=#800000 guifg=#ffffff
    CSAhi FoldColumn term=standout ctermbg=16 ctermfg=84 guibg=#121212 guifg=#9e9e9e
    CSAhi Folded term=standout ctermbg=37 ctermfg=87 guibg=#5f5f87 guifg=#eeeeee
    CSAhi Identifier term=underline ctermfg=58 guifg=#dfafdf
      CSAlink Function Identifier
    CSAhi Ignore ctermfg=80 guifg=#444444
    CSAhi IncSearch term=reverse ctermbg=74 ctermfg=16 guibg=#ffdfaf guifg=#000000
    CSAhi LineNr term=underline ctermbg=16 ctermfg=84 guibg=#121212 guifg=#9e9e9e
    CSAhi MatchParen term=reverse cterm=bold ctermbg=38 ctermfg=87 gui=bold guibg=#5f87df guifg=#dfdfdf
    CSAhi ModeMsg term=bold cterm=bold gui=bold
    CSAhi MoreMsg term=bold cterm=bold ctermfg=21 gui=bold guifg=SeaGreen
    CSAhi NonText term=bold cterm=bold ctermbg=16 ctermfg=84 gui=bold guibg=#121212 guifg=#9e9e9e
    CSAhi Number ctermfg=57 guifg=#dfaf87
      CSAlink Float Number
    CSAhi Pmenu ctermbg=85 ctermfg=16 guibg=#bcbcbc guifg=#000000
    CSAhi PmenuSbar ctermbg=86 guibg=#d0d0d0
    CSAhi PmenuSel ctermbg=82 ctermfg=87 guibg=#767676 guifg=#eeeeee
    CSAhi PmenuThumb cterm=reverse ctermfg=82 gui=reverse guifg=#767676
    CSAhi PreProc term=underline ctermfg=57 guifg=#afdf87
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=28 gui=bold guifg=Green
    CSAhi Search term=reverse ctermbg=57 ctermfg=16 guibg=#afdf5f guifg=#000000
    CSAhi SignColumn term=standout ctermbg=85 ctermfg=84 guibg=Grey guifg=#a8a8a8
    CSAhi Special term=bold ctermfg=53 guifg=#df8787
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermfg=41 guifg=#5fdf5f
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=48 gui=undercurl guifg=fg guisp=#df0000
    CSAhi SpellCap term=reverse cterm=underline ctermbg=80 ctermfg=19 gui=underline guibg=bg guifg=#dfdfff guisp=Blue
    CSAhi SpellLocal term=underline cterm=underline ctermbg=80 ctermfg=31 gui=underline guibg=bg guifg=#875fdf guisp=Cyan
    CSAhi SpellRare term=reverse cterm=underline ctermbg=80 ctermfg=67 gui=underline guibg=bg guifg=#df5f87 guisp=Magenta
    CSAhi Statement term=bold ctermfg=42 guifg=#87afdf
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Label Statement
      CSAlink Operator Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse cterm=bold ctermbg=81 ctermfg=79 gui=bold guibg=#4e4e4e guifg=#ffffff
    CSAhi StatusLineNC term=reverse ctermbg=80 ctermfg=85 guibg=#3a3a3a guifg=#b2b2b2
    CSAhi TabLine term=underline ctermbg=81 ctermfg=86 guibg=#666666 guifg=fg
    CSAhi TabLineFill term=reverse ctermbg=80 ctermfg=86 guibg=#3a3a3a guifg=fg
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=75 gui=bold guifg=#ffdfff
    CSAhi Todo term=standout ctermbg=56 ctermfg=16 guibg=#dfdf00 guifg=#000000
    CSAhi Type term=underline ctermfg=58 guifg=#afafdf
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=27 gui=underline guifg=#00afff
    CSAhi VertSplit term=reverse ctermbg=80 ctermfg=80 guibg=#3a3a3a guifg=#3a3a3a
    CSAhi Visual term=reverse ctermbg=37 ctermfg=87 guibg=#875f87 guifg=#eeeeee
    CSAhi VisualNOS term=bold,underline cterm=bold,underline ctermbg=37 ctermfg=87 gui=bold,underline guibg=#5f5f87 guifg=#eeeeee
    CSAhi WarningMsg term=standout ctermfg=64 guifg=Red
    CSAhi WildMenu term=standout cterm=bold ctermbg=57 ctermfg=16 gui=bold guibg=#afdf87 guifg=#000000
    CSAhi diffAdded ctermfg=57 guifg=#afdf87
    CSAhi diffRemoved ctermfg=53 guifg=#df8787
    CSAhi htmlArg ctermfg=58 guifg=#dfafdf
    CSAhi htmlEndTag ctermfg=58 guifg=#afafdf
    CSAhi htmlTag ctermfg=58 guifg=#afafdf
    CSAhi htmlValue ctermfg=58 guifg=#dfdfaf
    CSAhi lCursor ctermbg=86 ctermfg=80 guibg=fg guifg=bg
    CSAhi treeCWD ctermfg=57 guifg=#dfaf87
    CSAhi treeClosable ctermfg=53 guifg=#df8787
    CSAhi treeDirSlash ctermfg=83 guifg=#808080
    CSAhi treeLink ctermfg=58 guifg=#dfafdf
    CSAhi treeOpenable ctermfg=57 guifg=#afdf87
    CSAhi treePart ctermfg=83 guifg=#808080
endif

delcommand CSAlink
delfunction s:CSAlink
delcommand CSAhi
delfunction s:CSAhi
let syntax_cmd="on"
