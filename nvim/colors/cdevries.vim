" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Based on zellner.vim

set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "cdevries"

hi Comment term=bold ctermfg=DarkRed guifg=Red
hi Normal guifg=#111133 guibg=#f2eadb
hi Constant term=underline ctermfg=28 guifg=Green4
hi Special term=bold ctermfg=91 guifg=DarkMagenta
hi Identifier term=underline ctermfg=Blue guifg=Blue
hi Statement term=bold cterm=bold ctermfg=23 gui=NONE guifg=Brown
hi PreProc term=underline ctermfg=93 guifg=Purple
hi Type term=underline ctermfg=Blue gui=NONE guifg=Blue
hi Visual term=reverse ctermfg=Yellow ctermbg=Red gui=NONE guifg=Black guibg=Yellow
hi Search term=reverse ctermfg=Black ctermbg=Cyan gui=NONE guifg=Black guibg=Cyan
hi Tag term=bold ctermfg=DarkGreen guifg=DarkGreen
hi Error term=reverse ctermfg=15 ctermbg=9 guibg=Red guifg=White
hi Todo term=standout ctermbg=Yellow ctermfg=Black guifg=Blue guibg=Yellow
hi  StatusLine term=bold,reverse cterm=NONE ctermfg=Yellow ctermbg=DarkGray gui=NONE guifg=Yellow guibg=DarkGray
hi! link MoreMsg Comment
hi! link ErrorMsg Visual
hi! link WarningMsg ErrorMsg
hi! link Question Comment
hi link String	Constant
hi link Character	Constant
hi link Number	Constant
hi link Boolean	Constant
hi link Float		Number
hi link Function	Identifier
hi link Conditional	Statement
hi link Repeat	Statement
hi link Label		Statement
hi link Operator	Statement
hi link Keyword	Statement
hi link Exception	Statement
hi link Include	PreProc
hi link Define	PreProc
hi link Macro		PreProc
hi link PreCondit	PreProc
hi link StorageClass	Type
hi link Structure	Type
hi link Typedef	Type
hi link SpecialChar	Special
hi link Delimiter	Special
hi link SpecialComment Special
hi link Debug		Special
