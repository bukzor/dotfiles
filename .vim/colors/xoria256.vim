" Vim color file
"
" Name:       xoria256.vim
" Version:    1.5
" Maintainer:	Dmitriy Y. Zotikov (xio) <xio@ungrund.org>
"
" Should work in recent 256 color terminals.  88-color terms like urxvt are
" NOT supported.
"
" Don't forget to install 'ncurses-term' and set TERM to xterm-256color or
" similar value.
"
" Color numbers (0-255) see:
" http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
"
" For a specific filetype highlighting rules issue :syntax list when a file of
" that type is opened.

" Initialization {{{

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let colors_name = "xoria256"

"}}}
" Colours {{{1
"" General {{{2
hi Normal       guifg=#d0d0d0 guibg=#1c1c1c gui=none
hi Cursor       guibg=#ffaf00
hi CursorColumn guibg=#444444
hi CursorLine   guibg=#3a3a3a gui=none
hi Error        guifg=#ffffff guibg=#800000
hi ErrorMsg     guifg=#ffffff guibg=#800000
hi FoldColumn   guifg=#9e9e9e guibg=#121212
hi Folded       guifg=#eeeeee guibg=#5f5f87
hi IncSearch    guifg=#000000 guibg=#ffdfaf gui=none
hi LineNr       guifg=#9e9e9e guibg=#121212
hi MatchParen   guifg=#dfdfdf guibg=#5f87df gui=bold
" TODO
" hi MoreMsg
hi NonText      guifg=#9e9e9e guibg=#121212 gui=bold
hi Pmenu        guifg=#000000 guibg=#bcbcbc
hi PmenuSel     guifg=#eeeeee guibg=#767676
hi PmenuSbar    guibg=#d0d0d0
hi PmenuThumb   guifg=#767676
hi Search       guifg=#000000 guibg=#afdf5f
hi SignColumn   guifg=#a8a8a8
hi SpecialKey   guifg=#5fdf5f
hi SpellBad     guifg=fg      guisp=#df0000
hi SpellCap     guifg=#dfdfff guibg=bg      gui=underline
hi SpellRare    guifg=#df5f87 guibg=bg      gui=underline
hi SpellLocal   guifg=#875fdf guibg=bg      gui=underline
hi StatusLine   guifg=#ffffff guibg=#4e4e4e gui=bold
hi StatusLineNC guifg=#b2b2b2 guibg=#3a3a3a gui=none
hi TabLine      guifg=fg      guibg=#666666 gui=none
hi TabLineFill  guifg=fg      guibg=#3a3a3a gui=none
" FIXME
hi Title        guifg=#ffdfff
hi Todo         guifg=#000000 guibg=#dfdf00
hi Underlined   guifg=#00afff                           gui=underline
hi VertSplit    guifg=#3a3a3a guibg=#3a3a3a gui=none
" hi VIsualNOS    guifg=#005f87 guibg=#afdfff gui=none
" hi Visual       guifg=#005f87 guibg=#afdfff
hi Visual       guifg=#eeeeee guibg=#875f87
" hi Visual       guifg=#eeeeee guibg=#005f87
hi VisualNOS    guifg=#eeeeee guibg=#5f5f87
hi WildMenu     guifg=#000000 guibg=#afdf87 gui=bold

"" Syntax highlighting {{{2
hi Comment      guifg=#808080
hi Constant     guifg=#ffffaf
hi Identifier   guifg=#dfafdf                           
hi Ignore       guifg=#444444
hi Number       guifg=#dfaf87
hi PreProc      guifg=#afdf87
hi Special      guifg=#df8787
hi Statement    guifg=#87afdf                           gui=none
hi Type         guifg=#afafdf                           gui=none

"" Special {{{2
""" .diff {{{3
hi diffAdded    guifg=#afdf87
hi diffRemoved  guifg=#df8787
""" vimdiff {{{3
hi diffAdd      guifg=bg      guibg=#afdfaf
"hi diffDelete   guifg=bg      guibg=#dfdf87 gui=none
hi diffDelete   guifg=bg      guibg=#949494 gui=none
hi diffChange   guifg=bg      guibg=#dfafaf
hi diffText     guifg=bg      guibg=#df8787 gui=none
""" HTML {{{3
hi htmlTag      guifg=#afafdf
hi htmlEndTag   guifg=#afafdf
hi htmlArg	guifg=#dfafdf
hi htmlValue	guifg=#dfdfaf
""" NERDTree {{{3
hi Directory      guifg=#87afdf
hi treeCWD        guifg=#dfaf87
hi treeClosable   guifg=#df8787
hi treeOpenable   guifg=#afdf87
hi treePart       guifg=#808080
hi treeDirSlash   guifg=#808080
hi treeLink       guifg=#dfafdf

""" VimDebug {{{3
" FIXME
" you may want to set SignColumn highlight in your .vimrc
" :help sign
" :help SignColumn

" hi currentLine term=reverse gui=reverse
" hi breakPoint  term=NONE    gui=NONE
" hi empty       term=NONE    gui=NONE

" sign define currentLine linehl=currentLine
" sign define breakPoint  linehl=breakPoint  text=>>
" sign define both        linehl=currentLine text=>>
" sign define empty       linehl=empty

