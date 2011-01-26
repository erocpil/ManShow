" vim:tw=75:ts=4:ft=vim:foldmethod=expr
" /*
"  * Author: lipcore
"  * Last modified: 星期二 25 一月 2011 09:43:18 下午 中国标准时间
"  * Description: my personal vim configuration.
"  * Version:
"  */

"" default settings {{{
if has("win32")
	source $VIMRUNTIME/vimrc_example.vim
	source $VIMRUNTIME/mswin.vim
	behave mswin
else
endif
" }}}

"" diff {{{
set diffexpr=MyDiff()
function MyDiff()
	let opt = '-a --binary '
	if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
	if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
	let arg1 = v:fname_in
	if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
	let arg2 = v:fname_new
	if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
	let arg3 = v:fname_out
	if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
	let eq = ''
	if $VIMRUNTIME =~ ' '
		if &sh =~ '\<cmd'
			let cmd = '""' . $VIMRUNTIME . '\diff"'
			let eq = '"'
		else
			let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
		endif
	else
		let cmd = $VIMRUNTIME . '\diff'
	endif
	silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction
" }}}

"" encoding {{{
" Multi-encoding setting, MUST BE IN THE BEGINNING OF .vimrc!
if has("multi_byte")
	set nolinebreak
	" When 'fileencodings' starts with 'ucs-bom', don't do this manually
	"set bomb
	" set fileencodings=ucs-bom,chinese,taiwan,japan,korea,utf-8,latin1
	set fileencodings=ucs-bom,chinese,utf-8,gb18030,cp936,big5,euc-jp,euc-kr,latin-1
	" CJK environment detection and corresponding setting
	if v:lang =~ "^zh_CN"
		" Simplified Chinese, on Unix euc-cn, on MS-Windows cp936
		" 会乱码
		" set encoding=chinese
		set encoding=utf-8
		" set termencoding=chinese
		set termencoding=utf-8
		if &fileencoding == ''
			set fileencoding=chinese
		endif
	elseif v:lang =~ "^zh_TW"
		" Traditional Chinese, on Unix euc-tw, on MS-Windows cp950
		set encoding=taiwan
		set termencoding=taiwan
		if &fileencoding == ''
			set fileencoding=taiwan
		endif
	elseif v:lang =~ "^ja_JP"
		" Japanese, on Unix euc-jp, on MS-Windows cp932
		set encoding=japan
		set termencoding=japan
		if &fileencoding == ''
			set fileencoding=japan
		endif
	elseif v:lang =~ "^ko"
		" Korean on Unix euc-kr, on MS-Windows cp949
		set encoding=korea
		set termencoding=korea
		if &fileencoding == ''
			set fileencoding=korea
		endif
	endif
	" Detect UTF-8 locale, and override CJK setting if needed
	if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
		set encoding=utf-8
	endif
else
	echoerr 'Sorry, this version of (g)Vim was not compiled with "multi_byte"'
endif
" encodings END }}}

"" 在 shell 中指定要打开文件的编码 {{{
" vim file_name -c "e ++enc=cp936"
" }}}

"" 中文帮助 {{{
set helplang=cn
" }}}

"" 解决乱码 {{{
if has("win32")
	" 指定菜单语言
	" set langmenu=none
	" 解决菜单乱码
	set langmenu=zh_CN.utf-8
	language messages zh_CN.utf-8
	source $VIMRUNTIME/delmenu.vim
	source $VIMRUNTIME/menu.vim
	set ambiwidth=double
endif
" }}}

" 判断 Vim 是否包含多字节语言支持，并且版本号大于 7.3 {{{
if has('multi_byte') && v:version > 703
	" 如果 Vim 的语言（受环境变量 LANG 影响）是中文（zh）、日文（ja）
	" 或韩文（ko）的话，将模糊宽度的 Unicode 字符的宽度设为双宽度（double）
	if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
		set ambiwidth=double
	endif
endif
" }}}

"" Balloon {{{
"" The following two functions are the examples of <Hacking Vim>, Chapter 2
"" This example is based on one from the Vim help system, and shows how to make
"" a simple function that will show the info from all the available variables.
" function! SimpleBalloon()
"    return 'Cursor is at line/column: ' . v:beval_lnum .
"     \'/' . v:beval_col .
"     \ ' in file ' .  bufname(v:beval_bufnr) .
"     \ '. Word under cursor is: "' . v:beval_text . '"'
" endfunction
" set balloonexpr=SimpleBalloon()
" set ballooneval

"" a more advanced example, to activate it, just turn on the spell check:
"" :set spell
function! FoldSpellBalloon()
	let foldStart = foldclosed(v:beval_lnum )
	let foldEnd   = foldclosedend(v:beval_lnum)
	let lines = []
	" Detect if we are in a fold
	if foldStart < 0
		if &spell
			" Detect if we are on a misspelled word
			let lines = spellsuggest( spellbadword(v:beval_text)[ 0 ], 5, 0 )
			return join( lines, has( "balloon_multiline" ) ? "\n" : " " )
		else
			" return tags
			" tag_signature.vim:
			" return GetTagSignature()
			" echofunc.vim:
			return BalloonDeclaration()
		endif
	else
		" we are in a fold
		let numLines = foldEnd - foldStart + 1
		" if we have too many lines in fold, show only the first 14
		" and the last 14 lines
		if ( numLines > 31 )
			let lines = getline( foldStart, foldStart + 14 )
			let lines += [ '-- Snipped ' . ( numLines - 30 ) . ' lines --' ]
			let lines += getline( foldEnd - 14, foldEnd )
		else
			" less than 30 lines, lets show all of them
			let lines = getline( foldStart, foldEnd )
		endif
		" return result
		if has('win32')
			if &encoding == "utf-8"
				let utf8 = join( lines, has( "balloon_multiline" ) ? "\n" : " " )
				return iconv(utf8, "utf-8", "cp936")
			else
				return join( lines, has( "balloon_multiline" ) ? "\n" : " " )
			endif
		else
			return join( lines, has( "balloon_multiline" ) ? "\n" : " " )
		endif
	endif
endfunction
set balloonexpr=FoldSpellBalloon()
set ballooneval
set balloondelay=100
" Balloon ends }}}

" turn off nice effect on status bar title {{{
let performance_mode=0
let use_plugins_i_donot_use=0
set nocompatible
" }}}

"" GUI 相关 {{{
if has("gui_running")
	if has("win32")
		" au GUIEnter * simalt ~x
		"" fonts
		" 等宽英文字体
		" set guifont=DejaVu_Sans_Mono:h10.875:cANSI
		set guifont=Monaco:h10.75:cANSI
		" set guifont=Monaco:h21.5:cANSI
		" 设置中文字体，微软雅黑需要重新编译 Vim 。
		set gfw=Microsoft_YaHei:h11
		" set gfw=Microsoft_YaHei:h22
		" set guifontwide=YouYuan:h11:cGB2312
		" set gfw=FZJingLeiS\-R\-GB:h13
		" set gfw=文泉驿正黑:h12:cGB2312
		" set gfw=PMingLiU:h12:cGB2312
		" 针对不同的文件使用不同字体
		" autocmd BufEnter *.txt set gfw=Microsoft_YaHei:h11
		autocmd BufEnter *.txt set guifontwide=YouYuan:h11:cGB2312 | setlocal ft=txt
		autocmd BufEnter * :syntax sync fromstart
		" 全屏
		map <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
		" ALpha Window
		map <leader>aw :call libcallnr("vimtweak.dll", "SetAlpha", 168)<cr>
		map <leader>aW :call libcallnr("vimtweak.dll", "SetAlpha", 255)<cr>
		" Maximized Window
		map <leader>mw :call libcallnr("vimtweak.dll", "EnableMaximize", 1)<cr>
		map <leader>mW :call libcallnr("vimtweak.dll", "EnableMaximize", 0)<cr>
		" TopMost Window
		map <leader>et :call libcallnr("vimtweak.dll", "EnableTopMost", 1)<cr>
		map <leader>eT :call libcallnr("vimtweak.dll", "EnableTopMost", 0)<cr>
	else
		set guifont=Menlo\ 11
		set gfw=Microsoft\ YaHei\ 11
	endif
	"" autoscroll
	" map <F9> <C-E>:sleep 3500m<CR>j<F9>
	"" CursorColumn
	" If you only want the highlighting in the current window you can use
	" these autocommands: >
	" au WinLeave * set nocursorline nocursorcolumn
	" au WinEnter * set cursorline cursorcolumn
	map <leader>cc :set cursorcolumn <cr>
	map <leader>cC :set nocursorcolumn <cr>
	"" noh
	map <leader>nh :noh <cr>
	map <leader>co :colorscheme default<cr>
	" let psc_style='cool'
	"" 把DOS文件格式转成UNIX格式
	" :set ff=unix"
	"" 删除文档中的空行
	" :g/^\s*$/d"
	"" 启动时最大化
	" au GUIEnter * simalt ~x
	" 移动窗口
	map <leader>ce :winpos 88 132 <cr>
	map <leader>le :winpos 1800 120 <cr>
	map <leader>ri :winpos -1800 120 <cr>
	map <leader>tt :winpos 0 0 <cr>
	" set lines
	map <leader>sl :set lines=40 <cr>
	map <leader>sL :set lines=25 <cr>
	" 隐藏工具栏
	set guioptions-=T
	" 隐藏菜单栏
	set guioptions-=m
	" 隐藏左边滚动条
	set guioptions-=l
	set guioptions-=L
	" 隐藏右边滚动条
	set guioptions-=r
	set guioptions-=R
	"" map
	" 菜单栏
	map <leader>gm :set guioptions+=m<cr>
	map <leader>gM :set guioptions-=m<cr>
	" 工具栏
	map <leader>gT :set guioptions+=T<cr>
	map <leader>gt :set guioptions-=T<cr>
	" 滚动条
	map <leader>gl :set guioptions+=l<cr>
	map <leader>gL :set guioptions-=l<cr>
	map <leader>gr :set guioptions+=r<cr>
	map <leader>gR :set guioptions-=r<cr>
	" 画图、表
	map <leader>sk :call ToggleSketch()<CR>
	colorscheme Celibate
	" colorscheme candyman
	" colorscheme softbluev2
else
	set background=dark
	colorscheme vilight
endif
" }}}

"" map {{{
map <leader>q :q<cr>
" tab
map <leader>tc :tabc<cr>
map <leader>ted :tabedit<cr>
map <leader>tf :tabfirst<cr>
map <leader>tl :tabl<cr>
map <leader>tm :tabm<cr>
map <leader>tw :tabnew<cr>
map <leader>tn :tabnext<cr>
map <leader>tN :tabNext<cr>
map <leader>tp :tabp<cr>
map <leader>bd :bd<cr>
map <leader>vn :vnew<cr>
map <leader>hs :split<cr>
map <leader>vs :vsplit<cr>
"" buffer
map <leader>bn :bn<cr>
map <leader>bp :bp<cr>
"" Fast saving
nmap <leader>w :w!<cr>
" }}}

"" Fast editing of the .vimrc {{{
if has("win32")
	map <leader>ev :e! $VIM/_vimrc<cr>
	"" When vimrc is edited, reload it
	autocmd! bufwritepost vimrc source $VIM/_vimrc
else
	map <leader>ev :e! $HOME/.vimrc<cr>
	" 这行可以用
	" autocmd! bufwritepost $VIM/_vimrc source %
	autocmd! bufwritepost vimrc source ~/.vimrc
endif
" }}}

"" How many tenths of a second to blink {{{
set mat=2
" }}}

"" Default file types {{{
set ffs=unix,dos,mac
" }}}

"" set number {{{
map <leader>nu :set number<cr>
map <leader>nn :set nonumber<cr>
map <leader>rn :set rnu<cr>
map <leader>rN :set nornu<cr>
" }}}

"" 开启命令显示 {{{
set showcmd
" }}}

" 针对文本模式的设定 {{{
if !has('gui_running')
	" 将变量 Tlist_Inc_Winwidth 的值设为 0，防止 taglist 插件改变终端窗口的大小
	" （有些情况下会引起系统不稳定）。使用“has('eval')”
	" 是让该语句仅在功能较为完整、至少支持表达式的 Vim 版本中运行。
	if has('eval')
		let Tlist_Inc_Winwidth=0
	endif
endif
" }}}

"" common {{{
filetype plugin indent on
"" history文件中需要记录的行数
set history=500
"" 在处理未保存或只读文件的时候，弹出确认
set confirm
"" 与windows共享剪贴板
set clipboard+=unnamed
"" 侦测文件类型
filetype on
"" 载入文件类型插件
filetype plugin on
"" 为特定文件类型载入相关缩进文件
filetype indent on
" Set to auto read when a file is changed from the outside
" set autoread
"" 设置C/C++语言的具体缩进方式（windows风格）
set cinoptions={0,1s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s

"" viminfo {{{
" set viminfo+=!
set viminfo='1000,f1,<500,n$VIM\\_viminfo
" }}}

"" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-
"" 语法高亮
syntax on
"" 高亮字符，让其不受100列限制
" highlight OverLength ctermbg=red ctermfg=white guibg=red guifg=white
" match OverLength '\%101v.*'
" Do not redraw, when running macros.. lazyredraw
set lz
set magic
"" 设定文件浏览器目录为当前目录
set bsdir=buffer
set autochdir
"" 不要备份文件
set nobackup
"" 不要生成swap文件，当buffer被丢弃的时候隐藏它
setlocal noswapfile
set bufhidden=hide
"" 字符间插入的像素行数目
set linespace=0
"" 增强模式中的命令行自动完成操作
set wildmenu
set wildmode=list:longest,full
"" 在状态行上显示光标所在位置的行号和列号
set ruler
set rulerformat=%20(%2*%<%f%=\ %m%r\ %3l\ %c\ %p%%%)
" 命令行（在状态行下）的高度，默认为1
" set cmdheight=2
" 使回格键（backspace）正常处理indent, eol, start等
set backspace=2
" 允许backspace和光标键跨越行边界
set whichwrap+=<,>,h,l
" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
if has('mouse')
	set mouse=a
	set selection=exclusive
	set selectmode=mouse,key
endif
" 启动的时候不显示那个援助索马里儿童的提示
set shortmess=atI
" 通过使用: commands命令，告诉我们文件的哪一行被改变过
set report=0
" 不让vim发出讨厌的滴滴声
" set noerrorbells
" 在被分割的窗口间显示空白，便于阅读
set fillchars=vert:\ ,stl:\ ,stlnc:\
" Enable syntax hl
syntax enable
" 高亮显示匹配的括号
set showmatch
" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=5
" 在搜索的时候忽略大小写
set ignorecase smartcase
" 不要高亮被搜索的句子（phrases）
" set nohlsearch
" 高亮搜索关键字
set hlsearch
" 在搜索时，输入的词句的逐字符高亮（类似firefox的搜索）
set incsearch
" :set list 显示内容
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<,eol:$
" 光标移动到buffer的顶部和底部时保持3行距离
set scrolloff=3
" 不要闪烁
" set novisualbell
" 总是显示状态行
set laststatus=2
" 自动格式化
" set formatoptions=tcrqn
" 正确处理中文字符的折行和拼接
set formatoptions+=mM
" set formatoptions+=tcroqn2mBM1
" 继承前一行的缩进方式，特别适用于多行注释
set autoindent
" 为C程序提供自动缩进
set smartindent
" 使用C样式的缩进
set cindent
" 制表符为4
set tabstop=4
" 统一缩进为4
set softtabstop=4
set shiftwidth=4
" 不要用空格代替制表符
set noexpandtab
" 不要换行
" set nowrap
" 在行和段开始处使用制表符
set smarttab
"" 断行设置
" 不要在单词中间断行
set lbr
"" CTags
if has('win32')
	set tags+=D:/dev/gtk/tags
	set path+=D:/dev/gtk/include/,D:/dev/gtk/include/*
	set tags+=D:/Qt/qt/include/tags
	set tags+=D:/Qt/qt/src/tags
	set path+=D:/Qt/qt/include,D:/Qt/qt/include/*,D:/Qt/qt/src/,D:/Qt/qt/src/*,D:/Qt/qt/,D:/Qt/qt/*
else
	set tags+=/opt/qtsdk/qt/include/tags
	set tags+=/opt/qtsdk/qt/src/tags
	set path+=/opt/qtsdk/qt/include,/opt/qtsdk/qt/include/*,/opt/qtsdk/qt/src/,/opt/qtsdk/qt/src/*,/opt/qtsdk/qt/,/opt/qtsdk/qt/*
endif
" }}}

"" taglists {{{
" <CR>          跳到光标下tag所定义的位置，用鼠标双击此tag功能也一样
" o             在一个新打开的窗口中显示光标下tag
" <Space>       显示光标下tag的原型定义
" u             更新taglist窗口中的tag
" s             更改排序方式，在按名字排序和按出现顺序排序间切换
" x             taglist窗口放大和缩小，方便查看较长的tag
" +             打开一个折叠，同zo
" -             将tag折叠起来，同zc
" *             打开所有的折叠，同zR
" =             将所有tag折叠起来，同zM
" [[            跳到前一个文件
" ]]            跳到后一个文件
" q             关闭taglist窗口
" <F1>          显示帮助
" nnoremap <silent> <F7> :TlistToggle<CR>
map <C-F7> :TlistToggle<cr>
" 按照名称排序
let Tlist_Sort_Type = "name"
" 在右侧显示窗口
let Tlist_Use_Right_Window = 1
" 压缩方式
let Tlist_Compart_Format = 1
" 不要关闭其他文件的tags
let Tlist_File_Fold_Auto_Close = 0
" 不要显示折叠树
let Tlist_Enable_Fold_Column = 1
" 不同时显示多个文件的tag，只显示当前文件的，多个 tab 时会出错。
" let Tlist_Show_One_File = 1
let Tlist_Show_One_File = 0
" 如果taglist窗口是最后一个窗口，则退出vim
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_SingleClick=1
let Tlist_File_Fold_Auto_Close=0
" }}}

"" ctags.vim {{{
if has('win32')
	let g:ctags_path='E:\Software\Vim\vim73\ctags.exe'
endif
let g:ctags_title=0			" To show tag name in title bar.
let g:ctags_statusline=0	" To show tag name in status line.
let generate_tags=1			" To start automatically when a supported file is opened.
let g:ctags_regenerate=0
" }}}

"" BufExplorer {{{
let g:bufExplorerDefaultHelp=0       " Do not show default help.
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerSortBy='mru'        " Sort by most recently used.
let g:bufExplorerSplitRight=1        " Split left.
let g:bufExplorerSplitVertical=1     " Split vertically.
let g:bufExplorerSplitVertSize = 20  " Split width
let g:bufExplorerUseCurrentWindow=0  " Open in new window.
"" winManager settings
let g:winManagerWindowLayout = "BufExplorer,FileExplorer|TagList"
let g:winManagerWidth = 30
let g:defaultExplorer = 0
nmap <C-W><C-F> :FirstExplorerWindow<cr>
nmap <C-W><C-B> :BottomExplorerWindow<cr>
" nmap <silent> <F8> :WMToggle<cr>
map <C-F8> :WMToggle<cr>
" }}}

"" omnicppcomplete {{{
" map <C-F12> :!ctags -R --c-kinds=+p --fields=+iaS --extra=+q -f tags_local .<CR>
" map <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -f tags_local .<CR>
map <C-F12> :!ctags -R --c-kinds=+p --fields=+iaS --extra=+q .<CR>
map <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
let OmniCpp_GlobalScopeSearch = 1  " 0 or 1
let OmniCpp_NamespaceSearch = 1   " 0 , 1 or 2
let OmniCpp_DisplayMode = 1
let OmniCpp_ShowScopeInAbbr = 0
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
" }}}

"" NERDTreeToggle{{{
" imap <silent> <F7> <esc>:NERDTreeToggle<CR>
nmap <silent> <leader>nt :NERDTreeToggle<CR>
" NERD Commenter
let NERDSpaceDelims = 1
map <M-/> <Plug>NERDCommenterToggle
imap <M-/> <C-O><Plug>NERDCommenterToggle
" }}}

" 切换窗口 {{{
" S
imap <silent> <S-left> <esc><C-W><left>
vmap <silent> <S-left> <esc><C-W><left>
nmap <silent> <S-left> <C-W><left>
imap <silent> <S-right> <esc><C-W><right>
vmap <silent> <S-right> <esc><C-W><right>
nmap <silent> <S-right> <C-W><right>
imap <silent> <S-up> <esc><C-W><up>
vmap <silent> <S-up> <esc><C-W><up>
nmap <silent> <S-up> <C-W><up>
imap <silent> <S-down> <esc><C-W><down>
vmap <silent> <S-down> <esc><C-W><down>
nmap <silent> <S-down> <C-W><down>
" M
" imap <silent> <M-h> <esc><C-W><left>
vmap <silent> <M-h> <esc><C-W><left>
nmap <silent> <M-h> <C-W><left>
" imap <silent> <M-l> <esc><C-W><right>
vmap <silent> <M-l> <esc><C-W><right>
nmap <silent> <M-l> <C-W><right>
" imap <silent> <M-k> <esc><C-W><up>
vmap <silent> <M-k> <esc><C-W><up>
nmap <silent> <M-k> <C-W><up>
" imap <silent> <M-j> <esc><C-W><down>
vmap <silent> <M-j> <esc><C-W><down>
nmap <silent> <M-j> <C-W><down>
" }}}

"" acp {{{
let g:acp_mappingDriven = 1
" }}}

"" Autocommands {{{
"" netrw settings
let g:netrw_winsize=30
nmap <silent> <F10> :Sexplore!<cr>
" 只在下列文件类型被侦测到的时候显示行号，普通文本文件不显示
if has("autocmd")
	autocmd FileType xml,html,xhtml,asm,c,css,java,make,perl,shell,bash,cpp,lisp,python,vim,php,ruby,tex,sh,pl set number
	autocmd FileType xml,html vmap <C-o> <ESC>'<i<!--<ESC>o<ESC>'>o-->
	autocmd FileType java,c,cpp,cs vmap <C-o> <ESC>'<o/*<ESC>'>o*/
	autocmd FileType html,text,php,vim,c,java,xml,bash,shell,perl,python setlocal textwidth=78
	if has("win32")
		autocmd Filetype html,xml,xsl source $VIM/vimfiles/plugin/closetag.vim
	else
		autocmd Filetype html,xml,xsl source ~/.vim/plugin/closetag.vim
	endif
	" autocmd Filetype html,xml,xsl source $VIMRUNTIME/plugin/closetag.vim
	autocmd BufReadPost *
				\ if line("'\"") > 0 && line("'\"") <= line("$") |
				\ exe " normal g`\"" |
				\ endif
endif "has("autocmd")

"" SetFileEncodings {{{
function! SetFileEncodings(encodings)
	let b:my_fileencodings_bak=&fileencodings
	let &fileencodings=a:encodings
endfunction
" }}}

"" RestoreFileEncodings {{{
function! RestoreFileEncodings()
	let &fileencodings=b:my_fileencodings_bak
	unlet b:my_fileencodings_bak
endfunction
" }}}

"" CheckFileEncoding {{{
function! CheckFileEncoding()
	if &modified && &fileencoding != ''
		exec 'e! ++enc=' . &fileencoding
	endif
endfunction
" }}}

"" ConvertHtmlEncoding {{{
function! ConvertHtmlEncoding(encoding)
	if a:encoding ==? 'gb2312'
		return 'gbk'              " GB2312 imprecisely means GBK in HTML
	elseif a:encoding ==? 'iso-8859-1'
		return 'latin1'           " The canonical encoding name in Vim
	elseif a:encoding ==? 'utf8'
		return 'utf-8'            " Other encoding aliases should follow here
	else
		return a:encoding
	endif
endfunction
" }}}

"" DetectHtmlEncoding {{{
function! DetectHtmlEncoding()
	if &filetype != 'html'
		return
	endif
	normal m`
	normal gg
	if search('\c<meta http-equiv=\("\?\)Content-Type\1 content="text/html; charset=[-A-Za-z0-9_]\+">') != 0
		let reg_bak=@"
		normal y$
		let charset=matchstr(@", 'text/html; charset=\zs[-A-Za-z0-9_]\+')
		let charset=ConvertHtmlEncoding(charset)
		normal ``
		let @"=reg_bak
		if &fileencodings == ''
			let auto_encodings=',' . &encoding . ','
		else
			let auto_encodings=',' . &fileencodings . ','
		endif
		if charset !=? &fileencoding &&
					\(auto_encodings =~ ',' . &fileencoding . ',' || &fileencoding == '')
			silent! exec 'e ++enc=' . charset
		endif
	else
		normal ``
	endif
endfunction
" }}}

"" GnuIndent {{{
function! GnuIndent()
	setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
	setlocal shiftwidth=2
	setlocal tabstop=8
endfunction
" }}}

" 在遇到 HTML 文件时，如果 Vim 判断出的编码类型和 HTML 代码中使用
" "<meta http-equiv="Content-Type" content="text/html; charset=编码">"
" 规定的编码不一致，将使用网页中规定的编码重新读入该文件。函数
" ConvertHtmlEncoding 会把一些网页中使用的编码名称转换成 Vim
" 能够正确处理的编码名称；函数 DetectHtmlEncoding 在判断文件类型确实是
" HTML 之后，会记下当前的光标位置，并搜索上面这样的 HTML 代码行，
" 找出字符集编码后，在编码不等于当前文件编码（fileencoding）
" 时且当前文件编码为空或等于系统判断出的文件编码时，
" 使用该编码强制重新读入文件，忽略任何错误（"silent!"）。
" 该自动命令写成是可嵌套执行的（":help autocmd-nested"），
" 目的是保证语法高亮显示有效，且上次打开文件的光标位置能够正确保持。
" Detect charset encoding in an HTML file
au BufReadPost *.htm* nested call DetectHtmlEncoding()
" 只要没有将环境变量 VIM_HATE_SPACE_ERRORS 的值设为零，则把变量
" c_space_errors 的值设为 1——效果是在 C/C++ 代码中“不正确”
" 的空白字符（行尾的空白字符和紧接在制表符之前的空格字符）
" 将会被高亮显示。
function! RemoveTrailingSpace()
	if $VIM_HATE_SPACE_ERRORS != '0' &&
				\(&filetype == 'c' || &filetype == 'cpp' || &filetype == 'vim')
		normal m`
		silent! :%s/\s\+$//e
		normal ``
		let c_space_errors=1
	endif
endfunction
" }}}

" spell {{{
" 使用的英文拼写变体为加拿大风格，即使用拼写“abridgement”
" （而不是"abridgment"）、"colour"（而不是 "color"）等，
" 比较符合中国人一般的英语教科书中的拼写方式，也比较适合于写“国际”英语。
let spchkdialect='can'
" }}}

"" compile {{{
" 编译和运行 c 和 cpp 程序
" 下述代码在windows下使用会报错
" 需要去掉 ./ 这两个字符
if has("unix")
	" C
	map <C-F5> :call CompileRunGcc()<CR>
	func! CompileRunGcc()
		exec "w"
		exec "!gcc % -o %<"
		exec "! ./%<"
	endfunc
	" C++
	map <C-F6> :call CompileRunGpp()<CR>
	func! CompileRunGpp()
		exec "w"
		exec "!g++ % -o %<"
		exec "! ./%<"
	endfunc
endif
" }}}

" .NFO {{{
function! SetFileEncodings(encodings)
	let b:myfileencodingsbak=&fileencodings
	let &fileencodings=a:encodings
endfunction
function! RestoreFileEncodings()
	let &fileencodings=b:myfileencodingsbak
	unlet b:myfileencodingsbak
endfunction
au BufReadPre *.nfo call SetFileEncodings('cp437')|set ambiwidth=single
au BufReadPost *.nfo call RestoreFileEncodings()
au BufWinEnter *.txt call CheckFileEncoding()
" }}}

""高亮显示普通txt文件（需要txt.vim脚本） {{{
au BufRead,BufNewFile *  setfiletype txt
" }}}

" fold {{{
" 用空格键来开关折叠
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc':'zo')<CR>
set foldenable
set foldlevel=100 " don't autofold anything (but I can still fold manually)
set foldopen -=search " don't open folds when search into them
set foldopen -=undo
" fdm=expr: fde=getline(v\:lnum)=~'.'?1\:0: foldtext=foldtext().v\:folddashes.getline(v\:foldstart+1): foldcolumn=2
" 去除空行
" set foldexpr=getline(v:lnum)=~'\\S'&&getline(v:lnum-1)!~'\\S'?'>1':'='
au FileType txt,vim set fdm=expr | set fde=getline(v\:lnum)=~'.'?1:0 | set foldtext=foldtext().v:folddashes.getline(v:foldstart+1) | set foldcolumn=2
au FileType cpp,c,java set foldmethod=syntax | set foldcolumn=1
au FileType perl,tex,php,html,css,sh set foldmethod=indent | set foldcolumn=1
nmap <leader>fc :set foldcolumn=1<cr>
nmap <leader>fC :set foldcolumn=0<cr>

" 根据邮件的后缀名进行相关的设置。 {{{
" 如果打开的文件后缀名是'.eml'，则当成邮件处理。
" http://blah.blogsome.com/2006/04/13/vim_tut_folding/
autocmd! BufReadPre *.eml se fdm=expr fde=v:lnum==1?1:getline(v:lnum)=~'^$'?0:'=' fdt=Mailfdt(v:foldstart,v:foldend) ft=mail | syn on
" 定义函数，用来返回折叠的标题。
" 以折叠的第一和最后一行的行号为参数
func! Mailfdt(fst,fen)
	let fst=a:fst
	" 保存邮件的标题和发信人
	let hfrom=''
	let hsub=''
	let tline=''
	while a:fen!=fst
		let tline=getline(fst)
		" 判断当前行是否是我们感兴趣的行
		" 如果是则保存
		if tline=~'^From: '
			let hfrom=tline
		elseif tline=~'^Subject: '
			let hsub=tline
		endif
		let fst=fst+1
	endwhile
	" 返回相关信息
	if strlen(hfrom) || strlen(hsub)
		return hsub . "\t\t\t" . hfrom
	else
		return getline(a:fst)
	endif
endfunc
" }}}

" " 另一种 fold {{{
" function! HiFold(...)
" 	let tab2space=repeat(nr2char(32),&ts)
" 	if a:0==0
" 		let g:HiStr='\t\|'.tab2space
" 	else
" 		let g:HiStr=a:1
" 	endif
" 	let g:hiLen=strlen(substitute(g:HiStr, ".", "x", "g"))
" 	set fillchars="fold:"
" 	set foldmethod=expr
" 	set foldexpr=HiFoldExpr(v:lnum)
" 	set foldtext=HiFoldText()
" 	hi Folded term=bold cterm=bold gui=bold
" 	hi Folded guibg=NONE guifg=LightBlue
" endfunction
" function! HiFoldExpr(lnum)
" 	if getline(a:lnum)!~'\S'
" 		return "="
" 	endif
" 	let si=getline(prevnonblank(a:lnum))
" 	let sj=getline(nextnonblank(a:lnum+1))
" 	let i=HiGetHi(si)
" 	let j=HiGetHi(sj)
" 	if j==i
" 		return "="
" 	elseif j>i
" 		return ">" . i
" 	else
" 		return "<" . j
" 	endif
" endfunction
" function! HiGetHi(sline)
" 	let c=1
" 	while 1
" 		let shead='^\(' . g:HiStr . '\)\{' . string(c) . '}'
" 		if a:sline=~shead
" 			let c+=1
" 			continue
" 		endif
" 		break
" 	endwhile
" 	return (c)
" endfunction
" function! HiFoldText()
" 	let sLine=getline(v:foldstart)
" 	let tab2space=repeat(nr2char(32),&ts)
" 	let sLine=substitute(sLine,"\t",tab2space,"g")
" 	let a=(sLine=~"^" . nr2char(32))?".":"^"
" 	let sLine=substitute(sLine,a,"+","")
" 	let sLine=sLine . " ~" . string(v:foldend-v:foldstart)
" 	return sLine
" endfunction
" command! -nargs=? HiFold call HiFold(<args>)
" HiFold
" }}}

"" TOhtml 相关 {{{
"" 运行 runtime! syntax/2html.vim 时保留 folding 特性
let html_dynamic_folds = 1
"" 代码行号从 0 开始
" let html_number_lines=0
"" 恢复默认
" unlet html_number_lines
"" 使用 css
" let html_use_css=1
"" 生成 html 时忽略代码折叠
" let html_ignore_folding=1
" }}}

"" minibufexpl插件的一般设置 {{{
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
" }}}

"" Omni menu colors {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Pmenu		普通项 |hl-Pmenu|
"" PmenuSel	选中项 |hl-PmenuSel|
"" PmenuSbar	滚动条 |hl-PmenuSbar|
"" PmenuThumb	滚动条拇指 (thumb) |hl-PmenuThumb|
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" 这一部分写在 Celibate.vim
" hi Pmenu guibg=#00b2bf guifg=#ffffff
" hi PmenuSel guibg=#40FF7F guifg=#9B30FF
" hi PmenuSbar guibg=#00b2bf guifg=#00ff0f
" hi PmenuThumb guibg=#0ff0ff guifg=#0fff00
" " hi Pmenu guibg=#333333
" " hi PmenuSel guibg=#555555 guifg=#ffffff
" }}}

"" common {{{
" Change buffer - without saving
set hid
"No sound on errors.
set noerrorbells
set novisualbell
set t_vb=
" }}}

" Calendar {{{
let g:calendar_focus_today = 1
" }}}

" TeX {{{
let g:tex_flavor='latex'
" }}}

" calibre.vim - Syntax Highlighting {{{
augroup filetype
	au!
	au! BufRead,BufNewFile *.rules  set filetype=calibre
	au! BufRead,BufNewFile *.rul     set filetype=calibre
augroup END
" }}}

"" MRU {{{
" let MRU_File = 'd:\myhome\_vim_mru_files'
let MRU_Max_Entries = 1000
" let MRU_Exclude_Files = '^/tmp/.*\|^/var/tmp/.*'  " For Unix
" let MRU_Exclude_Files = '^c:\\temp\\.*'           " For MS-Windows
let MRU_Include_Files = '\.c$\|\.h$'
let MRU_Window_Height = 15
let MRU_Use_Current_Window = 1
let MRU_Auto_Close = 0
let MRU_Add_Menu = 0
let MRU_Max_Menu_Entries = 20
let MRU_Max_Menu_Entries = 20
" }}}

"" PostScript {{{
"" 打印，+postscript 时有用
" 打印机使用"iP1880-series", 不配置表示使用系统默认打印机.
"set printdevice=iP1880-series
" set printdevice=HP\ Color\ LaserJet\ 8550-PS
" 打印编码使用"utf-8", 不配置的话使用encoding的值.
set printencoding=utf-8
" 打印所用宽字符集为ISO10646, 这个和printencoding值要匹配
set printmbcharset=ISO10646
" 打印所用字体, 在linux下, 要用ghostscript里已有的字体, 不然会打印乱码.
" set printmbfont=r:STSong-Light,c:yes "MSungGBK-Light
" set printmbfont=r:MicrosoftYaHei,b:STHeiti-Regular,i:FangSong,o:STFangsong-Light,c:yes "MSungGBK-Light
set printmbfont=r:bkaiu,b:ShanHeiSun-Light,i:bsmi,o:gbsn,c:yes "MSungGBK-Light
" 打印可选项, formfeed: 是否处理换页符, header: 页眉大小, paper: 用何种纸, duplex: 是否双面打印, syntax: 是否支持语法高
set printoptions=formfeed:y,header:5,paper:A4,duplex:on,syntax:y
" 页眉格式
set printheader=%<%f%h%m%=Page\ %N
" set printheader=%<Page\ %N
" }}}

"" xpm {{{
" function! GetPixel()
"    let c = getline(".")[col(".") - 1]
"    echo c
"    exe "noremap <LeftMouse> <LeftMouse>r".c
"    exe "noremap <LeftDrag>	<LeftMouse>r".c
" endfunction
" noremap <RightMouse> <LeftMouse>:call GetPixel()<CR>
" set guicursor=n:hor20	   " 可以看到光标下的颜色
" }}}

"" PHP {{{
" "保存PHP文件时自动更新最后修改时间
" autocmd BufWritePre,FileWritePre *.php   ks|call LastModified()|'s
" function! LastModified()
" 	let l = line("$")
" 	let n=1
" 	" 判断前20行里是否有符合表达式要求的字符串
" 	while n<20
" 		let line = getline(n)
" 		" 有则执行更新动作
" 		if line =~ '\s\*\s\$Id:\s'.expand("%:t").'\s.*'
" 			exe "1," . l . " s/$Id: ".expand("%:t")." .*/$Id: ". expand("%:t") . strftime(" %Y-%m-%d %X")." zhangxinyi$"
" 		endif
" 		let n = n + 1
" 	endwhile
" endfunction
" }}}

"" php
au FileType php setlocal dict+=$VIM/vimfiles/ExtraVim/php_funclist.txt
"" 检查当前文件代码语法 (php){{{
function! CheckSyntax()
	if &filetype!="php"
		echohl WarningMsg | echo "Fail to check syntax! Please select the right file!" | echohl None
		return
	endif
	if &filetype=="php"
		" Check php syntax
		setlocal makeprg=\"php\"\ -l\ -n\ -d\ html_errors=off
		" Set shellpipe
		setlocal shellpipe=>
		" Use error format for parsing PHP error output
		setlocal errorformat=%m\ in\ %f\ on\ line\ %l
	endif
	execute "silent make %"
	set makeprg=make
	execute "normal :"
	execute "copen"
endfunction
map <F6> :call CheckSyntax()<CR>
"}}}

"" VimWiki
if has("win32")
	let g:vimwiki_use_mouse = 1
	let g:vimwiki_list = [{'path': 'E:/Software/Vim/VimWiki/',
				\ 'path_html': 'E:/Software/Vim/VimWiki/html/',
				\ 'html_header': 'E:/Software/Vim/VimWiki/template/header.tpl',
				\ 'html_footer': 'E:/Software/Vim/VimWiki/template/footer.tpl'}]
	" highlight
	" let wiki = {}
	" let wiki.path = '~/my_wiki/'
	" let wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}
	" let g:vimwiki_list = [wiki]
endif

"" Remove trailing whitespace when writing a buffer, {{{
" but not for diff files.
" From: Vigil
function RemoveTrailingWhitespace()
	if &ft != "diff"
		let b:curcol = col(".")
		let b:curline = line(".")
		silent! %s/\s\+$//
		silent! %s/\(\s*\n\)\+\%$//
		call cursor(b:curline, b:curcol)
	endif
endfunction
autocmd BufWritePre * call RemoveTrailingWhitespace()
" }}}

" When I close a tab, remove the buffer {{{
set nohidden
" }}}

"" map {{{
"" This is useful when two lines is combined without a space
map <leader>j gJdw
"" 用 ` 替换 <ESC>
" imap ` <ESC>
" This is totally awesome - remap jj to escape in insert mode.  You'll never type jj anyway, so it's great!
inoremap jj <Esc>
nnoremap JJJJ <Nop>
au FileType cpp,c,perl,html,lisp,java,php,tex,vim,sh imap { {}<ESC>i
au FileType cpp,c,perl,html,lisp,java,php,tex,vim,sh imap [ []<ESC>i
au FileType cpp,c,perl,html,lisp,java,php,tex,vim,sh imap ( ()<ESC>i
" au FileType cpp,c,perl,html,vim,sh imap < <><ESC>i
" au FileType tex,cpp,c,perl,html imap ' ''<ESC>i
" au FileType tex,cpp,c,perl,html imap " ""<ESC>i
au FileType cpp,c,perl,html,lisp,java,php,txt,tex,vim,sh imap <C-a> <ESC>I
au FileType cpp,c,perl,html,lisp,java,php,txt,tex,vim,sh imap <C-e> <ESC>A
au FileType cpp,c,perl,html,lisp,java,php,txt,tex,vim,sh imap <C-l> <ESC>f)a
" au FileType tex,cpp,c,perl imap <C-p> <Up>
" au FileType tex,cpp,c,perl imap <C-n> <Down>
au FileType cpp,c,perl,html,lisp,java,php,txt,tex,vim,sh imap <C-b> <Left>
au FileType cpp,c,perl,html,lisp,java,php,txt,tex,vim,sh imap <C-f> <Right>
au FileType cpp,c,perl,html,lisp,java,php,txt,tex,vim,sh imap <M-k> <Up>
au FileType cpp,c,perl,html,lisp,java,php,txt,tex,vim,sh imap <M-j> <Down>
au FileType cpp,c,perl,html,lisp,java,php,txt,tex,vim,sh imap <M-h> <Left>
au FileType cpp,c,perl,html,lisp,java,php,txt,tex,vim,sh imap <M-l> <Right>
au FileType cpp,c,perl,html,lisp,java,php,txt,tex,vim,sh imap <C-d> <ESC>lxi
au FileType cpp,c,perl,html,lisp,java,php,txt,tex,vim,sh imap <C-k> <ESC>ld$a
au FileType cpp,c,perl,html,lisp,java,php,txt,tex,vim,sh imap <M-o> <ESC>o
" 和 SignColumn 冲突，先不用这个
" imap <M-s> <ESC>:w<cr>
imap <M-q> <ESC>:q<cr>
" }}}

if has("win32")
	"" words complete
	au FileType txt setlocal dict+=$VIM/vimfiles/ExtraVim/zh_CN.dic
	au FileType txt setlocal dict+=$VIM/vimfiles/ExtraVim/en_US.dic
	au FileType tex setlocal dict+=$VIM/vimfiles/ExtraVim/latex.dic
	"" yankring
	let g:yankring_history_dir = '$VIM'
else
	"" words complete
	au FileType txt setlocal dict+=$HOME/.vim/ExtraVim/zh_CN.dic
	au FileType txt setlocal dict+=$HOME/.vim/ExtraVim/en_US.dic
	au FileType tex setlocal dict+=$HOME/.vim/ExtraVim/latex.dic
	"" yankring
	let g:yankring_history_dir = '~/'
endif

"" MayanSmoke {{{
" Customization:
" ==============
"
" If any of the following highlights are defined (e.g., in your "~/.vimrc"), these will override the default highlight definitions:
"
"     MayanSmokeCursorLine    (will be applied to: CursorColumn and CursorLine)
"     MayanSmokeSearch        (will be applied to: Search and IncSearch)
"     MayanSmokeSpecialKey    (will be applied to: SpecialKey)
"
" For example, you can set the following in your "~/.vimrc" to select your own colors for these items:
"
"     hi MayanSmokeCursorLine     guifg=NONE   guibg=yellow  gui=NONE
"     hi MayanSmokeSearch         guifg=white  guibg=blue    gui=NONE
"     hi MayanSmokeSpecialKey     guifg=NONE   guibg=green   gui=NONE
"
" Alternatively, you can define one or more of the following values in your "~/.vimrc" to select different pre-defined levels of visibility for the above highlights:
"
let g:mayansmoke_cursor_line_visibility = 0  " lower visibility
let g:mayansmoke_cursor_line_visibility = 1  " medium visibility
let g:mayansmoke_cursor_line_visibility = 2  " higher visibility
let g:mayansmoke_search_visibility = 0 " low visibility
let g:mayansmoke_search_visibility = 1 " medium visibility (default)
let g:mayansmoke_search_visibility = 2 " high visibility
let g:mayansmoke_search_visibility = 3 " very high visibility
let g:mayansmoke_search_visibility = 4 " highest visibility
let g:mayansmoke_special_key_visibility = 0  " lower visibility
let g:mayansmoke_special_key_visibility = 1  " medium visibility
let g:mayansmoke_special_key_visibility = 2  " higher visibility
" }}}

"" cppcomplete
imap <C-F5> <ESC>:PreviewClass<CR>a

"" cscope {{{
if has("cscope")
	" If you want to use Popup menu for :Cscope command, put a line in .vimrc
	" cscope_quickfix.vim
	let Cscope_PopupMenu = 1
	set cscopequickfix=s-,c-,d-,i-,t-,e-
	set csto=0
	set cst
	set nocsverb
	if filereadable("cscope.out")
		cs add cscope.out
		" else add database pointed to by environment
	elseif $CSCOPE_DB !=""
		cs add $CSCOPE_DB
	endif
	set csverb
endif
" }}}

"" IME {{{
if has("win32")
	if has('multi_byte_ime')
		" highlight Cursor guifg=NONE	guibg=Green
		highlight CursorIM guifg=Cyan	guibg=Purple
	endif
endif
" }}}

"" Twiddle case {{{
function! TwiddleCase(str)
	if a:str ==# toupper(a:str)
		let result = tolower(a:str)
	elseif a:str ==# tolower(a:str)
		let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
	else
		let result = toupper(a:str)
	endif
	return result
endfunction
vnoremap ~ ygv"=TwiddleCase(@")<CR>Pgv
" }}}

"" TVO {{{
" defaults:
let otl_install_menu=1
let no_otl_maps=0
let no_otl_insert_maps=0
" }}}

" overrides: {{{
let otl_bold_headers=0
let otl_use_thlnk=0
" }}}

" OTL? {{{
" au BufWinLeave *.otl mkview
" au BufWinEnter *.otl silent loadview
let maplocalleader = ","
" }}}

"" 添加/更新作者信息 {{{
map <leader>in :call TitleDet()<cr>'s
function AddTitle()
	call append(0,"/*")
	call append(1," * Author: lipcore")
	call append(2," * Last modified: ".strftime("%Y-%m-%d %H:%M"))
	call append(3," * Filename: ".expand("%:t"))
	call append(4," * Description: ")
	call append(5," * Version: ")
	call append(6," */")
	echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
endf
function UpdateTitle()
	"更新最近修改时间和文件名
	normal m'
	execute '/# *Last modified:/s@:.*$@\=strftime(": %Y-%m-%d %H:%M")@'
	normal ''
	normal mk
	execute '/# *Filename:/s@:.*$@\=": ".expand("%:t")@'
	execute "noh"
	normal 'k
	echohl WarningMsg | echo "Successful in updating the copy right." | echohl None
endfunction
function TitleDet()
	let n=1
	"默认为添加
	while n < 5
		let line = getline(n)
		if line =~ '^\#\s*\S*Last\smodified:\S*.*$'
			call UpdateTitle()
			return
		endif
		let n = n + 1
	endwhile
	call AddTitle()
endfunction
" }}}

"" LastModified {{{
" " If buffer modified, update any 'Last modified: ' in the first 20 lines.
" " 'Last modified: ' can have up to 10 characters before (they are retained).
" " Restores cursor and window position using save_cursor variable.
" function! LastModified()
" 	if &modified
" 		let save_cursor = getpos(".")
" 		let n = min([20, line("$")])
" 		exe '1,' . n . 's#^\(.\{,10}Last modified: \).*#\1' .
" 					\ strftime('%a %b %d, %Y  %I:%M%p') . '#e'
" 		call setpos('.', save_cursor)
" 	endif
" endfun
" autocmd BufWritePre * call LastModified()
"
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Last change用到的函数，返回时间，能够自动调整位置
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" function! TimeStamp(...)
"     let sbegin = ''
"     let send = ''
"     let pend = ''
"     if a:0 >= 1
"         let sbegin = '' . a:1
"         let sbegin = substitute(sbegin, '*', '\\*', "g")
"         let sbegin = sbegin . '\s*'
"     endif
"     if a:0 >= 2
"         let send = '' . a:2
"         let pend = substitute(send, '*', '\\*', "g")
"     endif
"     let pattern = 'Last Change: .\+' . pend
"     let pattern = '^\s*' . sbegin . pattern . '\s*$'
"     let now = strftime('%Y-%m-%d %H:%M:%S',localtime())
"
"     let row = search(pattern, 'n')
"     if row  == 0
"         let now = a:1 . 'Last Change:  ' . now . send
"         call append(2, now)
"     else
"         let curstr = getline(row)
"
"         let col = match( curstr , 'Last')
"         let now = a:1 . 'Last Change:  ' . now . send
"         call setline(row, now)
"     endif
" endfunction
"
" "" Last Change:  2010-07-29 18:50:39
" au BufWritePre _vimrc call TimeStamp('" ')
"
" " * Last Change:  2010-07-29 18:50:39
" au BufWritePre *.js,*.css call TimeStamp(' * ')
"
" "# Last Change:  2010-07-29 18:50:39
" au BufWritePre *.rb,*.py,*.sh call TimeStamp('# ')
"
" Search the first 8 lines for Last Updated: and update the current user/datetime
" function! LastMod()
" 	if &modified
" 		if line("$") > 8
" 			let l = 8
" 		else
" 			let l = line("$")
" 		endif
" 		let time = strftime("%m\\\/%d, %Y")
" 		" exe "1," . l . "g/Last Updated: /s/Last Updated: .*/Last Updated: yyhuang " . time . "/"
" 		exe "1," . l . "g/Last modified: /s/Last modified: .*/Last modified: lipcore " . time . "/"
" 	endif
" endfun
" This autocommand will call LastMod function everytime you save a file
" autocmd BufWrite * ks|call LastMod()|'s
" }}}

"" timestamp.vim {{{
let timestamp_regexp = '\v\C%(<Last %([cC]hanged?|[Mm]odified):\s+)@<=.*$'
" }}}

"" Perl {{{
" Hack 5. Autocomplete Perl Identifiers in Vim
set iskeyword+=:
" Run Tests from Within Vim
" form: Perl Hacks, Chapter 1, Hack 10.
" run the currently edited test file
" map <leader>pt <Esc>:!prove -v1 %<CR>
" If lib/ is not where you typically do your development, use the I switch to add a different path to @INC.
map <leader>pt  <Esc>:!prove -Iwork/ -v %<CR>
" Seeing failures
map <leader>pT <Esc>:!prove -lv % \\| less<CR>
let perl_extended_vars=1
set matchpairs+=<:>  " allow % to bounce between angles
" perl-support
let g:Perl_AuthorName      = 'lipcore'
let g:Perl_AuthorRef       = 'http://lxh.heliohost.org/'
let g:Perl_Email           = 'erocpil@gmail.com'
let g:Perl_Company         = 'lipcore'
" }}}

"" Open URL in browser {{{
function! Browser ()
	let line = getline (".")
	let line = matchstr (line, "http[^'   ]*")
	silent exec "!E:\\Software\\FirefoxPortable\\FirefoxPortable.exe ".line
endfunction
"}}}

"" Open Url on this line with the browser \w {{{
map <Leader>url :call Browser ()<CR>
" }}}

"" url triggering {{{
" need fix
if has("win32")
	let g:utl_rc_app_browser = 'silent !start E:\Software\FirefoxPortable\FirefoxPortable.exe %u'
	let g:utl_rc_app_mailer = 'silent !start C:\Program Files\Microsoft Office\OFFICE11\OUTLOOK.EXE /c ipm.note /m %u'
	let g:utl_mt_application_excel = ':silent !start C:\Program Files\Microsoft Office\OFFICE11\EXCEL.EXE "%P"'
	let g:utl_mt_application_msword = ':silent !start C:\Program Files\Microsoft Office\OFFICE11\WINWORD.EXE "%P"'
	let g:utl_mt_application_powerpoint = ':silent !start C:\Program Files\Microsoft Office\OFFICE11\POWERPNT.EXE "%P"'
	let g:utl_mt_application_pdf = ':silent !start C:\Program Files\Adobe\Acrobat 7.0\Reader\AcroRd32.exe "%P"'
elseif has("unix")
	let g:utl_rc_app_browser = "silent !firefox -remote 'ping()' && firefox -remote 'openURL( %u )' || firefox '%u' &"
endif
" }}}

"" Theme Rotating {{{
let themeindex=0
function! RotateColorTheme()
	let y = -1
	while y == -1
		let colorstring = "#Celibate#candyman#mayansmoke#inkpot#ron#murphy#pablo#desert#vilight#void#softbluev2#thegoodluck#torte#"
		let x = match( colorstring, "#", g:themeindex )
		let y = match( colorstring, "#", x + 1 )
		let g:themeindex = x + 1
		if y == -1
			let g:themeindex = 0
		else
			let themestring = strpart(colorstring, x + 1, y - x - 1)
			return ":colorscheme ".themestring
		endif
	endwhile
endfunction
nnoremap <silent> <C-F9> :execute RotateColorTheme()<CR>
" }}}

" Paste Toggle {{{
let paste_mode = 0 " 0 = normal, 1 = paste
func! Paste_on_off()
	if g:paste_mode == 0
		set paste
		let g:paste_mode = 1
	else
		set nopaste
		let g:paste_mode = 0
	endif
	return
endfunc
" }}}
" Paste Mode!  Dang! <F10> {{{
nnoremap <silent> <C-F10> :call Paste_on_off()<CR>
set pastetoggle=<C-F10>
" }}}

"" Todo List Mode {{{
function! TodoListMode()
	e ~/.todo.otl
	Calendar
	wincmd l
	set foldlevel=1
	tabnew ~/.notes.txt
	tabfirst
	" or 'norm! zMzr'
endfunction
" }}}

" TODO Mode {{{
nnoremap <silent> <Leader>todo :execute TodoListMode()<CR>
" }}}

" Testing {{{
set completeopt=longest,menuone,preview
inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
inoremap <expr> <c-n> pumvisible() ? "\<lt>c-n>" : "\<lt>c-n>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"
inoremap <expr> <m-;> pumvisible() ? "\<lt>c-n>" : "\<lt>c-x>\<lt>c-o>\<lt>c-n>\<lt>c-p>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"
" }}}

" Fix email paragraphs {{{
nnoremap <leader>par :%s/^>$//<CR>
" }}}

"" Python Calculator {{{
" usage:
" :py from cmath import *
" :Calc exp(pi*1j) , " Euler famous identify e^i.pi = -1"
" (-1+1.22460635382e-016j)
" :Calc sum(range(1,100+1)), "Gauss' famous identity sum(1,100)"
" 5050
if has('python')
	:command! -nargs=+ Calc :py print <args>
	:py from cmath import *
endif
" }}}

"" Show uptime in command line {{{
map <leader>up :call UpTime()<cr>
" }}}

" hidden {{{
set hidden
" }}}

"" Online Documentation {{{
function! OnlineDoc()
	" let s:browser = "swiftfox"
	let s:browser = "E:\\Software\\FirefoxPortable\\FirefoxPortable.exe"
	let s:wordUnderCursor = expand("<cword>")
	if &ft == "cpp" || &ft == "c"
		let s:url = "http://www.google.com/codesearch?q=".s:wordUnderCursor."+lang:".&ft
	elseif &ft == "vim"
		let s:url = "http://www.google.com/codesearch?q=".s:wordUnderCursor
	else
		return
	endif
	let s:cmd = "silent !" . s:browser . " " . s:url  "&"
	execute  s:cmd
	redraw!
endfunction
" let maplocalleader=',' " all my macros start with
" online doc search
" map <LocalLeader>k :call OnlineDoc()<CR>
map <leader>k :call OnlineDoc()<CR>
" }}}

"" What's this? {{{
" Normal Mode, Visual Mode, and Select Mode,
" use <Tab> and <Shift-Tab> to indent
" @see http://c9s.blogspot.com/2007/10/vim-tips.html
" nmap <tab> v>
" nmap <s-tab> v<
" vmap <tab> >gv
" vmap <s-tab> <gv
" }}}

" Open Windows Explorer and Fouse current file. {{{
" %:p:h     " Just Fold Name.
if has("win32")
	nmap <C-F11> :!start explorer /e,/select, %:p<CR>
	imap <C-F11> <Esc><F6>
	command -nargs=0 Explor :!start explorer /e,/select, %:p
	command -nargs=0 Explorer :!start explorer /e,/select, %:p
endif
" }}}

" get week day string in chinese. {{{
function Week_cn()
	return "星期".strpart("日一二三四五六", strftime("%w")*3, 3)
endfunction
" }}}

"" dictionary {{{
" nmap <C-\> :!sdcv "<cword>" <C-R>=expand("<cword>")<CR><CR>
nmap <leader>d :!curl dict://dict.org/d:<cword><CR><CR>
" }}}

"" signs {{{
nmap <M-g> :call sjump#JumpToLabel()<cr>
if has('signs')
	if has('win32')
		"" SignColumn
		sign define scc text=>> texthl=SignColumn linehl=Search
		sign define siv text=-> icon=e:/Software/Vim/Icons/vim.xpm texthl=SignColumn linehl=ModeMsg
		sign define sir text=-> icon=e:/Software/Vim/Icons/apple-red.xpm texthl=SignColumn linehl=ErrorMsg
		sign define sig text=-> icon=e:/Software/Vim/Icons/apple-green.xpm texthl=SignColumn linehl=Question
		sign define sid text=-> icon=e:/Software/Vim/Icons/debian-logo.xpm texthl=SignColumn linehl=IncSearch
		sign define sia text=-> icon=e:/Software/Vim/Icons/gnome-aorta.xpm texthl=SignColumn linehl=StatusLine
		sign define sie text=-> icon=e:/Software/Vim/Icons/gnome-emacs.xpm texthl=SignColumn linehl=Visual
		sign define sip text=-> icon=e:/Software/Vim/Icons/gnome-gimp.xpm texthl=SignColumn linehl=VisualNOS
		sign define siu text=-> icon=e:/Software/Vim/Icons/gnome-suse.xpm texthl=SignColumn linehl=Directory
		sign define sii text=-> icon=e:/Software/Vim/Icons/iceweasel.xpm texthl=SignColumn linehl=LineNr
		" sign define sig icon=e:/Software/Vim/Icons/.xpm texthl=SignColumn linehl=Question
		" sign place {id} line={lnum} name={name} file={fname}
		" sign place {id} line={lnum} name={name} buffer={nr}
		" sign place {id} name={name} file={fname}
		" sign place {id} name={name} buffer={nr}
		" sign jump {id} file={fname}
		" sign jump {id} buffer={nr}
	else
		sign define scc text=〠 texthl=SignColumn linehl=Search
		sign define sch text=☯☎ texthl=SignColumn linehl=Search
		sign define sct text=〄 texthl=SignColumn linehl=Search
		sign define siv text=♥ icon=/root/Media/Icons/vim.png texthl=SignColumn linehl=ModeMsg
		sign define sir text=♥ icon=/root/Media/Icons/apple-red.png texthl=SignColumn linehl=ErrorMsg
		sign define sig text=♥ icon=/root/Media/Icons/apple-green.png texthl=SignColumn linehl=Question
		sign define sid text=♥ icon=/root/Media/Icons/debian-logo.png texthl=SignColumn linehl=IncSearch
		sign define sia text=♥ icon=/root/Media/Icons/gnome-aorta.png texthl=SignColumn linehl=StatusLine
		sign define sie text=♥ icon=/root/Media/Icons/gnome-emacs.png texthl=SignColumn linehl=Visual
		sign define sip text=♥ icon=/root/Media/Icons/gnome-gimp.png texthl=SignColumn linehl=VisualNOS
		sign define siu text=♥ icon=/root/Media/Icons/gnome-suse.png texthl=SignColumn linehl=Directory
		sign define sii text=♥ icon=/root/Media/Icons/iceweasel.png texthl=SignColumn linehl=LineNr
	endif
	nmap <leader>scc :exe ":sign place 1 line=" . line('.') . " name=scc file=" . expand("%:p")<cr>
	nmap <leader>sch :exe ":sign place 1 line=" . line('.') . " name=sch file=" . expand("%:p")<cr>
	nmap <leader>sct :exe ":sign place 1 line=" . line('.') . " name=sct file=" . expand("%:p")<cr>
	nmap <leader>jsc :exe ":sign jump 1 file=" . expand("%:p")<cr>
	nmap <leader>sv :exe ":sign place 2 line=" . line('.') . " name=siv file=" . expand("%:p")<cr>
	nmap <leader>jsv :exe ":sign jump 2 file=" . expand("%:p")<cr>
	nmap <leader>sr :exe ":sign place 3 line=" . line('.') . " name=sir file=" . expand("%:p")<cr>
	nmap <leader>jsr :exe ":sign jump 3 file=" . expand("%:p")<cr>
	nmap <leader>sg :exe ":sign place 4 line=" . line('.') . " name=sig file=" . expand("%:p")<cr>
	nmap <leader>jsg :exe ":sign jump 4 file=" . expand("%:p")<cr>
	nmap <leader>sd :exe ":sign place 5 line=" . line('.') . " name=sid file=" . expand("%:p")<cr>
	nmap <leader>jsd :exe ":sign jump 5 file=" . expand("%:p")<cr>
	nmap <leader>sa :exe ":sign place 6 line=" . line('.') . " name=sia file=" . expand("%:p")<cr>
	nmap <leader>jsa :exe ":sign jump 6 file=" . expand("%:p")<cr>
	nmap <leader>se :exe ":sign place 7 line=" . line('.') . " name=sie file=" . expand("%:p")<cr>
	nmap <leader>jse :exe ":sign jump 7 file=" . expand("%:p")<cr>
	nmap <leader>sp :exe ":sign place 8 line=" . line('.') . " name=sip file=" . expand("%:p")<cr>
	nmap <leader>jsp :exe ":sign jump 8 file=" . expand("%:p")<cr>
	nmap <leader>su :exe ":sign place 9 line=" . line('.') . " name=siu file=" . expand("%:p")<cr>
	nmap <leader>jsu :exe ":sign jump 9 file=" . expand("%:p")<cr>
	nmap <leader>si :exe ":sign place 10 line=" . line('.') . " name=sii file=" . expand("%:p")<cr>
	nmap <leader>jsi :exe ":sign jump 10 file=" . expand("%:p")<cr>
	" ♥☎撤销所有的标号放置
	" sign unplace *
	nmap <leader>sS :sign unplace *<cr>
	" 撤销光标所在标号放置
	" sign unplace
	nmap <leader>sC :sign unplace 1<cr>
	nmap <leader>sV :sign unplace 2<cr>
	nmap <leader>sR :sign unplace 3<cr>
	nmap <leader>sG :sign unplace 4<cr>
	nmap <leader>sD :sign unplace 5<cr>
	nmap <leader>sA :sign unplace 6<cr>
	nmap <leader>sE :sign unplace 7<cr>
	nmap <leader>sP :sign unplace 8<cr>
	nmap <leader>sU :sign unplace 9<cr>
	nmap <leader>sI :sign unplace 10<cr>
	" 列出所有文件里放置的标号
	" sign place
	" 列出文件{fname}里放置的标号
	" sign place file={fname}
	" sign jump {id} file={fname}
	"" SignColumn END
	"" FlagIt -- 使用 SignColumn 简单方法 {{{
	map <leader>fa :FlagIt arrow<CR>
	map <leader>ff :FlagIt function<CR>
	map <leader>fw :FlagIt warning<CR>
	map <leader>fe :FlagIt error<CR>
	map <leader>fs :FlagIt step<CR>
	map <leader>fA :UnFlag arrow<CR>
	map <leader>fF :UnFlag function<CR>
	map <leader>fW :UnFlag warning<CR>
	map <leader>fE :UnFlag error<CR>
	map <leader>fS :UnFlag step<CR>
	map <leader>uf :UnFlag<CR>
	if has('win32')
		let icons_path = "e:/Software/Vim/Icons/16x16/actions/"
		let g:Fi_Flags = { "arrow" : [icons_path."address-book-new.xpm", "> ", 1, "texthl=Title"],
					\ "function" : [icons_path."appointment-new.xpm", "+ ", 0, "texthl=Comment"],
					\ "warning" : [icons_path."bookmark-new.xpm", "! ", 0, "texthl=WarningMsg"],
					\ "error" : [icons_path."contact-new.xpm", "XX", "true", "texthl=ErrorMsg linehl=ErrorMsg"],
					\ "step" : [icons_path."document-new.xpm", "..", "true", ""] }
	else
		let icons_path = "/root/Media/Icons/16x16/actions/"
		let g:Fi_Flags = { "arrow" : [icons_path."address-book-new.png", "> ", 1, "texthl=Title"],
					\ "function" : [icons_path."appointment-new.png", "+ ", 0, "texthl=Comment"],
					\ "warning" : [icons_path."bookmark-new.png", "! ", 0, "texthl=WarningMsg"],
					\ "error" : [icons_path."contact-new.png", "XX", "true", "texthl=ErrorMsg linehl=ErrorMsg"],
					\ "step" : [icons_path."document-new.png", "..", "true", ""] }
	endif
	let g:Fi_OnlyText = 0
	let g:Fi_ShowMenu = 1
	"" FlagIt END }}}
endif
" signs END}}}

" 专用于复制粘贴后的空一行排版用 {{{
" map <C-a> ]]%o<ESC>
" map <C-x> :buffers<cr>:bu
" }}}

"" 取光标下的单词在新窗口中打开 {{{
function Open_new_tab_and_tags_locate_cursor_word()
	let word=expand('<cword>')
	execute "tabedit"
	execute "edit ."
	execute "ts " word
endfunction
map <leader>tcw :call Open_new_tab_and_tags_locate_cursor_word()<cr>
" }}}

" "开关光标纵列的高亮以确定光标当前位置 {{{
" let g:cur_col_on = 0
" function Turn_on_cursorcolumn()
" 	if  g:cur_col_on
" 		execute "set nocursorcolumn"
" 	else
" 		execute "set cursorcolumn"
" 	endif
" 	let g:cur_col_on = !g:cur_col_on
" endfunction
" " map <C-F2> :call Turn_on_cursorcolumn()<cr>
" }}}

"" copy to command line {{{
"" http://yuxu9710108.blog.163.com/blog/static/237515342010102641518823/
" 比如复制一行：yy
" :ctrl-r "
" 即可复制这一行到vim的命令行
" ****************************
" 现在说下我个人已经知道的几种操作：
" 1.从vim中拷贝字符串到:命令行：
" 先yank字符串
" 然后在:命令行ctrl-r"
" 2.从其它窗体中拷贝字符串到:命令行：
" 先拷贝字符串到系统剪贴板
" 然后在:命令行ctrl-r+或者ctrl-r*
" 3.利用<CTRL-R><CTRL-W>在:命令行补齐：
" 先把光标定位到关键词
" 然后切换到:命令行按<CTRL-R><CTRL-W>
" 4.鼠标中键
" 拷贝字符串到:命令行，主要是用于执行替换操作（查找有#和*）
" 先yank字符串
" 然后在:命令行ctrl-r"
" }}}

"" 使用 grep 而不是 findstr {{{
set grepprg=grep\ -nH
" }}}

"" guitable {{{
" let &guitablabel = "%{FileInfo()}\ %{getcwd()}\ "
let &guitabtooltip = "%{FileInfo()}\ %{getcwd()}\ "
" }}}

"" default filetype {{{
"" http://vim.wikia.com/wiki/File_type_plugins
" let g:do_filetype = 0
" au GUIEnter,BufAdd * if expand('<afile>') == "" | let g:do_filetype = 1 | endif
" au BufEnter * if g:do_filetype | setf txt | let g:do_filetype = 0 | endif
" }}}

"" Indent Guides : A plugin for visually displaying indent levels in Vim. {{{
" http://www.vim.org/scripts/script.php?script_id=3361
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd	guibg=Grey20	ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven	guibg=Grey25	ctermbg=4
" let g:indent_guides_color_change_percent = 50
let g:indent_guides_start_level = 0
let g:indent_guides_guide_size = 1
" }}}

"" pathogen.vim : Easy manipulation of 'runtimepath', 'path', 'tags', etc {{{
"" description
" Pathogen is a simple library for manipulating comma delimited path options. Add this to your vimrc:
"
"   call pathogen#runtime_append_all_bundles()
"
" After adding this, you can take any plugin, unzip/untar/svn-checkout/git-clone it to its own private directory in .vim/bundle, and it will be added to the runtime path.  This makes it easy to remove or update each plugin individually.
"
"" The full list of functions includes:
"
" pathogen#split: convert a comma delimited option to an array
" pathogen#join: convert an array to a comma delimited option
" pathogen#glob: wrapper around glob() that returns an array
" pathogen#runtime_prepend_subdirectories: prepend all subdirectories of a path to the runtimepath and append all after subsubdirectories
" pathogen#runtime_append_all_bundles: for each directory in the runtime path, look for a "bundle" entry and add the subdirectories of it to the path, as with runtime_prepend_subdirectories
call pathogen#runtime_append_all_bundles()
" }}}

" inoremap ( ()<ESC>i
" inoremap ) <c-r>=ClosePair(')')<CR>
function! ClosePair(char)
	if getline('.')[col('.')-1]==a:char
		return "\<Right>"
	else
		return a:char
	endif
endfunction

" goto the last line when you reopen a file {{{
au BufReadPost * if line("'\"")>0 |
			\ if line("'\"")<=line("$") |
			\ exe("norm '\"") |
			\ else |
			\ exe "norm $" |
			\ endif |
			\ endif
" }}}
