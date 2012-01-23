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
    CSAhi Normal ctermbg=223 ctermfg=16 guibg=PeachPuff guifg=Black
    CSAhi ColorColumn term=reverse ctermbg=217 guibg=LightRed
    CSAhi Comment term=bold ctermfg=60 guifg=#406090
    CSAhi Conceal ctermbg=248 ctermfg=252 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline ctermfg=125 guifg=#c00058
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink Float Constant
      CSAlink Number Constant
      CSAlink String Constant
    CSAhi Cursor ctermbg=16 ctermfg=223 guibg=fg guifg=bg
    CSAhi CursorColumn term=reverse ctermbg=254 guibg=Grey90
    CSAhi CursorLine term=underline ctermbg=254 guibg=Grey90
    CSAhi DiffAdd term=bold ctermbg=231 guibg=White
    CSAhi DiffChange term=bold ctermbg=218 guibg=#edb5cd
    CSAhi DiffDelete term=bold cterm=bold ctermbg=224 ctermfg=152 gui=bold guibg=#f6e8d0 guifg=LightBlue
    CSAhi DiffText term=reverse cterm=bold ctermbg=209 gui=bold guibg=#ff8060
    CSAhi Directory term=bold ctermfg=21 guifg=Blue
    CSAhi Error term=reverse cterm=bold ctermbg=196 ctermfg=231 gui=bold guibg=Red guifg=White
    CSAhi ErrorMsg term=standout cterm=bold ctermbg=196 ctermfg=231 gui=bold guibg=Red guifg=White
    CSAhi FoldColumn term=standout ctermbg=252 ctermfg=18 guibg=Gray80 guifg=DarkBlue
    CSAhi Folded term=standout ctermbg=181 ctermfg=16 guibg=#e3c1a5 guifg=Black
    CSAhi Identifier term=underline ctermfg=30 guifg=DarkCyan
      CSAlink Function Identifier
    CSAhi Ignore ctermfg=223 guifg=bg
    CSAhi IncSearch term=reverse cterm=reverse gui=reverse
    CSAhi LineNr term=underline ctermfg=160 guifg=Red3
    CSAhi MatchParen term=reverse ctermbg=51 guibg=Cyan
    CSAhi ModeMsg term=bold cterm=bold gui=bold
    CSAhi MoreMsg term=bold cterm=bold ctermfg=29 gui=bold guifg=SeaGreen
    CSAhi NonText term=bold cterm=bold ctermfg=21 gui=bold guifg=Blue
    CSAhi Pmenu ctermbg=219 guibg=LightMagenta
    CSAhi PmenuSbar ctermbg=250 guibg=Grey
    CSAhi PmenuSel ctermbg=250 guibg=Grey
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermfg=164 guifg=Magenta3
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=29 gui=bold guifg=SeaGreen
    CSAhi Search term=reverse ctermbg=220 guibg=Gold2
    CSAhi SignColumn term=standout ctermbg=250 ctermfg=18 guibg=Grey guifg=DarkBlue
    CSAhi Special term=bold ctermfg=62 guifg=SlateBlue
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermfg=21 guifg=Blue
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=196 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=21 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=30 gui=undercurl guisp=DarkCyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=201 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold cterm=bold ctermfg=124 gui=bold guifg=Brown
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Label Statement
      CSAlink Operator Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse cterm=bold ctermbg=16 ctermfg=231 gui=bold guibg=Black guifg=White
    CSAhi StatusLineNC term=reverse cterm=bold ctermbg=243 ctermfg=223 gui=bold guibg=Gray45 guifg=PeachPuff
    CSAhi TabLine term=underline cterm=underline ctermbg=252 gui=underline guibg=LightGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=162 gui=bold guifg=DeepPink3
    CSAhi Todo term=standout ctermbg=226 ctermfg=21 guibg=Yellow guifg=Blue
    CSAhi Type term=underline cterm=bold ctermfg=29 gui=bold guifg=SeaGreen
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=62 gui=underline guifg=SlateBlue
    CSAhi VertSplit term=reverse cterm=bold ctermbg=243 ctermfg=231 gui=bold guibg=Gray45 guifg=White
    CSAhi Visual term=reverse cterm=reverse ctermbg=16 ctermfg=252 gui=reverse guibg=fg guifg=Grey80
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WarningMsg term=standout cterm=bold ctermfg=196 gui=bold guifg=Red
    CSAhi WildMenu term=standout ctermbg=226 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi lCursor ctermbg=16 ctermfg=223 guibg=fg guifg=bg

    if &term =~# "^xterm" || &term =~# "^screen"
        " that's an ambiguous terminal setting
        if (exists("g:CSApprox_konsole") && g:CSApprox_konsole) || (&term =~? "^konsole" && s:old_kde())
        elseif (exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
        endif
    endif

elseif &t_Co == 88
    CSAhi Normal ctermbg=74 ctermfg=16 guibg=PeachPuff guifg=Black
    CSAhi ColorColumn term=reverse ctermbg=74 guibg=LightRed
    CSAhi Comment term=bold ctermfg=21 guifg=#406090
    CSAhi Conceal ctermbg=84 ctermfg=86 guibg=DarkGrey guifg=LightGrey
    CSAhi Constant term=underline ctermfg=49 guifg=#c00058
      CSAlink Boolean Constant
      CSAlink Character Constant
      CSAlink Float Constant
      CSAlink Number Constant
      CSAlink String Constant
    CSAhi Cursor ctermbg=16 ctermfg=74 guibg=fg guifg=bg
    CSAhi CursorColumn term=reverse ctermbg=87 guibg=Grey90
    CSAhi CursorLine term=underline ctermbg=87 guibg=Grey90
    CSAhi DiffAdd term=bold ctermbg=79 guibg=White
    CSAhi DiffChange term=bold ctermbg=74 guibg=#edb5cd
    CSAhi DiffDelete term=bold cterm=bold ctermbg=78 ctermfg=58 gui=bold guibg=#f6e8d0 guifg=LightBlue
    CSAhi DiffText term=reverse cterm=bold ctermbg=69 gui=bold guibg=#ff8060
    CSAhi Directory term=bold ctermfg=19 guifg=Blue
    CSAhi Error term=reverse cterm=bold ctermbg=64 ctermfg=79 gui=bold guibg=Red guifg=White
    CSAhi ErrorMsg term=standout cterm=bold ctermbg=64 ctermfg=79 gui=bold guibg=Red guifg=White
    CSAhi FoldColumn term=standout ctermbg=58 ctermfg=17 guibg=Gray80 guifg=DarkBlue
    CSAhi Folded term=standout ctermbg=57 ctermfg=16 guibg=#e3c1a5 guifg=Black
    CSAhi Identifier term=underline ctermfg=21 guifg=DarkCyan
      CSAlink Function Identifier
    CSAhi Ignore ctermfg=74 guifg=bg
    CSAhi IncSearch term=reverse cterm=reverse gui=reverse
    CSAhi LineNr term=underline ctermfg=48 guifg=Red3
    CSAhi MatchParen term=reverse ctermbg=31 guibg=Cyan
    CSAhi ModeMsg term=bold cterm=bold gui=bold
    CSAhi MoreMsg term=bold cterm=bold ctermfg=21 gui=bold guifg=SeaGreen
    CSAhi NonText term=bold cterm=bold ctermfg=19 gui=bold guifg=Blue
    CSAhi Pmenu ctermbg=75 guibg=LightMagenta
    CSAhi PmenuSbar ctermbg=85 guibg=Grey
    CSAhi PmenuSel ctermbg=85 guibg=Grey
    CSAhi PmenuThumb cterm=reverse gui=reverse
    CSAhi PreProc term=underline ctermfg=50 guifg=Magenta3
      CSAlink Define PreProc
      CSAlink Include PreProc
      CSAlink Macro PreProc
      CSAlink PreCondit PreProc
    CSAhi Question term=standout cterm=bold ctermfg=21 gui=bold guifg=SeaGreen
    CSAhi Search term=reverse ctermbg=72 guibg=Gold2
    CSAhi SignColumn term=standout ctermbg=85 ctermfg=17 guibg=Grey guifg=DarkBlue
    CSAhi Special term=bold ctermfg=38 guifg=SlateBlue
      CSAlink Debug Special
      CSAlink Delimiter Special
      CSAlink SpecialChar Special
      CSAlink SpecialComment Special
      CSAlink Tag Special
    CSAhi SpecialKey term=bold ctermfg=19 guifg=Blue
    CSAhi SpellBad term=reverse cterm=undercurl ctermfg=64 gui=undercurl guisp=Red
    CSAhi SpellCap term=reverse cterm=undercurl ctermfg=19 gui=undercurl guisp=Blue
    CSAhi SpellLocal term=underline cterm=undercurl ctermfg=21 gui=undercurl guisp=DarkCyan
    CSAhi SpellRare term=reverse cterm=undercurl ctermfg=67 gui=undercurl guisp=Magenta
    CSAhi Statement term=bold cterm=bold ctermfg=32 gui=bold guifg=Brown
      CSAlink Conditional Statement
      CSAlink Exception Statement
      CSAlink Keyword Statement
      CSAlink Label Statement
      CSAlink Operator Statement
      CSAlink Repeat Statement
    CSAhi StatusLine term=bold,reverse cterm=bold ctermbg=16 ctermfg=79 gui=bold guibg=Black guifg=White
    CSAhi StatusLineNC term=reverse cterm=bold ctermbg=82 ctermfg=74 gui=bold guibg=Gray45 guifg=PeachPuff
    CSAhi TabLine term=underline cterm=underline ctermbg=86 gui=underline guibg=LightGrey
    CSAhi TabLineFill term=reverse cterm=reverse gui=reverse
    CSAhi TabLineSel term=bold cterm=bold gui=bold
    CSAhi Title term=bold cterm=bold ctermfg=49 gui=bold guifg=DeepPink3
    CSAhi Todo term=standout ctermbg=76 ctermfg=19 guibg=Yellow guifg=Blue
    CSAhi Type term=underline cterm=bold ctermfg=21 gui=bold guifg=SeaGreen
      CSAlink StorageClass Type
      CSAlink Structure Type
      CSAlink Typedef Type
    CSAhi Underlined term=underline cterm=underline ctermfg=38 gui=underline guifg=SlateBlue
    CSAhi VertSplit term=reverse cterm=bold ctermbg=82 ctermfg=79 gui=bold guibg=Gray45 guifg=White
    CSAhi Visual term=reverse cterm=reverse ctermbg=16 ctermfg=58 gui=reverse guibg=fg guifg=Grey80
    CSAhi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
    CSAhi WarningMsg term=standout cterm=bold ctermfg=64 gui=bold guifg=Red
    CSAhi WildMenu term=standout ctermbg=76 ctermfg=16 guibg=Yellow guifg=Black
    CSAhi lCursor ctermbg=16 ctermfg=74 guibg=fg guifg=bg
endif

delcommand CSAlink
delfunction s:CSAlink
delcommand CSAhi
delfunction s:CSAhi
let syntax_cmd="on"
