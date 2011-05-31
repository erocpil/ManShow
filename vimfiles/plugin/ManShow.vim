" vim: ts=4:ft=vim:foldmethod=expr:tw=75:foldcolumn=2
" Author: lipcore
" TimeStamp: 星期四 19 五月 2011 10:56:51 下午 中国标准时间
" Filename: ManShow.vim
" Description:
"

let g:statusline_max_path = 20
fun! StatusLineGetPath() "{{{
	let p = expand('%:.:h') "relative to current path, and head path only
	let p = substitute(p,'\','/','g')
	let p = substitute(p, '^\V' . $HOME, '~', '')
	if len(p) > g:statusline_max_path
		let p = simplify(p)
		let p = pathshorten(p)
	endif
	return p
endfunction "}}}

nmap <Plug>view:switch_status_path_length :let g:statusline_max_path = 200 - g:statusline_max_path<cr>
nmap ,t <Plug>view:switch_status_path_length

set laststatus=2

if has('gui_running')
	augroup Statusline
		au! Statusline
		au BufEnter * call <SID>SetFullStatusline() | set title titlestring=%<%(%{Tlist_Get_Tag_Prototype_By_Line()}\ \ \ %)%([%M]%)%f%{FileInfo()}\ %{getcwd()}\ %=%l/%L-%P titlelen=100
		au BufLeave,BufNew,BufRead,BufNewFile * call <SID>SetNonStatusline() | set title titlestring=""
	augroup END
else
	augroup Statusline
		au! Statusline
		au BufEnter * call <SID>SetSimpleStatusline() | set title titlestring=%<%(%{Tlist_Get_Tag_Prototype_By_Line()}\ \ \ %)%([%M]%)%f%{FileInfo()}\ %{getcwd()}\ %=%l/%L-%P titlelen=100
		au BufLeave,BufNew,BufRead,BufNewFile * call <SID>SetSimpleStatusline() | set title titlestring=""
	augroup END
endif

fun! StatusLineRealSyn()
	let synId = synID(line('.'),col('.'),1)
	let realSynId = synIDtrans(synId)
	if synId == realSynId
		return 'Normal'
	else
		return synIDattr( realSynId, 'name' )
	endif
endfunction

fun! s:SetFullStatusline() "{{{
	setlocal statusline=
	setlocal statusline+=%#StatuslineBufNr#%-1.2n								" buffer number
	" setlocal statusline+=%#StatuslineLastBufferNr#%{last_buffer_nr()}
	setlocal statusline+=%#StatuslineLastBufferNr#%{bufnr('$')}
	setlocal statusline+=%h%#StatuslineFlag#%m%r%w								" flags
	setlocal statusline+=%#StatuslinePath#%-0.20{StatusLineGetPath()}%0*		" path
	setlocal statusline+=%#StatuslineFileName#%t							" file name
	setlocal statusline+=%#StatuslineFileEnc#%{&fileencoding}					" file encoding
	setlocal statusline+=%#StatuslineFileFormat#%{&fileformat}					" file format
	setlocal statusline+=%#StatuslineFileBomb#%{&bomb?'b':'B'}
	setlocal statusline+=%#StatuslineFileType#%{strlen(&ft)?'.'.&ft:'**'}			" filetype
	" setlocal statusline+=%#StatuslineFileType#%{strlen(&ft)?&ft:'**'}			" filetype
	setlocal statusline+=%#StatuslineTermEnc#%{&termencoding}					" encoding
	setlocal statusline+=%#SpellLang#%{&spelllang}								" spell language
	" 可能卡，慎用！
	setlocal statusline+=%#StatuslineFoldInfo#%{FoldInfo()}						" fold
	setlocal statusline+=%#TextMode#%{TextMode()}%0*							"
	setlocal statusline+=%#StatuslineRealSyn#%{StatusLineRealSyn()}				" real syntax name
	setlocal statusline+=%#StatuslineSyn#%{synIDattr(synID(line('.'),col('.'),1),'name')}		"syntax name
	" setlocal statusline+=%#TlistGetTagname#%{Tlist_Get_Tagname_By_Line()}%0*	" Tlist_Get_Tagname_By_Line
	" setlocal statusline+=%#TlistGetTagname#%{Tlist_Get_Tag_Prototype_By_Line()}%0*	" Tlist_Get_Tag_Prototype_By_Line
	setlocal statusline+=%#GetTagname#%{GetTagName(line('.'))}%0*				" from ctags.vim

	" setlocal statusline+=%#UpTime#%{RetUpTime()}%0*							" uptime
	" setlocal statusline+=%#ShowUtf8Sequence#%{ShowUtf8Sequence()}				" utf-8 sequence
	setlocal statusline+=%=
	setlocal statusline+=%#MvpInfo#%{GetMvpInfo()}%0*				"
	"" take too much space, added to titlestring
	" setlocal statusline+=%#FileInfo#%{FileTime()}
	setlocal statusline+=%#StatuslineChar#%-2B%0*								" current char
	setlocal statusline+=%#StatuslinePosition#%c-%v\ \%l						" position
	setlocal statusline+=%#StatuslinePercent#\%L\ %P							" position percentage
	setlocal statusline+=%#StatuslineCapsBuddy#%{exists('*CapsLockSTATUSLINE')?CapsLockSTATUSLINE():''}	"Caps
	setlocal statusline+=%#StatuslineCapsBuddy#%{VimBuddy()}					"Buddy
	setlocal statusline+=\ %#StatuslineTime#%{strftime(\"%m-%d\ %H:%M\")}		" current time
endfunction "}}}

fun! s:SetSimpleStatusline() "{{{
	setlocal statusline=
	" setlocal statusline+=%#StatuslineNC#%-0.20{StatusLineGetPath()}%0* " path
	setlocal statusline+=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
	setlocal statusline+=		" \/%t\                       " file name
endfunction "}}}

fun! s:SetNonStatusline() "{{{
	setlocal statusline=
	setlocal statusline+=%F%m%r%h%w\
	setlocal statusline+=%=
endfunction
" }}}

" Function used to display utf-8 sequence.
fun! ShowUtf8Sequence()
	try
		let p = getpos('.')
		redir => utfseq
		sil normal! g8
		redir End
		call setpos('.', p)
		return substitute(matchstr(utfseq, '\x\+ .*\x'), '\<\x', '0x&', 'g')
	catch
		return '?'
	endtry
endfunction

"" to be fixed
if has("autocmd")
	au FileType qf
				\ if &buftype == "quickfix" |
				\ setlocal statusline=%2*%-3.3n%0* |
				\ setlocal statusline+=\ \[Compiler\ Messages\] |
				\ setlocal statusline+=%=%2*\ %<%P |
				\ endif
	fun! FixMiniBufExplorerTitle()
		if "-MiniBufExplorer-" == bufname("%")
			setlocal statusline=%2*%-3.3n%0*
			setlocal statusline+=\[Buffers\]
			setlocal statusline+=%=%2*\ %<%P
		endif
	endfun
	if v:version>=600
		au BufWinEnter *
					\ let oldwinnr=winnr() |
					\ windo call FixMiniBufExplorerTitle() |
					\ exec oldwinnr . " wincmd w"
	endif
endif

function TextMode()
	" let miscstr = (&spell ? 'spell ' : '')
	" let fencstr = (&fenc == '' ? &enc : &fenc) . (&bomb ? '.BOM' : '')
	let textmode = (&et ? 'e' : 'E') . &ts . &sw .
				\ (&cin ? 'c' : (&si ? 's' : (&ai ? 'a' : 'C'))) .
				\ (&wrap ? 'w' : 'W') . &tw
	return textmode
endfunction

"" code.vim
"" show the time when the file modified in the statusbar
" set statusline+=\ %{FileTime()}
fu! FileInfo()
	let ext=tolower(expand("%:e"))
	let fname=tolower(expand('%<'))
	let filename=fname . '.' . ext
	let msg=""
	" let msg=msg.%t.getcwd()
	" add file type
	let msg=msg." "."[".getftype(filename)."]"
	" rwx
	let msg=msg." ".getfperm(filename)
	" last modified time
	let msg=msg." ".strftime("(%c)",getftime(filename))
	return msg
endf
fu! CurTime()
	let ftime=""
	let ftime=ftime." ".strftime("%b %d %y %H:%M:%S")
	return ftime
endf

" "" FoldInfo
function! FoldInfo()
	let foldinfo=""
	if foldlevel(line('.'))>0
		" let foldinfo=foldinfo.(foldclosed(line('.'))>0?foldclosed(line('.'))." ":"").(foldlevel(line('.'))>0?foldlevel(line('.')):"").(foldclosedend(line('.'))>0?" ".foldclosedend(line('.')):"")
		let foldinfo=foldinfo.(foldclosed(line('.'))>0?foldclosed(line('.'))."-":"").foldlevel(line('.')).(foldclosedend(line('.'))>0?"-".foldclosedend(line('.')):"")
	endif
	return foldinfo
endfunction

" set laststatus=2
" "" 状态栏各个状态
" let statusHead ="%-.50f\ %h%m%r"
" let statusBreakPoint ="%<"
" let statusSeparator ="|"
" let statusFileType ="%{((&ft\ ==\ \"help\"\ \|\|\ &ft\ ==\ \"\")?\"\":\"[\".&ft.\"]\")}"
" let statusFileFormat ="[%{(&ff\ ==\ \"unix\")?\"u\":\"d\"}]"
" let statusAscii ="\{%b:0x%B\}"
" let statusCwd ="%-.50{getcwd()}"
" let statusBody =statusFileType.statusFileFormat.statusSeparator.statusAscii.statusSeparator."\ ".statusBreakPoint.statusCwd
" let statusEncoding ="[%{(&fenc\ ==\ \"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}]"
" let statusBlank ="%="
" let statusKeymap ="%k"
" let statusRuler ="%-12.(%lL,%c%VC%)\ %P"
" let statusTime ="%{strftime(\"%y-%m-%d\",getftime(expand(\"%\")))}"
" let statusEnd=statusKeymap."\ ".statusEncoding.statusRuler."\ ".statusTime
" "" 最终状态栏的模式字符串
" let statusString=statusHead.statusBody.statusBlank.statusEnd
" set statusline=%!statusString

" show function name within titlebar
" set title titlestring=%<%(%{Tlist_Get_Tag_Prototype_By_Line()}\ \ \ %)%([%M]%)%F\ %{FileInfo()}\ %=%l/%L-%P titlelen=100
" set title titlestring=%<%(%{Tlist_Get_Tag_Prototype_By_Line()}\ \ \ %)%([%M]%)%f%{FileInfo()}\ %{expand('%:p:h')}%{getcwd()}\ %=%l/%L-%P titlelen=100
" set title titlestring=%<%(%{Tlist_Get_Tag_Prototype_By_Line()}\ \ \ %)%([%M]%)%f%{FileInfo()}\ %{getcwd()}\ %=%l/%L-%P titlelen=100
" set title titlestring=%<%(\ %M%)\ %F\ %([%{Tlist_Get_Tag_Prototype_By_Line()}]%)\ %=%l/%L-%P titlelen=65
" set title titlestring=%t\ %F\ %(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
