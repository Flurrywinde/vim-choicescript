"---------------------"
" "-----------------" "
" " choicefuncs.vim " "
" "-----------------" "
"---------------------"

"=====[ MAPPINGS SECTION ]====="

" CF = convert *fake_choice
nnoremap <space>cf :call ConvertFakeChoice()<cr>

" GS = Go Story. Search for and jump to next "story-ish"
nnoremap <space>gs :call NextStoryish()<cr>

" Text Image
nnoremap <space>ti :call MakeTextImage()<cr>

" Highlight something and do this to replace torg abbrevs (couldn't use
" <space>va cuz easy-motion uses <space>v . ta=torg abbreviation.
" <space>ta is also easy-motion, but I never use.)
vnoremap <space>ta :'<,'>!vimabbr ~/.vim/abbrevs/abbrevs-torg.txt<cr>
nmap <space>ta V<space>ta

" MediaGet: Put on line with pic/vid keywords to get and see
nnoremap <space>mg :call MediaGet()<cr>
nnoremap <space>si :call AutoMediaGet()<CR>

" Automatic Mediaget (Strange. This caused indent issues, but only much later,
" unless I really didn't make any new *choice's in all that time???)
" Possible issue: seems to trigger leaving insert mode and going back autocmd's. Will this help: inoremap <expr> <cr> MyFunc() (start with "\r" to preserve newline)? Hmm, did: inoremap <expr> <cr> AutoMediaGet() , but it output a 0 and sometimes gave error saying not allowed to input text here. Giving up on this idea for now.
" I think best idea is a manual normal mode command, yeah? Switching to that. (si = show images)
" Format is: *comment sex: ... (seems all formats work, e.g. mf mi; mf, mi; mf missionary; mf, missionary)
" autocmd BufWrite */choicescript/web/scenes/*.txt call AutoMediaGet()  " Didn't get called. Fix if wish to use, but not as good since requires manual :w. Hopefully <c-o>S fix will work.
"imap <cr> <cr><C-O>:call AutoMediaGet()<CR>

" Make stat
nnoremap <space>ms :call MakeStat()<cr>

" Make Achievement
" nnoremap <space>ma yygg/ACH<cr>2jpk^/achieve/e<cr>ament<esc>$a hidden 1 Title<cr>hidden<cr>Text<cr><esc>3k^2w
nnoremap <space>ma :call MakeAchievement()<cr>

" n and m dashes, ellipses
inoremap <buffer> -" –"
inoremap <buffer> -- —
" inoremap <buffer> ... …  " No, do not commandier the period

" CsVim Line Searcher: use if Qutebrowser csvim (ctrl-i) finds the wrong thing. Will search for the next match. (<space>sn = Search Next)
nnoremap <space>sn :call Csvimsrch()<cr>
"
" copy pic/vid/audio under cursor to csmedia/ folder and put new name into
" buffer. Use <space>gZ version if gZ version returned > 1 result.
nnoremap gZ :call CSmedia()<cr>
nnoremap <space>gZ :call CSmedia('f')<cr>

"Replace abbrevs (just ones hardcoded in the function, not the ;; file.)
nnoremap <space>ra :call ReplaceAbbrevs()<cr>

"Make empty scenes for each option in preceeding *choice block.
inoremap <C-P> <ESC><ESC>:call MakeChoices()<CR>:noh<CR>
noremap <silent> <Space>mc :call MakeChoices()<CR>:noh<CR>

" How to jump between parents and children:
"
" Find Parent: gets the *label of current line or above and goes to first
" *goto or *gosub it finds. Use n or N for others. Use <space>fl (find label)
" to go to the top of the block.
"
" Find Child: Cursor must be on the label in a *goto or *gosub. Will find the
" corresponding label. See function for planned expansion of this
" functionality.

" Find parent
nnoremap <Space>fp :set nohlsearch\|:call ChoiceScriptFindParent()<CR>

"Find child
" noremap <Space>fc :call ChoiceScriptFindChild()\|:set ft=choicescript\|:call ReloadAbbrevs()<CR>  " Didn't work because fzf asynchronous
noremap <Space>fc :call ChoiceScriptFindChild()<CR>

"Find label
nnoremap <Space>fl :call ChoiceScriptFindLabel()<CR>

" Check if new *goto label already exists
"inoremap <C-Y> <C-O>:call ChoiceScriptCheckLabel()<CR>  <-- conflicts with
"i_ctrl-y
nnoremap <space>cl :call ChoiceScriptCheckLabel()<CR>

"Search for next unfinished area
nnoremap <Space>uf /\(\*label \S\+\n\[b]Unfinished!\)\\|\(\[[^ibT/]\)<CR>

"Search backwards for "*goto <word under cursor>", then go to previous label. (This is
"good for jumping to the context a *label's called from. 03/25/20-Same as
"ChoiceScriptFindParent()?)
"noremap <C-U> ?\*goto zb?\*labelw   " Conflicts with ctrl-u (up half page)
"noremap <space>undecidedputsomethinghere ?\*goto zb?\*labelw	

"Search backwards for "*label <word under cursor>" 03/25/20-Seems same as
"ChoiceScriptFindChild()
"noremap <C-Y> ?\*label 	

"Print empty label
"inoremap <C-L> *label [This option is yet to be written.]
"inoremap <C-L> [This option is yet to be written.]

"Jump to name of previous empty label (not needed anymore due to super duper
"function)
"noremap <C-P> ?\*label \n$a

"Jump to achievement section, situations section, and back. (All but jump to
"situations section defunct. Or, well, I guess jump back might still be nice
"to use.)
noremap <leader>ja <esc><esc>:vnew <C-R>=expand("%:p:h")."/startup.txt"<CR><CR>/\*comment \*\*      STATS      \*\*<cr>:noh<cr>kko<BS>*achievement name visible 5 AchievementTitlePre-achievement text.Post-achievement text.<esc>kkkw
noremap <leader>js <esc><esc>:new <C-R>=expand("%:p:h")."/startup.txt"<CR><CR>/\*comment \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*<cr>:noh<cr>k
noremap <leader>jb <esc><esc>:hide<cr>:set columns=80<cr>

" Bold and italics: Stands for formatting-bold, formatting-italics, etc.
nnoremap <expr> <Space>fb col('.') == 1 ? 'i[b][/b]<esc>F[i' : 'a[b][/b]<esc>F[i' 
nnoremap <expr> <Space>fi col('.') == 1 ? 'i[i][/i]<esc>F[i' : 'a[i][/i]<esc>F[i' 
nnoremap <expr> <Space>fr col('.') == 1 ? 'i[style=b red][/style]<esc>F[i' : 'a[style=b red][/style]<esc>F[i' 
nnoremap <expr> <Space>fu col('.') == 1 ? 'i[style=b blue][/style]<esc>F[i' : 'a[style=b blue][/style]<esc>F[i' 

"=====[ FUNCTIONS ]====="

"Construct *label blocks from *choice block just above cursor
function! MakeChoices()

"BUG: Doesn't work if *choice is nested, like inside an *if. Will operate on
"first non-indented *choice it finds in reverse search instead.

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
	"let firstlabel = ''   " No longer used
	let skippedLabels = ''
	let numNewLabels = 0
	let labelCount = 0
	for cur in labelArray
		let lastSkipped = 0
		let curOption = optionArray[labelCount]
		let labelCount += 1
		if !search('*label '.cur.'\s*$', 'wn')
			"if (labelCount == 1)   " No longer used
			"	let firstlabel = cur
			"endif
			let numNewLabels += 1
			put='*label '.cur
			put='[This option is yet to be written.]'   " This will just be replaced by the below now.
			call setline(line('.'), '[b]Unfinished![/b] "'.curOption."\" doesn't exist yet. Going to the next one...")   " Why append() didn't work, I don't know. (It put it after the *return.)
			if (labelCount == len(labelArray))
				" Say will return to *choice instead
				normal :s/Going to the next one/Returning to previous *choice/
				"Put a goto firstlabel at end
				"put='*comment Remove the following *goto when last option is filled in.'
				"put='*goto '.firstlabel
				"New way! Go to the *choice
				put='*return choice'
			else
				put=''
			endif
		else
			let skippedLabels .= cur.' '
			let lastSkipped = 1
		endif
	endfor
	" Put blank line after except at eof or if already there because skipped
	" the last one
	if line('.') != line('$') && !lastSkipped
		put=''
	endif

	"Move to first label's text (use ctrl-v ctrl-m to input the <CR> at
	"end)
	if numNewLabels != 0
		call cursor(choiceEndLine, 1)
		"normal /\[This option is yet to be written.\]
		"let @/='\[This option is yet to be written\.\]'
		" Three years later, someone answered my question to say replace above two lines with: feedkeys("/pattern\<CR>"), but it works as is. https://vi.stackexchange.com/questions/3655/how-can-i-make-a-search-in-vimscript-let-n-and-n-look-for-more
		" Now, why not? Try the feedkeys method
		" call feedkeys("/^.*doesn't exist yet. Going to the next one\.\.\.$\<cr>")
		" redrawstatus
		" Nope, couldn't get below status message to show
		normal /^.*doesn't exist yet. \(Going to the next one\|Returning to previous \*choice\)\.\.\.$
		" Hmm, but @/ doesn't make the n/N key work. Need to do `/<c-p>`.
		" Whoa, but then, removing that line made it work now. Crazy!
	endif
	
	"Print status message
	if len(skippedLabels) > 0
		echo 'Skipped: '.skippedLabels
	else
		" \n makes above search go away
		echo "New labels created: ".numNewLabels
		redrawstatus
	endif

	"If changed EasyMotion mode, change it back
	if changedEasyMotionMode
		" call ToggleEasyMotionMode()   Nah, I like it off.
	endif
endfunction

" For FindOrphanLabels() internal use
let s:allGotoGosubs = {}

" 03/25/20-Seems to work, but no mapping to it. I think this is because
" GetNextZorphan() is not yet done. It currently returns index of first...
" what? in the array of orphans (but requires a comma, so only if more than one). No... @z is a string. Should use a global array for the orphans. So anyway, this is probably why no mapping. It's just not finished yet. I added some echom output, but I don't think I will need this anymore anyway. It's for *goto's, etc that have no matching *label.
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
		echom string(orphans)
	else
		echom "No orphans"
	endif
endfunction

" Unfinished. See above comment for FindOrphanLabels()
function! GetNextZorphan()
	let ret = match(@z, '\S\+,')
	echom ret

	return ret
endfunction

" Not yet used. Will likely never need. Puts in wrong place anyway.
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

" Helper function for FindOrphanLabels()
function! GetAllGotos()
	%g/\*goto \S\+/call GetGoto(getline('.'))
	"echo s:allGotoGosubs
endfunction

" Helper function for FindOrphanLabels()
function! GetAllGosubs()
	%g/\*gosub \S\+/call GetGosub(getline('.'))
endfunction

" Helper function for FindOrphanLabels()
function! GetGosub(line)
	if(stridx(a:line, '*gosub') != -1)
		let s:allGotoGosubs[matchstr(strpart(a:line, stridx(a:line, '*gosub')+7), '\S\+')] = ''
	endif
endfunction

" Helper function for FindOrphanLabels()
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
	" Unlike ChoiceScriptFindParentOld(), does not need cursor on a label to begin with.

	" Go up to nearest *label (backwards, no wrap, current line included)
	call search('\*label', 'bWc')
	" Now find nearest *goto for this label (Use n and N if not the one you want)
	normal w?\(\*goto\|\*gosub\) \s*$zb?
endfunction

function! ChoiceScriptFindParentOld()
	" Put cursor on a label. Then call this function, and it'll goto the
	" scene that called it. Only goes to first one it finds if there are
	" more than one parent.
	
	" TODO: maybe: allow calling again to go to another parent?
	" For above todo: (put outside function)
	" let g:findParentLastLine = 0
	" let g:findParentLastSrch = ''
	let wordUnderCursor = expand("<cword>")
"	search('\*goto '.wordUnderCursor, 'bw')
"
"	Goto where came from and put it at bottom of screen
	normal ?\*goto \s*$zb
	"match WhiteOnRed "/     how put a var here? (Was trying to highlight it.)
	"let @/='\*goto '.wordUnderCursor.'\s*$'   " Not necessary anymore? Was to make n/N find next.

	call search('^$\|^\S', 'W')   "Goto end of choice block (to reposition page on screen)
	redraw
	search('\*label', 'bw')  "Goto top of choice block. (Why was `W` (nowrap) before?)
	normal w
endfunction

" Helper function for ChoiceScriptFindChild()
function! JumpToChild(child)
	call search('\*label\s*'.a:child)
endfunction

function! ChoiceScriptFindChild()
" Need to identify indent
" level and grab all *goto's and *gosubs one level down only, I think. (To
" work for nested (i.e. not *label-based) code too.) Currently does it
" simpleminded way.

	if getline('.') =~ '^\s*\*\(goto\|gosub\)'
		" Cursor must be on a label in a *goto (or *gosub)
		" normal ?\*label \s*$zt

		" New way: can also just be on the line by going to the second word on the line
		normal ^w?\*label \s*$zt
	else
		" let indenter = GetIndenter()  " For now, just get *gotos or *gosubs
		" indented twice by tabs

		" Go to *label above
		call search('\*label', 'bW')

		" Go to *choice below
		call search('\*choice', 'W')

		" Get line num of when cursor not indented anymore
		let endOfChoice = search('^\S', 'nW')
		echo endOfChoice

		" Make array of all goto or gosub labels in choice (Note: \| only
		" works in '', not "")
		let children = []
		while search('\*goto\|\*gosub', 'W', endOfChoice) > 0
			let cur = matchlist(getline('.'), '\(\*goto\|\*gosub\)\s*\(\S*\)')[2]
			call add(children, cur)
		endwhile

		let useFzf = 1
		if useFzf
			let g:fzfdone = 0
			call fzf#run({
				\ 'source': children,
				\ 'sink': function('JumpToChild'),
				\ 'down': '40%'
			\ })
				" \ 'options': '--sync',  " Doesn't actually make it non-async. Does something else. See `man fzf`
				" \ 'window': '30new'  " Resets filetype. Not good if in vimwiki and did <space>cs
				" \ 'window': {'width': 0.9, 'height': 0.6}  " Maybe not in my
				" version? Says vim8 but...
		else
			" Currently just an example of how to make a menu.
			:echohl Title
			:echo 'Code fragments:'
			:echohl None
			:echo '1. foo'
			:echo '2. bar'
			:let choice = nr2char(getchar())
			" :if choice == 1 ...
		endif
	endif
endfunction

" After finding parent, you might want to go to top of that section
function! ChoiceScriptFindLabel()
	call search('\*label', 'bW')
	normal zt
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

function! ReplaceAbbrevs()
    " Save cursor position
    let l:save = winsaveview()
    " Execute subs
    %s/\(\W\|^\)tam\(\W\)/\1Tamara\2/ce
    %s/\(\W\|^\)jul\(\W\)/\1Juliette\2/ce
    %s/\(\W\|^\)val\(\W\)/\1Valinora\2/ce
    %s/\(\W\|^\)reb\(\W\)/\1Rebekah\2/ce
    %s/\(\W\|^\)jenc\(\W\)/\1Jennifer\2/ce
	%s/^\*co /*comment /ce
	%s/^\*pa$/*page_break/ce
    " Move cursor to original position
    call winrestview(l:save)
endfunction

function! CSmedia(...)
	" Get leading whitespace
	let indent = matchstr(getline('.'), '^\s*')

	" Get initial cursor position
	let curPos = getcurpos()
	
	" Assumes in a scene file for p:h:h:t to return storycode (gZ in non-cs
	" file, and csmedia/ might get polluted. Fix. Added vimwiki support, but
	" still fix pollution possibility.)
	let vimwiki = shellescape(fnameescape(expand('%:p:h:t')))
	if vimwiki ==# "'vimwiki'"
		let storycode = vimwiki
	else
		let storycode = shellescape(fnameescape(expand('%:p:h:h:t')))
	endif
	" I think do not need the :p on below <cfile>:p , but leave it for now.
	" Adds the cwd in front if nothing there. Had to modify csmedia to
	" accommodate. All seems to be working, so if ain't broke, don't fix! (But
	" could break if this happens to somehow find a filename it shouldn't, but
	" even in rare case that happens AND is a media file, hopefully I'll
	" notice something's wrong.)
	" Use csmediaf if got an argument, else use csmedia (a:0 is num opt args)
	if a:0 == 0
		let newname = system("csmedia " . storycode . ' ' . shellescape(expand("<cfile>:p")))
	else
		let newname = system("csmediaf " . storycode . ' ' . shellescape(expand("<cfile>:p")))
	endif
	put=indent.newname
	call setpos('.', curPos)
endfunction

if !exists('*MakeStat')
function! MakeStat()
	let setLineNum = search('^\s*\*set\s*.', 'bWn')   " First *set found above
	if (setLineNum == 0)
		echo "No *set found"
		return -1
	endif
	let setLine = getline(setLineNum)
	let statName = matchlist(setLine, '\*set \(\S*\)')[1]   " Should always exist, so [1] ok
	let statValue = matchlist(setLine, '\*set \S*\s\+\(\S*\)')[1]
	if statValue == 'true'
		let newStatValue = 'false'
	elseif statValue == 'false'
		let newStatValue = 'true'
	else
		let newStatValue = ''
	endif
	" Open startup.txt in horizontal split above
	execute "leftabove new " . expand("%:p:h")."/startup.txt"
	" If *create already exists, just go to it
	if (search('\*create \s*'.statName.'\s', 'w') > 0)
		return
	endif
	" Goto end of situationals section
	call search('\*comment \*\*  SITUATIONALS   \*\*')
	call search('^$')
	call search('^$')
	call cursor(line('.')-1, 1)   " Should error check -1
	redraw
	" Make a new *create
	if newStatValue != ''
		put='*create '.statName.' '.newStatValue
	else
		put='*create '.statName
	endif

	call search('\*create \s*'.statName, 'be')
endfunction
endif

if !exists('*MakeAchievement')
function! MakeAchievement()
	" TODO: increment ending number should increment *achieve too, not just
	" *achievement
	let wordUnderCursor = expand("<cword>")   " not used
	let achieveLineNum = search('^\s*\*achieve\s\+.', 'bWn')   " First one found above
	if (achieveLineNum == 0)
		echo "No achievement found"
		return -1
	endif
	let achieveLine = getline(achieveLineNum)
	let achievement = matchlist(achieveLine, '\*achieve \(\S*\)')[1]   " Should always exist, so [1] ok
	" Open startup.txt in horizontal split above
	execute "leftabove new " . expand("%:p:h")."/startup.txt"
	" If *achievement already exists, just go to it
	if (search('\*achievement \s*'.achievement.'\s', 'w') > 0)
		return
	endif
	" Otherwise, make a new *achievement
	let firstEnd = 0
	if (achievement[0:2] != 'end')
		" Goto first ending achievement
		call cursor(1, 1)
		let firstEnd = search('\*achievement \s*end')
		if (firstEnd != 0)
			call cursor(firstEnd-1, 1)   " Should error check -1
			let newAchLine = firstEnd
		endif
	elseif (len(achievement) == 3)
		" achievement is just 'end', so assume should increment (just add 1 to
		" last end(ing)
		call cursor(line('$'), 1)
		let lastEnd = search('\*achievement \s*end\(ing\)\?\d\+\D*', 'b')
		if lastEnd == 0
			" It's the first ending
			let achievement = 'end1'
		else
			" Increment ending number
			let lastEndLine = getline(lastEnd)
			let endSuffix = matchlist(lastEndLine, '\*achievement \s*end\(ing\)\?\(\d*\)')[2]   " Should always exist, so [2] ok
			let achievement = achievement.(endSuffix+1)
		endif
	endif
	" Goto end of achievement section if didn't already go to first ending
	" achievement (i.e. it's not an ending achievement or there are no ending
	" achievements yet)
	if (firstEnd == 0)
		let statsLine = search('\*comment \*\*      STATS      \*\*', 'wn')
		call cursor(statsLine-2, 1)   " Should error check -2
		let newAchLine = statsLine-1
	endif
	redraw
	" put='*achievement '.achievement.' visible 5 AchievementTitle'
	" put='	Pre-achievement text.'
	" put='	Post-achievement text.'
	call inputsave()
	let visConfirm = confirm('What is the visibility of achievement '.achievement.'?', "&visible\n&hidden")
	let visibility = 'hidden'
	if visConfirm == 1
		let visibility = 'visible'
	endif
	let achValue = input('Achievement point value: ')
	let AchievementTitle = input('Achievement title: ')
	if visibility == 'hidden'
		let pretext =  'hidden'
	else
		let pretext = input('Pre-achievement text: ')
	endif
	let posttext = input('Post-achievement text: ')
	call inputrestore()
	put='*achievement '.achievement.' '.visibility.' '.achValue.' '.AchievementTitle
	put='	'.pretext
	put='	'.posttext
	put=''
	" cursor(newAchLine, 1)
	call search('\*achievement \s*'.achievement.'\s*.', 'be')
endfunction
endif

" CsVim Line Searcher (<space>sn = Search Next, Optional argument: line (in lines to search for (not the file)) on which to begin search) (Used by the csvim qutebrowser userscript but can also be called manually)
" TODO: Add range as argument
" TODO: Search all scenes
nnoremap <space>sn :call Csvimsrch()<cr>
fun! Csvimsrch(...)
	" Reset pointer if got an argument, else use current pointer (a:0 is num opt args)
	if a:0 == 0
		if exists("b:csvimptr")
			let b:csvimptr += 1
			let line = b:csvimptr
		else
			let b:csvimptr = 1
			let line = 1
		endif
	else
		" Func get(list, idx, default), so in argument list, get first one, or if not available, default to 1
		let line = get(a:, 1, 1)
		let b:csvimptr = line
	endif
	" a = index of current line in l:lines (lines to search for)
	let a = 1
	" Load in lines to search for
	let l:lines = readfile('/tmp/csvim.dat')
	" Reset pointer if past end
	if b:csvimptr > len(l:lines)
		let b:csvimptr = 1
	endif
	" Is l:line and line the same? If so, seems like line is unused, then gets
	" co-opted for another use. If not the same, still unused. Ok, if no
	" namespace, e.g. l: or g:, means l: in func (g: outside funcs), so lines
	" is same as l:line, so unused and then co-opted. Delete pre-co-opt line
	" var.
	for l:line in l:lines
		if a == b:csvimptr
			" \v = very magic (parens, pipe don't need escape \, but curlies
			" do, c = accept a match at cursor position)
			let foundsomething = search('\v' . l:line, 'c')
			if foundsomething
				" redraw!
				return
			else
				let b:csvimptr += 1
			endif
		else
			let a += 1
		endif
		" echo s:line
	endfor
	" Didn't find anything, so reset pointer
	let b:csvimptr = 0
endfunction

" CsVim2 (for use by the csvim2 qutebrowser userscript)
fun! Csvim2(storycode)
	call search('('.a:storycode.'/index.html)')
	call search('^[')
	call cursor(line('.')-2, 1)
endfunction

"=====[ MediaGet: Cursor on line with keywords, shows in sxiv and mpv, and puts the filenames into buffer ]====="
function! MediaGet()
	" Get initial cursor position
	let curPos = getcurpos()
	" Get line
	let curline = getline('.')
	if curline[-1:] ==# ':'
		let curline = curline[:-2]
	endif
	
	let results = system('echo "'.curline.'" | vimdbget')
	put=results
	call setpos('.', curPos)
endfunction

function! AutoMediaGet_insertmappingversion()
	let curpos = getcurpos()
	let curlinenum = curpos[1]
	let curline = getline(curlinenum - 1)
	if curline[0:13] ==# '*comment sex: '  " No ws before it?
		call setpos('.', [0, curlinenum - 1, curpos[2]])
		let results = system('echo "'.curline[14:].'" | vimdbget2')
		call setpos('.', curpos)
		put=results
		put='asf:'.curline[14:]
	else
		" After cr (done by mapping), proper indent, don't erase line
		let curline = getline('.')
		if strlen(curline) == 0
			call feedkeys('S')
		endif
	endif
endfunction

function! AutoMediaGet()
	let curpos = getcurpos()
	let curlinenum = curpos[1]
	"let curline = getline(curlinenum - 1)  " For when was still an insert mode mapping
	let curline = getline(curlinenum)
	if curline[0:13] ==# '*comment sex: '  " No ws before it?
		call setpos('.', [0, curlinenum, curpos[2]])
		let results = system('echo "'.curline[14:].'" | vimdbget2')
		call setpos('.', curpos)
		" Put vimdbget2 output (error messages)
		if strlen(results) > 0
			put=results
		endif
	endif
endfunction

" Not used anywhere yet. (Was for MakeTextImage())
function! Trim(input_string)
	return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! MakeTextImage()
	let curline = getline('.')
	put= '*image http://herbaloutfitters.com/textimage/text_image.php?font=MervaleScript-Regular&fontsize=25&text='. substitute(curline, ' ', '%20', 'g') . '&color=000000&matte=F0D6AD&shadow=inv'
	normal kdd
endfunction

" No longer used. Using `storyish` bash script instead, but nice example of
" redir, silent search/replace match counter, very magic
" Used by StoryishScore(). Returns count of a:regex matches on current line.
function! CountMatches(regex)
	let curpos = getcurpos()
	let countstr = ''
	" echo "About to: ".a:regex."<—"
	redir! => countstr
	" silent! suppresses error messages too. See them with v:errmsg, e.g. if
	" v:errmsg != "" (but must clear it first, else will still have previous)
	silent! exe "s/".a:regex."//n"
	redir END
	call setpos('.', curpos)
	" \v = very magic, so ( and ) don't need \ prefix. ^ at beginning didn't
	" work for some reason
	" echo matchlist(countstr, '\v(\d*) match')  " just for debugging
	let matches = matchlist(countstr, '\v(\d*) match')
	if len(matches) > 0
		" echo "M: ".matches[1]
		return matches[1]
	else
		" echo "no matches found in ".countstr."<— hi"
		return 0
	endif
endfunction

" No longer used. Using `storyish` bash script instead
" Used by NextStoryish(). Calculates and returns the storyish score for the current line.
function! StoryishScore()
	let worth1='\v(\W|^)I\W|(\W|^)[hH]e\W|Tamara|Sherry'
	let worth3='\vyou\W|You\W|kz|Kz|KZ|tk|Tk|TK|Elsbeth|Janiyah|Juliette|Jennifer|Rebekah|Corrina'
	let worth9='\v^"[^"]*"$'
	let worth11='\v^"[^"]*[,?!]" .{1,22}(say|said)'
	" echo "Ret: ".CountMatches(worth1)
	let sc = 0
	let sc += 1 * CountMatches(worth1)
	let sc += 3 * CountMatches(worth3)
	let sc += 11 * CountMatches(worth7)
	let sc += 9 * CountMatches(worth6)
	" echo "Output: ".sc
	return sc
endfunction

" No longer used. Using `storyish` bash script instead (but nice example of
" index())
" Called by NextStoryish(). Returns 1 if line is a choicescript command (only
" a subset for now). Need this because apparently match() can't handle
" patterns with \| in them?!? Also, had to take out '^\s*' from beginning of
" pattern because vim said can't have a multi followed by a multi?!?
function! IsChoicescript(str)
	if index(['*page_break', '*choice', '*comment', '*fake_choice', '*label', '*goto'], a:str) != -1
		return 1
	else
		return 0
	endif
endfunction

" No longer used. Using `storyish` bash script instead
function! NextStoryish_defunct()
	let target = 33  " If score reaches this, storyishness detected
	let toolong = 11  " but not if it took more than these lines after first match
	let sc = 0
	let numdowns = 0
	let firstmatch = 0
	while line('.') != line('$')
		if strlen(getline('.')) > 0
			echo line('.').": ".getline('.')
			if IsChoicescript(getline('.')) == 1
				echo "Found a choicescript command after ".numdowns." lines"
				return
			endif
			let linescore = StoryishScore()
			if linescore > 0
				let sc += linescore
				echo "sc: ".sc
				if firstmatch == 0
					let firstmatch = line('.')
				endif
			endif
			if sc > target
				echo "Storyishness detected here after ".numdowns." lines"
				call cursor(firstmatch, 1)
				return
			elseif firstmatch != 0 && firstmatch + toolong < line('.')
				" Didn't find enough soon enough, so start count over
				let firstmatch=0
				let sc=0
				echo "RESET - Not enough storyishness seen for too long."
			" elseif firstmatch != 0
				" echo "Reset at: ".(line('.') - firstmatch)
			endif
		endif
		call cursor(line('.')+1, 1)
		let numdowns += 1
	endwhile
	echo "Reached end-of-file without any storyishness detected"
endfunction

" Call with <space>gs . Moves cursor to next area of storyishness.
function! NextStoryish()
	" exe 'term storyish "'.expand('%:p').'" '.line('.')
	" echo 'storyish "'.expand('%:p').'" '.line('.').' > /tmp/storyish.txt'
	call system('storyish "'.expand('%:p').'" '.line('.').' > /tmp/storyish.txt')
	let lastline = system('cat /tmp/storyish.txt | tail -n 1')
	" echo "ll: ".lastline
	call cursor(lastline, 1)
	term cat /tmp/storyish.txt
endfunction

" Call with <space>cf . Converts a *fake_choice to a *choice, inserted blank *goto's
function! ConvertFakeChoice()
	" ran out of steam
endfunction
