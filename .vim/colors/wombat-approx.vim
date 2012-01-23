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
    CSAhi Normal ctermbg=235 ctermfg=230 guibg=#242424 guifg=#f6f3e8
    CSAhi ColorColumn term=reverse ctermbg=88 guibg=DarkRed
    CSAhi Comment term=bold cterm=underline ctermfg=102 gui=italic guifg=#99968b
    CSAhi Conceal ctermbg=248 ctermfg=252 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline ctermfg=173 guifg=#e5786d
      CSAlink Boolean Constant
      CSAlink Character Constant
    CSAhi Cursor ctermbg=241 guibg=#656565
    CSAhi CursorColumn term=reverse ctermbg=236 guibg=#2d2d2d
    CSAhi CursorLine term=underline ctermbg=236 guibg=#2d2d2d
    CSAhi DiffAdd term=bold ctermbg=18 guibg=DarkBlue
    CSAhi DiffChange term=bold ctermbg=90 guibg=DarkMagenta
    CSAhi DiffDelete term=bold cterm=bold ctermbg=30 ctermfg=21 gui=bold guibg=DarkCyan guifg=Blue
    CSAhi DiffText term=reverse cterm=bold ctermbg=196 gui=bold guibg=Red
    CSAhi Directory term=bold ctermfg=51 guifg=Cyan
    CSAhi Error term=reverse ctermbg=196 ctermfg=231 guibg=Red guifg=White
    CSAhi ErrorMsg term=standout ctermbg=196 ctermfg=231 guibg=Red guifg=White
    CSAhi FoldColumn term=standout ctermbg=250 ctermfg=51 guibg=Grey guifg=Cyan
    CSAhi Folded term=standout ctermbg=59 ctermfg=145 guibg=#384048 guifg=#a0a8b0
    CSAhi Function ctermfg=186 guifg=#cae682
    CSAhi Identifier term=underline ctermfg=186 guifg=#cae682
    CSAhi Ignore ctermfg=235 guifg=bg
    CSAhi IncSearch term=reverse cterm=reverse gui=reverse
    CSAhi Keyword ctermfg=117 guifg=#8ac6f2
    CSAhi LineNr term=underline ctermbg=16 ctermfg=101 guibg=#000000 guifg=#857b6f
    CSAhi MatchParen term=reverse cterm=bold ctermbg=101 ctermfg=230 gui=bold guibg=#857b6f guifg=#f6f3e8
    CSAhi ModeMsg term=bold cterm=bold gui=bold
    CSAhi MoreMsg term=bold cterm=bold ctermfg=29 gui=bold guifg=SeaGreen
    CSAhi NonText term=bold ctermbg=236 ctermfg=244 guibg=#303030 guifg=#808080
    CSAhi Number ctermfg=173 guifg=#e5786d
      CSAlink Float Number
    CSAhi Pmenu ctermbg=238 ctermfg=230 guibg=#444444 guifg=#f6f3e8
    CSAhi PmenuSbar ctermbg=250 guibg=Grey
    CSAhi PmenuSel ctermbg=186 ctermfg=16 guibg=#cae682 guifg=#000000
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermfg=173 guifg=#e5786d
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=46 gui=bold guifg=Green
    CSAhi Search term=reverse ctermbg=226 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi SignColumn term=standout ctermbg=250 ctermfg=51 guibg=Grey guifg=Cyan
    CSAhi Special term=bold ctermfg=194 guifg=#e7f6da
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermbg=236 ctermfg=244 guibg=#343434 guifg=#808080
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=196 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=21 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=51 gui=undercurl guisp=Cyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=201 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold ctermfg=117 guifg=#8ac6f2
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Label Statement
      CSAlink Operator Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse cterm=underline ctermbg=238 ctermfg=230 gui=italic guibg=#444444 guifg=#f6f3e8
    CSAhi StatusLineNC term=reverse ctermbg=238 ctermfg=101 guibg=#444444 guifg=#857b6f
    CSAhi String cterm=underline ctermfg=113 gui=italic guifg=#95e454
    CSAhi TabLine term=underline cterm=underline ctermbg=248 gui=underline guibg=DarkGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=230 gui=bold guifg=#f6f3e8
    CSAhi Todo term=standout cterm=underline ctermbg=226 ctermfg=245 gui=italic guibg=Yellow guifg=#8f8f8f
    CSAhi Type term=underline ctermfg=186 guifg=#cae682
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=111 gui=underline guifg=#80a0ff
    CSAhi VertSplit term=reverse ctermbg=238 ctermfg=238 guibg=#444444 guifg=#444444
    CSAhi Visual term=reverse ctermbg=238 ctermfg=230 guibg=#444444 guifg=#f6f3e8
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WarningMsg term=standout ctermfg=196 guifg=Red
    CSAhi WildMenu term=standout ctermbg=226 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi lCursor ctermbg=230 ctermfg=235 guibg=fg guifg=bg

    if &term =~# "^xterm" || &term =~# "^screen"
        " that's an ambiguous terminal setting
        if (exists("g:CSApprox_konsole") && g:CSApprox_konsole) || (&term =~? "^konsole" && s:old_kde())
        elseif (exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
        endif
    endif

elseif &t_Co == 88
    CSAhi Normal ctermbg=80 ctermfg=79 guibg=#242424 guifg=#f6f3e8
    CSAhi ColorColumn term=reverse ctermbg=32 guibg=DarkRed
    CSAhi Comment term=bold cterm=underline ctermfg=37 gui=italic guifg=#99968b
    CSAhi Conceal ctermbg=84 ctermfg=86 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline ctermfg=53 guifg=#e5786d
      CSAlink Boolean Constant
      CSAlink Character Constant
    CSAhi Cursor ctermbg=81 guibg=#656565
    CSAhi CursorColumn term=reverse ctermbg=80 guibg=#2d2d2d
    CSAhi CursorLine term=underline ctermbg=80 guibg=#2d2d2d
    CSAhi DiffAdd term=bold ctermbg=17 guibg=DarkBlue
    CSAhi DiffChange term=bold ctermbg=33 guibg=DarkMagenta
    CSAhi DiffDelete term=bold cterm=bold ctermbg=21 ctermfg=19 gui=bold guibg=DarkCyan guifg=Blue
    CSAhi DiffText term=reverse cterm=bold ctermbg=64 gui=bold guibg=Red
    CSAhi Directory term=bold ctermfg=31 guifg=Cyan
    CSAhi Error term=reverse ctermbg=64 ctermfg=79 guibg=Red guifg=White
    CSAhi ErrorMsg term=standout ctermbg=64 ctermfg=79 guibg=Red guifg=White
    CSAhi FoldColumn term=standout ctermbg=85 ctermfg=31 guibg=Grey guifg=Cyan
    CSAhi Folded term=standout ctermbg=17 ctermfg=38 guibg=#384048 guifg=#a0a8b0
    CSAhi Function ctermfg=57 guifg=#cae682
    CSAhi Identifier term=underline ctermfg=57 guifg=#cae682
    CSAhi Ignore ctermfg=80 guifg=bg
    CSAhi IncSearch term=reverse cterm=reverse gui=reverse
    CSAhi Keyword ctermfg=43 guifg=#8ac6f2
    CSAhi LineNr term=underline ctermbg=16 ctermfg=37 guibg=#000000 guifg=#857b6f
    CSAhi MatchParen term=reverse cterm=bold ctermbg=37 ctermfg=79 gui=bold guibg=#857b6f guifg=#f6f3e8
    CSAhi ModeMsg term=bold cterm=bold gui=bold
    CSAhi MoreMsg term=bold cterm=bold ctermfg=21 gui=bold guifg=SeaGreen
    CSAhi NonText term=bold ctermbg=80 ctermfg=83 guibg=#303030 guifg=#808080
    CSAhi Number ctermfg=53 guifg=#e5786d
      CSAlink Float Number
    CSAhi Pmenu ctermbg=80 ctermfg=79 guibg=#444444 guifg=#f6f3e8
    CSAhi PmenuSbar ctermbg=85 guibg=Grey
    CSAhi PmenuSel ctermbg=57 ctermfg=16 guibg=#cae682 guifg=#000000
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermfg=53 guifg=#e5786d
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=28 gui=bold guifg=Green
    CSAhi Search term=reverse ctermbg=76 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi SignColumn term=standout ctermbg=85 ctermfg=31 guibg=Grey guifg=Cyan
    CSAhi Special term=bold ctermfg=78 guifg=#e7f6da
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermbg=80 ctermfg=83 guibg=#343434 guifg=#808080
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=64 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=19 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=31 gui=undercurl guisp=Cyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=67 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold ctermfg=43 guifg=#8ac6f2
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Label Statement
      CSAlink Operator Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse cterm=underline ctermbg=80 ctermfg=79 gui=italic guibg=#444444 guifg=#f6f3e8
    CSAhi StatusLineNC term=reverse ctermbg=80 ctermfg=37 guibg=#444444 guifg=#857b6f
    CSAhi String cterm=underline ctermfg=41 gui=italic guifg=#95e454
    CSAhi TabLine term=underline cterm=underline ctermbg=84 gui=underline guibg=DarkGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=79 gui=bold guifg=#f6f3e8
    CSAhi Todo term=standout cterm=underline ctermbg=76 ctermfg=83 gui=italic guibg=Yellow guifg=#8f8f8f
    CSAhi Type term=underline ctermfg=57 guifg=#cae682
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=39 gui=underline guifg=#80a0ff
    CSAhi VertSplit term=reverse ctermbg=80 ctermfg=80 guibg=#444444 guifg=#444444
    CSAhi Visual term=reverse ctermbg=80 ctermfg=79 guibg=#444444 guifg=#f6f3e8
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WarningMsg term=standout ctermfg=64 guifg=Red
    CSAhi WildMenu term=standout ctermbg=76 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi lCursor ctermbg=79 ctermfg=80 guibg=fg guifg=bg
endif

delcommand CSAlink
delfunction s:CSAlink
delcommand CSAhi
delfunction s:CSAhi
let syntax_cmd="on"
