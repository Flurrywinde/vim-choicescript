"Jump to stats section and back.
noremap <leader>js <esc><esc>:new <C-R>=expand("%:p:h")."/startup.txt"<CR><CR>G?\*create<cr>:noh<cr>
noremap <leader>jb <esc><esc>:hide<cr>:set columns=80<cr>

" Make Achievement
nnoremap <space>ma :call MakeAchievement()<cr>

"Make empty scenes for each option in preceeding *choice block.
inoremap <C-P> <ESC><ESC>:call MakeChoices()<CR>:noh<CR>
noremap <silent> <Space>mc :call MakeChoices()<CR>:noh<CR>

" Find parent
nnoremap <Space>fp :set nohlsearch\|:call ChoiceScriptFindParent()<CR>

" Find child
nnoremap <Space>fc :call ChoiceScriptFindChild()<CR>

" Check if new *goto label already exists
nnoremap <space>cl :call ChoiceScriptCheckLabel()<CR>

"Search for next unfinished area
nnoremap <Space>uf /\*label \S\+\n#.*doesn't exist yet. Going to the next one...<CR>

" Bold and italics: Stands for formatting-bold, formatting-italics, etc.
nnoremap <expr> <Space>fb col('.') == 1 ? 'i[b][/b]<esc>F[i' : 'a[b][/b]<esc>F[i' 
nnoremap <expr> <Space>fi col('.') == 1 ? 'i[i][/i]<esc>F[i' : 'a[i][/i]<esc>F[i' 

"Construct *label blocks from *choice block just above cursor
function! MakeChoices()

"BUG: Doesn't work if *choice is nested, like inside an *if. Will operate on
"first non-indented *choice it finds in reverse search instead.

	:let save_view = winsaveview()

	"Locate previous *choice. (b=backwards, W=nowrap, n=doNot move cursor)
	let choiceStartLine = search('^*choice', 'bW')

	if !choiceStartLine
		echo "No *choice found. (*choice must not be indented. This is to avoid finding *choice blocks nested in another *choice block.)"
		return -1
	endif
	"Locate end of *choice block
	let choiceEndLine = search('^\S.*', 'W') "End is first line that starts with non-whitespace

	"If above search fails, might be at bottom of buffer
	if choiceEndLine == 0
		call cursor(line('$'), 1000)   " 1000 should be enough. Put cursor on last column.
	endif

	"Now go back up to the last *goto
	let choiceEndLine = search('*goto', 'bW')
	
	"Get the entire *choice block and put it in gotoBlock
	let gotoBlock = getline(choiceStartLine, choiceEndLine)

	"labelArray contains all labels to goto, and optionArray contains the
	"options
	let labelArray = []
	let optionArray = []

	for cur in gotoBlock
		if match(cur, '^\s*#') != -1
			let curParsed = matchlist(cur, '#\(.\+\)')
			if len(curParsed) > 1
				let curOption = curParsed[1]
			else
				echo 'ERROR: Bad #option ('.cur.')'
				return -1
			endif
			call add(optionArray, curOption)	
		elseif match(cur, '*goto') != -1
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
	if choiceEndLine == line('$') || strlen(getline(choiceEndLine+1)) > 0
		" echo 'big line: '.getline(choiceEndLine+1)
		call cursor(choiceEndLine, 1)
		put=''
	else
		" Put cursor on next line after choice block (should be there also in
		" above case)
		call cursor(choiceEndLine+1, 1)
	endif

	"Put the new label blocks
	let skippedLabels = ''
	let numNewLabels = 0
	let labelCount = 0
	for cur in labelArray
		let lastSkipped = 0
		let curOption = optionArray[labelCount]
		let labelCount += 1
		if !search('*label '.cur.'\s*$', 'wn')
			let numNewLabels += 1
			put='*label '.cur
			put=''
			call setline(line('.'), '"'.curOption."\" doesn't exist yet. Going to the next one...")
			put=''
		else
			let skippedLabels .= cur.' '
			let lastSkipped = 1
		endif
	endfor

	"Move to first label's text (use ctrl-v ctrl-m to input the <CR> at
	"end)
	if numNewLabels != 0
		call cursor(choiceEndLine, 1)
		normal /^.*doesn't exist yet. Going to the next one\.\.\.$
	endif
	
	"Print status message
	if len(skippedLabels) > 0
		echo 'Skipped: '.skippedLabels
	else
		echo 'New labels created: '.numNewLabels
	endif
endfunction

function! ChoiceScriptFindParent()
	" Put cursor on a label (could be in a *label or *goto, etc). Then call
	" this function, and it'll goto the block that called it. (Assumes a block
	" begins with a *label.) Only goes to first one it finds if there are more
	" than one parent. Hit n/N to go to the next *goto <label in question>.
	let wordUnderCursor = expand("<cword>")

"	Goto where came from and put it at bottom of screen
	normal ?\*goto \s*$zb
	let @/='\*goto '.wordUnderCursor.'\s*$'

	call search('^$\|^\S', 'W')   "Goto end of choice block (to reposition page on screen)
	redraw
	call search('\*label', 'bW')  "Goto top of choice block
	normal w
endfunction

function! ChoiceScriptFindChild()
	" Put cursor on a label in a *goto. Then call this function, and it'll
	" goto the corresponding *label.
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

