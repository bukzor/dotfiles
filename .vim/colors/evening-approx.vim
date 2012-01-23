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
    CSAhi Normal ctermbg=236 ctermfg=231 guibg=grey20 guifg=White
    CSAhi ColorColumn term=reverse ctermbg=217 guibg=LightRed
    CSAhi Comment term=bold ctermfg=111 guifg=#80a0ff
    CSAhi Conceal ctermbg=248 ctermfg=252 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline ctermbg=232 ctermfg=217 guibg=grey5 guifg=#ffa0a0
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink Float Constant
      CSAlink Number Constant
      CSAlink String Constant
    CSAhi Cursor ctermbg=46 ctermfg=16 guibg=Green guifg=Black
    CSAhi CursorColumn term=reverse ctermbg=241 guibg=grey40
    CSAhi CursorLine term=underline ctermbg=241 guibg=grey40
    CSAhi DiffAdd term=bold ctermbg=18 guibg=DarkBlue
    CSAhi DiffChange term=bold ctermbg=90 guibg=DarkMagenta
    CSAhi DiffDelete term=bold cterm=bold ctermbg=30 ctermfg=21 gui=bold guibg=DarkCyan guifg=Blue
    CSAhi DiffText term=reverse cterm=bold ctermbg=196 gui=bold guibg=Red
    CSAhi Directory term=bold ctermfg=51 guifg=Cyan
    CSAhi Error term=reverse ctermbg=196 ctermfg=231 guibg=Red guifg=White
    CSAhi ErrorMsg term=standout ctermbg=196 ctermfg=231 guibg=Red guifg=White
    CSAhi FoldColumn term=standout ctermbg=250 ctermfg=18 guibg=Grey guifg=DarkBlue
    CSAhi Folded term=standout ctermbg=252 ctermfg=18 guibg=LightGrey guifg=DarkBlue
    CSAhi Identifier term=underline ctermfg=87 guifg=#40ffff
      CSAlink Function Identifier
    CSAhi Ignore ctermfg=236 guifg=grey20
    CSAhi IncSearch term=reverse cterm=reverse gui=reverse
    CSAhi LineNr term=underline ctermfg=226 guifg=Yellow
    CSAhi MatchParen term=reverse ctermbg=51 guibg=Cyan
    CSAhi ModeMsg term=bold cterm=bold gui=bold
    CSAhi MoreMsg term=bold cterm=bold ctermfg=29 gui=bold guifg=SeaGreen
    CSAhi NonText term=bold cterm=bold ctermbg=239 ctermfg=152 gui=bold guibg=grey30 guifg=LightBlue
    CSAhi Pmenu ctermbg=219 guibg=LightMagenta
    CSAhi PmenuSbar ctermbg=250 guibg=Grey
    CSAhi PmenuSel ctermbg=250 guibg=Grey
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermfg=213 guifg=#ff80ff
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=46 gui=bold guifg=Green
    CSAhi Search term=reverse ctermbg=226 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi SignColumn term=standout ctermbg=250 ctermfg=18 guibg=Grey guifg=DarkBlue
    CSAhi Special term=bold ctermbg=232 ctermfg=214 guibg=grey5 guifg=Orange
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermfg=51 guifg=Cyan
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=196 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=21 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=30 gui=undercurl guisp=DarkCyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=201 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold cterm=bold ctermfg=227 gui=bold guifg=#ffff60
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Label Statement
      CSAlink Operator Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse cterm=bold,reverse gui=bold,reverse
    CSAhi StatusLineNC term=reverse cterm=reverse gui=reverse
    CSAhi TabLine term=underline cterm=underline ctermbg=252 gui=underline guibg=LightGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=201 gui=bold guifg=Magenta
    CSAhi Todo term=standout ctermbg=226 ctermfg=21 guibg=Yellow guifg=Blue
    CSAhi Type term=underline cterm=bold ctermfg=83 gui=bold guifg=#60ff60
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=111 gui=underline guifg=#80a0ff
    CSAhi VertSplit term=reverse cterm=reverse gui=reverse
    CSAhi Visual term=reverse ctermbg=246 guibg=grey60
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WarningMsg term=standout ctermfg=196 guifg=Red
    CSAhi WildMenu term=standout ctermbg=226 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi lCursor ctermbg=51 ctermfg=16 guibg=Cyan guifg=Black

    if &term =~# "^xterm" || &term =~# "^screen"
        " that's an ambiguous terminal setting
        if (exists("g:CSApprox_konsole") && g:CSApprox_konsole) || (&term =~? "^konsole" && s:old_kde())
        elseif (exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
        endif
    endif

elseif &t_Co == 88
    CSAhi Normal ctermbg=80 ctermfg=79 guibg=grey20 guifg=White
    CSAhi ColorColumn term=reverse ctermbg=74 guibg=LightRed
    CSAhi Comment term=bold ctermfg=39 guifg=#80a0ff
    CSAhi Conceal ctermbg=84 ctermfg=86 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline ctermbg=16 ctermfg=69 guibg=grey5 guifg=#ffa0a0
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink Float Constant
      CSAlink Number Constant
      CSAlink String Constant
    CSAhi Cursor ctermbg=28 ctermfg=16 guibg=Green guifg=Black
    CSAhi CursorColumn term=reverse ctermbg=81 guibg=grey40
    CSAhi CursorLine term=underline ctermbg=81 guibg=grey40
    CSAhi DiffAdd term=bold ctermbg=17 guibg=DarkBlue
    CSAhi DiffChange term=bold ctermbg=33 guibg=DarkMagenta
    CSAhi DiffDelete term=bold cterm=bold ctermbg=21 ctermfg=19 gui=bold guibg=DarkCyan guifg=Blue
    CSAhi DiffText term=reverse cterm=bold ctermbg=64 gui=bold guibg=Red
    CSAhi Directory term=bold ctermfg=31 guifg=Cyan
    CSAhi Error term=reverse ctermbg=64 ctermfg=79 guibg=Red guifg=White
    CSAhi ErrorMsg term=standout ctermbg=64 ctermfg=79 guibg=Red guifg=White
    CSAhi FoldColumn term=standout ctermbg=85 ctermfg=17 guibg=Grey guifg=DarkBlue
    CSAhi Folded term=standout ctermbg=86 ctermfg=17 guibg=LightGrey guifg=DarkBlue
    CSAhi Identifier term=underline ctermfg=31 guifg=#40ffff
      CSAlink Function Identifier
    CSAhi Ignore ctermfg=80 guifg=grey20
    CSAhi IncSearch term=reverse cterm=reverse gui=reverse
    CSAhi LineNr term=underline ctermfg=76 guifg=Yellow
    CSAhi MatchParen term=reverse ctermbg=31 guibg=Cyan
    CSAhi ModeMsg term=bold cterm=bold gui=bold
    CSAhi MoreMsg term=bold cterm=bold ctermfg=21 gui=bold guifg=SeaGreen
    CSAhi NonText term=bold cterm=bold ctermbg=81 ctermfg=58 gui=bold guibg=grey30 guifg=LightBlue
    CSAhi Pmenu ctermbg=75 guibg=LightMagenta
    CSAhi PmenuSbar ctermbg=85 guibg=Grey
    CSAhi PmenuSel ctermbg=85 guibg=Grey
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermfg=71 guifg=#ff80ff
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=28 gui=bold guifg=Green
    CSAhi Search term=reverse ctermbg=76 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi SignColumn term=standout ctermbg=85 ctermfg=17 guibg=Grey guifg=DarkBlue
    CSAhi Special term=bold ctermbg=16 ctermfg=68 guibg=grey5 guifg=Orange
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermfg=31 guifg=Cyan
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=64 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=19 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=21 gui=undercurl guisp=DarkCyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=67 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold cterm=bold ctermfg=77 gui=bold guifg=#ffff60
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Label Statement
      CSAlink Operator Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse cterm=bold,reverse gui=bold,reverse
    CSAhi StatusLineNC term=reverse cterm=reverse gui=reverse
    CSAhi TabLine term=underline cterm=underline ctermbg=86 gui=underline guibg=LightGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=67 gui=bold guifg=Magenta
    CSAhi Todo term=standout ctermbg=76 ctermfg=19 guibg=Yellow guifg=Blue
    CSAhi Type term=underline cterm=bold ctermfg=45 gui=bold guifg=#60ff60
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=39 gui=underline guifg=#80a0ff
    CSAhi VertSplit term=reverse cterm=reverse gui=reverse
    CSAhi Visual term=reverse ctermbg=84 guibg=grey60
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WarningMsg term=standout ctermfg=64 guifg=Red
    CSAhi WildMenu term=standout ctermbg=76 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi lCursor ctermbg=31 ctermfg=16 guibg=Cyan guifg=Black
endif

delcommand CSAlink
delfunction s:CSAlink
delcommand CSAhi
delfunction s:CSAhi
let syntax_cmd="on"
