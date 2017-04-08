if exists("b:current_syntax")
    finish
endif

let b:current_syntax = "choicescript"

setlocal iskeyword+=#
setlocal iskeyword+=*

syntax match csOption '#.*$'

syntax keyword csCond *if *else *elseif *elsif *selectable_if 

syntax keyword csRare *delete *allow_reuse *goto_random_scene *share_this_game *link *more_games *print *script *check_achievements

syntax keyword csGoto *ending *finish *gosub *gosub_scene *goto_scene *goto *gotoref *return

syntax keyword csChoice *choice *fake_choice

syntax keyword csReuse *disable_reuse *hide_reuse 

syntax keyword csSet *create *temp *set *setref 

syntax keyword csOther *input_text *input_number *image *line_break *page_break *rand *stat_chart *achieve *achievement

syntax keyword csLabel *label 

syntax match csComment '^\s*\*comment.*$'

syntax region csText start="^\s*[^#* \t]" end="^\s*\(\*page_break\)\@!\*"me=s-1,he=s-1,re=s-1 fold contains=csOther
"syntax region csChoice start="\*choice"

hi def link csOption	Special
hi def link csCond	Statement
hi def link csRare	Todo	
hi def link csGoto	Constant
hi def link csChoice	Identifier
hi def link csReuse	Type	 
hi def link csSet	Keyword	
hi def link csOther	PreProc
hi def link csLabel 	Function
hi def link csComment 	Comment

hi Comment guifg=green gui=italic
hi Identifier gui=bold 
hi Constant gui=bold
hi Statement guifg=blue
hi Function guifg=orange gui=bold
hi Keyword guifg=maroon gui=bold
hi Special gui=bold

set foldmethod=syntax
"set foldlevelstart=1
"set nofoldenable
":autocmd BufWinEnter * let &foldlevel = max(map(range(1, line('$')), 'foldlevel(v:val)'))
autocmd BufWinEnter * silent! :%foldopen!

" Highlight mixed tabs with spaces
highlight ExtraWhitespace ctermbg=red guibg=red
au InsertEnter * match ExtraWhitespace /\(\t \| \t\)/

"Load ChoiceScript functions 
source ~/.vim/choicefuncs.vim

