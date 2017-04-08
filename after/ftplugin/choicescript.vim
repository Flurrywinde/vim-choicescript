" Vim indent file
" Language:    ChoiceScript
" Maintainer:  Kanon Kubose <kanon11@yahoo.com>
" Created:     2015 May 17
" Last Change: 2015 May 17

if exists("b:did_indent")
	"finish
endif
let b:did_indent = 1

setlocal indentexpr=GetCSIndent(v:lnum)
setlocal indentkeys& 
setlocal indentkeys+==*choice,==*if,==#,==*elseif,==*elsif,==*else,==*fake_choice,==*stat_chart
setlocal indentkeys+==achievement

if exists("*GetCSIndent")
	"finish
endif

function! GetCSIndent( line_num )
	" Line 0 always goes at column 0
	if a:line_num == 0
		return 0
	endif

	let this_codeline = getline( a:line_num )
	let prev_codeline_num = prevnonblank( a:line_num - 1 )
	let prev_codeline = getline( prev_codeline_num )
	let indnt = indent( prev_codeline_num )

	if prev_codeline =~ '^\s*\*choice'
		return indnt + &shiftwidth
	endif
	if prev_codeline =~ '^\s*\*if'
		return indnt + &shiftwidth
	endif
	if prev_codeline =~ '^\s*#'
		return indnt + &shiftwidth
	endif
	if prev_codeline =~ '^\s*\*elseif'
		return indnt + &shiftwidth
	endif
	if prev_codeline =~ '^\s*\*elsif'
		return indnt + &shiftwidth
	endif
	if prev_codeline =~ '^\s*\*else'
		return indnt + &shiftwidth
	endif
	if prev_codeline =~ '^\s*\*fake_choice'
		return indnt + &shiftwidth
	endif
	if prev_codeline =~ '^\s*\*stat_chart'
		return indnt + &shiftwidth
	endif
	if prev_codeline =~ '^\s*\*achievement'
		return indnt + &shiftwidth
	endif
	if prev_codeline =~ '^\s*\*selectable_if'
		return indnt + &shiftwidth
	endif
	if prev_codeline =~ '^\s*\*hide_reuse'
		return indnt + &shiftwidth
	endif
	if prev_codeline =~ '^\s*\*disable_reuse'
		return indnt + &shiftwidth
	endif
	if prev_codeline =~ '^\s*\*goto'
		return indnt - &shiftwidth
	endif
	if prev_codeline =~ '^\s*\*goto_scene'
		return indnt - &shiftwidth
	endif
	if prev_codeline =~ '^\s*\*finish'
		return indnt - &shiftwidth
	endif
	if prev_codeline =~ '^\s*\*ending'
		return indnt - &shiftwidth
	endif


	"else
	return indnt
endfunction


