let s:allGotoGosubs = {}

"Make empty scenes for each option in preceeding *choice block.
inoremap <C-P> <ESC><ESC>:call MakeChoices()<CR>:noh<CR>
noremap <silent> <Space>mc :call MakeChoices()<CR>:noh<CR>

" Find parent
nnoremap <Space>fp :set nohlsearch\|:call ChoiceScriptFindParent()<CR>

"Find child
nnoremap <Space>fc :call ChoiceScriptFindChild()<CR>

" Check if new *goto label already exists
"inoremap <C-Y> <C-O>:call ChoiceScriptCheckLabel()<CR>  <-- conflicts with
"i_ctrl-y
nnoremap <space>cl :call ChoiceScriptCheckLabel()<CR>

"Search for next unfinished area
nnoremap <Space>uf /\(\*label \S\+\n\[This\)\\|\(\[[^ibT/]\)<CR>

"Search backwards for "*goto <word under cursor>", then go to previous label. (This is
"good for jumping to the context a *label's called from.)
noremap <C-U> ?\*goto zb?\*labelw	

"Search backwards for "*label <word under cursor>"
"noremap <C-Y> ?\*label 	

"Print empty label
"inoremap <C-L> *label [This option is yet to be written.]
"inoremap <C-L> [This option is yet to be written.]

"Jump to name of previous empty label (not needed anymore due to super duper
"function)
"noremap <C-P> ?\*label \n$a

"Jump to achievement section, situations section, and back.
noremap <leader>ja <esc><esc>:vnew <C-R>=expand("%:p:h")."/startup.txt"<CR><CR>/\*comment \*\*      STATS      \*\*<cr>:noh<cr>kko<BS>*achievement name visible 5 AchievementTitlePre-achievement text.Post-achievement text.<esc>kkkw
noremap <leader>js <esc><esc>:vnew <C-R>=expand("%:p:h")."/startup.txt"<CR><CR>/\*comment \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*<cr>:noh<cr>k
noremap <leader>jb <esc><esc>:hide<cr>:set columns=80<cr>

" Bold and italics: Stands for formatting-bold, formatting-italics, etc.
nnoremap <Space>fb a[b][/b]<esc>F[i
nnoremap <Space>fi a[i][/i]<esc>F[i

"Construct *label blocks from *choice block just above cursor
function! MakeChoices()

"BUG: doesn't work if no whitespace after choice block. Check for eof. Also
"doesn't work if *choice is nested, like inside an *if.

	" If Fast Move mode is on, turn it off
    if (g:fastMoveMode == 1)
		call ToggleFastMoveMode()
	endif

	"If EasyMotion remappings are on, turn off
	if (g:easymotionMode == 1)
		call ToggleEasyMotionMode()
		let changedEasyMotionMode = 1
	else
		let changedEasyMotionMode = 0
	endif
	
	:let save_view = winsaveview()
	let start = line('.')

	"Locate previous *choice. (b=backwards, W=nowrap, n=doNot move cursor)
	let choiceStartLine = search('^*choice', 'bW')

	if !choiceStartLine
		echo "No *choice found. (*choice must not be indented. This is to avoid finding *choice blocks nested in another *choice block.)"
		return -1
	endif
	"return getline(target_line_num, target_line_num+4)
	"Locate end of *choice block
	"echo getline(choiceStartLine, choiceStartLine+2)
	let choiceEndLine = search('^\S.*', 'W') "End is first line that starts with non-whitespace

	"Add blank line at bottom of file because I don't know how to regex EOF
	normal Go
	
	"If above search fails, might be at bottom of buffer
	if choiceEndLine == 0
		let choiceEndLine = search('^$', 'W') "End is first empty line
	endif

	"Now go back up to the last *goto
	let choiceEndLine = search('*goto', 'bW')
	
	"Get the entire *choice block and put it in gotoBlock
	let gotoBlock = getline(choiceStartLine, choiceEndLine)

	"Make labelArray (contains all labels to goto)
	let labelArray = []

	for cur in gotoBlock
		if match(cur, '*goto') != -1
			"echo 'cur: '.cur
			let curParsed = matchlist(cur, '*goto \(\S\+\)')
			"echo curParsed
			if len(curParsed) > 1
				let curLabel = curParsed[1]
			else
				echo 'ERROR: Bad *goto ('.cur.')'
				return -1
			endif
			call add(labelArray, curLabel)	
		endif
	endfor

	"Restore window to what it looked like (in case the searches scrolled
	"it)
	call winrestview(save_view)
	
	"Make newline after choice block if needed
	if strlen(getline(choiceEndLine+1)) > 0
		echo 'big line: '.getline(choiceEndLine+1)
		call cursor(choiceEndLine, 1)
		put=''
	endif

	call cursor(choiceEndLine+1, 1)

	"Put the new label blocks
	let firstlabel = ''
	let skippedLabels = ''
	let numNewLabels = 0
	let labelCount = 0
	for cur in labelArray
		let labelCount += 1
		if !search('*label '.cur.'\s*$', 'wn')
			if (labelCount == 1) 
				let firstlabel = cur
			endif
			let numNewLabels += 1
			put='*label '.cur
			put='[This option is yet to be written.]'
			if (labelCount == len(labelArray))
				"Put a goto firstlabel at end
				put='*comment Remove the following *goto when last option is filled in.'
				put='*goto '.firstlabel
			endif
			put=''
		else
			let skippedLabels .= cur.' '
		endif
	endfor

	"Remove trailing blank lines (Up to a point)
	let nextlines = getline(line('.')+1, line('.')+3)
	if len(nextlines) == 3
		if nextlines[0] == '' && nextlines[1] == '' && nextlines[2] == ''
			normal "_3dd
		elseif nextlines[0] == '' && nextlines[1] == ''
			normal "_2dd
		elseif nextlines[0] == ''
			normal "_dd
		endif
	endif

	"Move to first label's text (use ctrl-v ctrl-m to input the <CR> at
	"end)
	if numNewLabels != 0
		call cursor(choiceEndLine, 1)
		normal /\[This option is yet to be written.\]
		let @/='\[This option is yet to be written\.\]'
	endif
	
	"Print status message
	if len(skippedLabels) > 0
		echo 'Skipped: '.skippedLabels
	else
		echo 'New labels created: '.numNewLabels
	endif

	"If changed EasyMotion mode, change it back
	if changedEasyMotionMode
		" call ToggleEasyMotionMode()   Nah, I like it off.
	endif
endfunction

function! FindOrphanLabels()
	let start = line('.')
	let orphans = []
	call GetAllGotos()
	call GetAllGosubs()
	let allLabels = keys(s:allGotoGosubs)
	for cur in allLabels
		if !search('*label '.cur, 'w')
			call add(orphans, cur)
		endif
	endfor

	"call cursor(start, 1)
	"call MakeLabelBlocks(orphans)
	
	if len(orphans)
		let @z=string(orphans)
	endif
endfunction

function! GetNextZorphan()
	let ret = match(@z, '\S\+,')

	return ret
endfunction

function! MakeLabelBlocks(labels)
	let numNewLabels = 0
	for cur in labels
		let numNewLabels += 1
		put='*label '.cur
		put='[This option is yet to be written.]'
		put=''
	endfor
	return numNewLabels
endfunction

function! GetAllGotos()
	%g/\*goto \S\+/call GetGoto(getline('.'))
	"echo s:allGotoGosubs
endfunction

function! GetAllGosubs()
	%g/\*gosub \S\+/call GetGosub(getline('.'))
endfunction

function! GetGosub(line)
	if(stridx(a:line, '*gosub') != -1)
		let s:allGotoGosubs[matchstr(strpart(a:line, stridx(a:line, '*gosub')+7), '\S\+')] = ''
	endif
endfunction

function! GetGoto(line)
	"echo a:line
	let stridx = stridx(a:line, '*goto')
	"echo 'stridx: '.stridx
	let strpart = strpart(a:line, stridx+6)
	"echo 'strpart: '.strpart
	let match = matchstr(strpart, '\S\+')
	"echo 'match: '.match
	if(stridx(a:line, '*goto') != -1)
		"let s:allGotoGosubs[matchstr(strpart(a:line, stridx(a:line, '*goto')+6), '\S\+')] = ''

		let s:allGotoGosubs[match] = ''
	endif
endfunction

function! ChoiceScriptFindParent()
	" Put cursor on a label. Then call this function, and it'll goto the
	" scene that called it. Only goes to first one it finds if there are
	" more than one parent.
	let wordUnderCursor = expand("<cword>")
"	search('\*goto '.wordUnderCursor, 'bw')
"
"	Goto where came from and put it at bottom of screen
	normal ?\*goto \s*$zb
	"match WhiteOnRed "/     how put a var here?
	let @/='\*goto '.wordUnderCursor.'\s*$'
	set hlsearch

	call search('^$\|^\S', 'W')   "Goto end of choice block (to reposition page on screen)
	redraw
	call search('\*label', 'bW')  "Goto top of choice block
	normal w
endfunction

function! ChoiceScriptFindChild()
	normal ?\*label \s*$	
endfunction

function! ChoiceScriptCheckLabel()
	let wordUnderCursor = expand("<cword>")
	let labelLoc = search('\*label '.wordUnderCursor, 'cwn')
	if !labelLoc
		echo "New label (" . wordUnderCursor . ") is GOOD (meaning it doesn't exist yet)"
	else
		echo 'Label already exists on line '.labelLoc
	endif
endfunction

