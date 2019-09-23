if exists("b:current_syntax")
    finish
endif

let b:current_syntax = "choicescript"

setlocal iskeyword+=#
setlocal iskeyword+=*

syntax match csComment '^\s*\*comment.*$'

syntax match csOption '#.*$'

syntax keyword csCond *if *else *elseif *elsif *selectable_if 

syntax keyword csRare *delete *allow_reuse *goto_random_scene *share_this_game *link *more_games *print *script *check_achievements *params *bug

syntax keyword csGoto *ending *finish *gosub *gosub_scene *goto_scene *goto *gotoref *return *goto_random_scene

syntax keyword csChoice *choice *fake_choice

syntax keyword csReuse *disable_reuse *hide_reuse 

syntax keyword csSet *create *temp *set *setref 

syntax keyword csOther *input_text *input_number *image *line_break *page_break *rand *stat_chart *achieve *achievement *text_image

syntax keyword csLabel *label

syntax keyword csSetup *title *author *scene_list

"smPlugin.js and smPlugimMenuAddon.js support
syn keyword csSmPlugin *sm_init *sm_menuaddon *sm_menuaddon *sm_save *sm_load *sm_delete

syntax match csBool '\(true\|false\)'

"Why doesn't this work?
"syntax match csBool '^\s*\*set\s\+\S\+\s\+\zs\(true\|false\)'

syn match choicescriptPipe contained '|'

syn region choicescriptInternalInterpolation start="\$!\{,2}{" skip="\\}" end="}" transparent contains=choicescriptConditionalInterpolation
syn region choicescriptInterpolation start="\$!\{,2}{" skip="\\}" end="}"
syn region choicescriptConditionalInterpolation start="@{" skip="\\}" end="}" contains=choicescriptInterpolation,choicescriptPipe,choicescriptConditional,choicescriptBold,choicescriptItalic,choicescriptItalicBold,choicescriptBoldItalic

syn region choicescriptBold matchgroup=choicescriptOption start="\[b\]" end="\[/b\]" contains=choicescriptInterpolation
syn region choicescriptItalic matchgroup=choicescriptOption start="\[i\]" end="\[/i\]" contains=choicescriptInterpolation
syn region choicescriptItalicBold matchgroup=choicescriptOption start="\[i\]\[b\]" end="\[/b\]\[/i\]" contains=choicescriptInterpolation
syn region choicescriptBoldItalic matchgroup=choicescriptOption start="\[b\]\[i\]" end="\[/i\]\[/b\]" contains=choicescriptInterpolation

" this could be more thoroughly checked for matching parens but I think it's
" okay
syn region choicescriptConditional start="(" end=")" contains=choicescriptConditional

" Foldable region. \@! means atom before must not match (i.e. will fold
" *page_breaks but region ends at any other *command
syntax region csText start="^\s*[^#* \t]" end="^\s*\(\*page_break\)\@!\ze[*#]"me=s-1,he=s-1,re=s-1 fold contains=csOther,choicescriptBoldItalic,choicescriptItalicBold,choicescriptItalic,choicescriptBold,choicescriptInternalInterpolation,choicescriptConditionalInterpolation,choicescriptInterpolation

" syntax region csParagraph start='^\s*[^#* \t][^\n]*' end="\n" fold   # csText no longer works, and these won't fold despite fmt=0    " What was I try to do? Fold individual paragraphs?

"syntax region csChoice start="\*choice"   " Looks like I was trying to define
"a foldable *choice region

hi def link csOption	Special
hi def link csCond		Statement
hi def link csRare		Exception
hi def link csGoto		Constant
hi def link csChoice	Identifier
hi def link csReuse		Type
hi def link csSet		Conditional	
hi def link csOther		Repeat
hi def link csLabel		Label
hi def link csComment	Comment
hi def link csSetup		PreProc
hi def link csSmPlugin	Function
hi def link csBool		Boolean

" hi Comment guifg=green gui=italic
hi Comment gui=italic
hi Identifier gui=bold 
hi Constant gui=bold
hi Statement guifg=blue
hi Function guifg=orange gui=bold
hi Keyword guifg=maroon gui=bold
hi Special gui=bold

hi def link choicescriptInterpolation   Statement
highlight choicescriptConditionalInterpolation ctermfg=darkgreen guifg=darkgreen
highlight choicescriptPipe ctermfg=blue guifg=blue cterm=bold gui=bold

hi link choicescriptBoldItalic choicescriptItalicBold

hi def choicescriptItalic               term=italic cterm=italic gui=italic
hi def choicescriptBold                 term=bold cterm=bold gui=bold
hi def choicescriptItalicBold           term=italic,bold cterm=italic,bold gui=italic,bold

set foldmethod=syntax
set fml=0
"set foldlevelstart=1
"set nofoldenable
":autocmd BufWinEnter * let &foldlevel = max(map(range(1, line('$')), 'foldlevel(v:val)'))
autocmd BufWinEnter * silent! :%foldopen!

" Highlight mixed tabs with spaces
highlight ExtraWhitespace ctermbg=red guibg=red
au InsertEnter * match ExtraWhitespace /\(\t \| \t\)/

"Load ChoiceScript functions 
source ~/.vim/choicefuncs.vim
