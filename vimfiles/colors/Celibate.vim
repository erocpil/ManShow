" /*
"  * Author: lipcore
"  * Last modified: 星期日 16 一月 2011 10:36:43 下午 中国标准时间
"  * Filename: Celibate.vim
"  * Description:
"  * Version:
"  */

" set background=light
set background=dark
hi clear
if exists("syntax_on")
	syntax reset
endif
" Theme Name
let g:colors_name = "Celibate"

"
" hi Comment		                    guifg=#5EA7DD	ctermfg=DarkCyan    ctermbg=none        term=bold       cterm=bold
" hi Comment		                    guifg=#5EA7DD	ctermfg=DarkCyan    ctermbg=none        term=bold       cterm=bold
hi Comment		                    guifg=SteelBlue4	ctermfg=DarkCyan    ctermbg=none        term=bold       cterm=bold
hi PreProc		                    guifg=#5BBD2B	ctermfg=LightGray   ctermbg=none        term=bold       cterm=bold
" hi Constant 		                guifg=#1094a0	ctermfg=Brown       ctermbg=none		term=underline
"
" hi Special							guifg=#FF9911   guibg=grey95			ctermfg=Brown       ctermbg=Black       term=bold
hi Special							guifg=#FF9911   guibg=grey15			ctermfg=Brown       ctermbg=Black       term=bold
hi Identifier		                guifg=#3c960f	ctermfg=LightGray   ctermbg=none
hi Tag								guifg=#B0E0E6
hi Statement 	                    guifg=#009298	ctermfg=White       ctermbg=none        term=bold       cterm=bold  gui=bold
hi Type			                    guifg=#80C97F   ctermfg=LightCyan   ctermbg=none      	term=underline  gui=NONE
" hi Title 		                    guifg=#C8E2FF   ctermfg=Cyan        ctermbg=DarkBlue	term=bold	    gui=bold
" hi Question 		                guifg=#80C9FF   ctermfg=Blue        ctermbg=none        cterm=bold      term=bold   gui=bold
" hi SpecialKey 		                guifg=#677F98 	                                        term=bold
" hi SignColumn       guibg=Black     guifg=#FF9911
"
" hi SignColumn	guifg=Blue	guibg=White
hi SignColumn	guifg=Blue	guibg=Black
hi Todo			    guibg=yellow2   guifg=orangered ctermfg=Brown       ctermbg=Yellow
" hi Ignore 		                    guifg=grey20 	ctermfg=DarkGrey    ctermbg=none
" hi ModeMsg 		                    guifg=#80C9FF   ctermfg=Blue        ctermbg=none        cterm=bold      term=bold   gui=bold
" hi MoreMsg 		                    guifg=#80C9FF   ctermfg=Blue        ctermbg=none        cterm=bold      term=bold   gui=bold
" hi NonText 		    guibg=#2D3D4F   guifg=#405871   ctermfg=DarkGray    ctermbg=none        cterm=bold      term=bold   gui=bold
hi MatchParen       guibg=Yellow	guifg=Green	ctermfg=Brown       ctermbg=none        cterm=bold      term=bold   gui=bold
"
" hi Normal	ctermfg=Black	ctermbg=LightGrey	guifg=SteelBlue4		guibg=Black
hi Normal	ctermfg=Black	ctermbg=LightGrey	guifg=#5EA7DD		guibg=Black		" #5E07DD 紫色

" Groups used in the 'highlight' and 'guicursor' options default value.
hi ErrorMsg		term=standout	ctermbg=DarkRed	ctermfg=White	guibg=Red	guifg=White
hi IncSearch	term=reverse	cterm=reverse	gui=reverse
hi ModeMsg		term=bold		cterm=bold	gui=bold
hi StatusLine	term=reverse,bold	cterm=reverse,bold gui=reverse,bold
hi VertSplit	term=reverse	cterm=reverse	gui=reverse	guibg=#25345F   guifg=#526A83
" hi Visual		term=reverse	ctermbg=grey	guibg=grey80
" hi VisualNOS	term=underline,bold		cterm=underline,bold	gui=underline,bold
hi DiffText		term=reverse	cterm=bold		ctermbg=Red gui=bold	guibg=Red
hi Directory	term=bold		ctermfg=DarkBlue	guifg=Blue
"
" hi LineNr		guibg=#A095C4	guifg=White		ctermfg=White       ctermbg=DarkBlue    term=underline
"
" hi LineNr		guibg=#A095C4	guifg=Black		ctermfg=White       ctermbg=DarkBlue    term=underline
hi LineNr		guibg=Grey10	guifg=White		ctermfg=White       ctermbg=DarkBlue    term=underline
hi MoreMsg		term=bold	ctermfg=DarkGreen	gui=bold	guifg=SeaGreen
"
" hi NonText		term=bold	ctermfg=Blue	gui=bold	guifg=Blue	guibg=grey80
hi NonText 		    guibg=Grey5	guifg=#405871   ctermfg=DarkGray    ctermbg=none        cterm=bold      term=bold   gui=bold
hi Question		term=standout	ctermfg=DarkGreen		gui=bold	guifg=SeaGreen	guibg=#C0FF3E
"
" hi Search		term=reverse	ctermbg=Yellow	ctermfg=NONE	guibg=Yellow	guifg=NONE
hi SpecialKey	term=bold	ctermfg=DarkBlue	guifg=Blue
hi Title		term=bold	ctermfg=DarkMagenta		gui=bold	guifg=Magenta
hi WarningMsg	term=standout	ctermfg=DarkRed	guifg=Red
hi WildMenu		term=standout	ctermbg=Yellow	ctermfg=Black	guibg=Grey25	guifg=Yellow	" Black
"
" hi Folded		term=standout	ctermbg=Grey	ctermfg=DarkBlue		guibg=LightGrey		guifg=DarkBlue
hi Folded		term=standout	ctermbg=Grey	ctermfg=DarkBlue		guibg=Grey25	guifg=White
" hi FoldColumn	term=standout	ctermbg=Grey	ctermfg=DarkBlue	guibg=Grey	guifg=DarkBlue
hi DiffAdd		term=bold	ctermbg=LightBlue		guibg=LightBlue
hi DiffChange	term=bold	ctermbg=LightMagenta	guibg=LightMagenta
hi DiffDelete	term=bold	ctermfg=Blue	ctermbg=LightCyan	gui=bold	guifg=Blue	guibg=LightCyan
" hi Normal		    guibg=#1e1e27	guifg=#cfbfad	ctermfg=LightGray   ctermbg=none
" hi ErrorMsg		    guibg=#A50000   guifg=White     ctermfg=Red         ctermbg=none        term=bold       cterm=bold
" hi WarningMsg 		guibg=#FFCC00   guifg=White     ctermfg=Yellow      ctermbg=none        term=bold       cterm=bold
hi Search			guibg=#804000   guifg=#FF9911   ctermfg=DarkRed     ctermbg=Brown       term=bold       gui=reverse
" hi VertSplit		guibg=#25345F   guifg=#526A83   ctermfg=White       ctermbg=DarkBlue    term=none       cterm=none       gui=none
" hi LineNr			guibg=#184785	guifg=White		ctermfg=White       ctermbg=DarkBlue    term=none
" hi Directory 		guibg=#405871   guifg=#CCCCFF   ctermfg=White       ctermbg=none        term=bold
" hi WildMenu 		guibg=Black     guifg=#FF9911   ctermfg=Brown       ctermbg=Black       term=standout
" hi Folded		    guibg=#25345F   guifg=#CCCCCC   ctermfg=White       ctermbg=DarkBlue    term=standout	cterm=underline
" hi FoldColumn 		guibg=#9A32CD	guifg=#8ae234	ctermfg=White       ctermbg=DarkBlue    term=standout
"
" hi FoldColumn 		guibg=#ECECEC	guifg=#8ae234	ctermfg=White       ctermbg=DarkBlue    term=standout
hi FoldColumn 		guibg=Grey25	guifg=#8ae234	ctermfg=White       ctermbg=DarkBlue    term=standout

"
" hi Visual 		    guibg=#25345F   guifg=#647C95   ctermfg=White       ctermbg=none        term=bold       cterm=bold      gui=none
hi Visual 		    guibg=Grey25	ctermfg=White       ctermbg=none        term=bold       cterm=bold      gui=none
hi VisualNOS 		guibg=#25345F   guifg=#526A83   ctermfg=White       ctermbg=none        term=bold       cterm=bold      gui=underline

" hi DiffText		    guibg=#FF9911   guifg=White     gui=none
" hi DiffAdd 		    guibg=#FFB720   guifg=White	    gui=bold
" hi DiffChange 		guibg=#D26C00		            gui=underline
" hi DiffDelete 		guibg=#AA4400   guifg=#DDDDDD   gui=bold

hi perlSpecialMatch		guifg=#FF9911   guibg=White	ctermfg=Brown       ctermbg=Black
hi perlSpecialString	guifg=#FF9911   guibg=#FEF8C9	ctermfg=Brown       ctermbg=Black
hi perlVarPlain			guifg=DarkBlue	guibg=#E0FFFF
hi perlMatchStartEnd	guifg=Blue	guibg=#A095C4

hi txtList			guibg=grey80
hi tooltip			guibg=Red

if has("gui_running")
	set cursorline
	let do_syntax_sel_menu=1
	"
	"   hi CursorLine		term=underline	cterm=underline	guibg=#CAE5E8
	hi CursorLine		term=underline	cterm=underline	guibg=grey10
	hi CursorColumn		term=reverse	ctermbg=grey	guibg=#99D1D3
endif

" hi Pmenu guibg=#00b2bf guifg=#ffffff
" hi PmenuSel guibg=#40FF7F guifg=#9B30FF
hi PmenuSbar guibg=#00b2bf guifg=#00ff0f
hi PmenuThumb guibg=#0ff0ff guifg=#0fff00
hi Pmenu guibg=#333333
hi PmenuSel guibg=#555555 guifg=#ffffff

" Colors for syntax highlighting
" hi Constant term=underline ctermfg=DarkRed guifg=#8F006D	guibg=grey95
hi Constant term=underline ctermfg=DarkRed guifg=#ffa0a0	guibg=grey20
" hi Special	term=bold	ctermfg=DarkMagenta	guifg=SlateBlue	guibg=grey95
if &t_Co > 8
	hi Statement	term=bold	cterm=bold	ctermfg=Brown	gui=bold	guifg=Brown
endif
hi Ignore ctermfg=LightGrey	ctermbg=none	guifg=grey90

"" Statusline
hi StatuslineBufNr		cterm=none   	ctermfg=black 	ctermbg=cyan   	gui=none	guibg=#9B30FF	guifg=#ffffff
hi StatuslineLastBufferNr		cterm=none   	ctermfg=black 	ctermbg=cyan   	gui=none	guibg=LightMagenta	guifg=DarkBlue
hi StatuslineFlag		cterm=none   	ctermfg=black 	ctermbg=cyan   	gui=none	guibg=Red		guifg=#ffffff
hi StatuslinePath		cterm=none   	ctermfg=white 	ctermbg=green  	gui=none	guibg=#C82E31	guifg=Black
hi StatuslineFileName	cterm=none   	ctermfg=white 	ctermbg=blue   	gui=none	guibg=#D59B00	guifg=Black
hi StatuslineFileEnc	cterm=none   	ctermfg=white 	ctermbg=yellow 	gui=none	guibg=#DCD800	guifg=Blue
hi StatuslineFileFormat	cterm=bold   	ctermbg=white 	ctermfg=black  	gui=none	guibg=DarkGreen	guifg=LightMagenta
hi StatuslineFileBomb	cterm=bold   	ctermbg=white 	ctermfg=black  	gui=none	guibg=DarkBlue	guifg=LightRed
hi StatuslineFileType	cterm=bold   	ctermbg=white 	ctermfg=black  	gui=none	guibg=#50A625	guifg=Black
hi StatuslineTermEnc	cterm=none   	ctermbg=white 	ctermfg=yellow 	gui=none	guibg=Green		guifg=Black
hi SpellLang			cterm=none   	ctermbg=white 	ctermfg=yellow 	gui=none	guibg=#00AE72	guifg=Black
hi StatuslineFoldInfo	cterm=none   	ctermbg=white 	ctermfg=yellow 	gui=none	guibg=DarkBlue	guifg=White

hi TextMode				cterm=none   	ctermbg=white 	ctermfg=yellow 	gui=none	guibg=steelblue	guifg=White
hi StatuslineSyn		cterm=none   	ctermbg=white 	ctermfg=yellow 	gui=none	guibg=#00B2BF	guifg=Black
hi StatuslineRealSyn	cterm=none   	ctermbg=white 	ctermfg=yellow 	gui=none	guibg=Cyan		guifg=Black
hi TlistGetTagname		cterm=none   	ctermbg=white 	ctermfg=yellow 	gui=none	guibg=#E33539	guifg=White
" hi UpTime				cterm=none   	ctermbg=white 	ctermfg=yellow 	gui=none	guibg=steelblue	guifg=White
hi GetTagname			cterm=none   	ctermbg=white 	ctermfg=yellow 	gui=none	guibg=#E33539	guifg=White

hi FileTime				term=reverse	cterm=reverse	gui=none	guibg=LightYellow	guifg=LightBlue
hi StatusLine			term=reverse,bold	cterm=reverse,bold	ctermbg=white	ctermfg=yellow	gui=none	guibg=Grey10	guifg=White	" guibg=#99D1D3	guifg=Black	"#729eb0
" hi ShowUtf8Sequence		cterm=none   	ctermbg=white 	ctermfg=yellow 	gui=none	guibg=#EEEEEE   guifg=#729eb0
hi StatuslineChar		cterm=none   	ctermbg=white 	ctermfg=yellow 	gui=none	guibg=#52096C	guifg=#F9F400
hi StatuslineCapsBuddy	cterm=none		ctermfg=white	ctermbg=green	gui=none	guibg=#8ae234	guifg=Blue
hi StatuslinePosition	cterm=none		ctermfg=white	ctermbg=magenta	gui=none	guibg=#511F90	guifg=LightCyan
hi StatuslinePercent	cterm=reverse	ctermfg=white	ctermbg=red		gui=none	guibg=#8a2be2	guifg=Black
hi StatuslineTime		cterm=none   	ctermfg=black 	ctermbg=cyan   	gui=none	guibg=#FEF889	guifg=#000000
hi StatuslineSomething	cterm=reverse	ctermfg=white 	ctermbg=darkred	gui=none	guibg=#C2C2C2	guifg=Black
hi StatusLineNC			term=reverse	cterm=reverse	gui=none	guibg=#555555	guifg=#70a0a0

"" cursor
highlight Cursor	guifg=White		guibg=Green		ctermfg=White	ctermbg=Blue
highlight iCursor	guifg=White		guibg=red
if has('multi_byte_ime')
	" highlight Cursor guifg=NONE guibg=Green
	highlight CursorIM guifg=NONE guibg=Purple
endif
set guicursor=n-v-c:block-Cursor
set guicursor+=i-ci:ver15-iCursor-blinkwait700-blinkon400-blinkoff250
set guicursor+=n-v-c:blinkon0
" set guicursor+=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175,n-v-c:blinkon0,i-ci:ver30-blinkwait300-blinkon600-blinkoff300

"" Highlight All Math Operator
hi PreProc          guifg=#ff80ff                ctermfg=171
" hi Constant         guifg=#ffa0a0                ctermfg=217
hi Function	        guifg=#C777EF     gui=NONE  ctermfg=177 ctermbg=17 cterm=none
hi StdFunction      guifg=#C777EF     gui=bold  ctermfg=177 ctermbg=17 cterm=bold
hi UserLabel2	    guifg=#c96129     gui=bold  ctermfg=166 ctermbg=17 cterm=bold
hi StdName	        guifg=#5276e6     gui=bold  ctermfg=69  ctermbg=17 cterm=bold
hi MicroController  guifg=#d00000     gui=bold  ctermfg=160 ctermbg=17 cterm=bold
hi AnsiFuncPtr	    guifg=#ff0000     gui=NONE  ctermfg=196 ctermbg=17 cterm=none
hi PreCondit        guifg=#a06129     gui=NONE  ctermfg=130 ctermbg=17 cterm=none
hi Operator         guifg=Yellow      gui=NONE  ctermfg=226 ctermbg=17 cterm=none
hi OperatorBold	    guifg=Yellow      gui=bold  ctermfg=226 ctermbg=17 cterm=bold
hi BlockBraces	    guifg=Yellow      gui=bold  ctermfg=226 ctermbg=17 cterm=bold
" C math operators
" hi cParenthesesL				guifg=#5BBD2B   ctermfg=14
" hi cParenthesesR				guifg=#5BBD2B   ctermfg=14
" hi cBracketL				guifg=#FBBD2B   ctermfg=14
" hi cBracketR				guifg=#FBBD2B   ctermfg=14
" hi cBraceL					guifg=#5BFD2B   ctermfg=14
" hi cBraceR					guifg=#5BFD2B   ctermfg=14
" hi cParenthesesL				guifg=#5BBD2B   ctermfg=14
" hi cParenthesesR			guifg=#5BBD2B   ctermfg=14
hi cMathOperator            guifg=#3EFFE2   ctermfg=14
hi cPointerOperator         guifg=#3EFFE2   ctermfg=14
hi cLogicalOperator         guifg=#3EFFE2   ctermfg=14
hi cLogicalOperator         guifg=#3EFFE2   ctermfg=14
hi cBinaryOperator          guifg=#F0088C   gui=NONE		ctermfg=161  ctermbg=17
hi cBinaryOperatorError     guifg=white     guibg=#b2377a	ctermfg=231 ctermbg=169 cterm=none
" hi cBraces	                guifg=#C777EF   gui=NONE		ctermfg=177 ctermbg=17 cterm=none
hi cSemicolon				guifg=#FFA70F   ctermfg=202		ctermbg=17	cterm=none
" hi cColon					guifg=#3EFFE2   ctermfg=14
hi cThis					guifg=#00FF00   ctermfg=15
hi ccString					guifg=#5BBD2B   ctermfg=15
hi cccout					guifg=#79378B	ctermfg=16
hi ccendl					guifg=#C57CAC	ctermfg=17
hi cAsk						guifg=#FF0000	ctermfg=18
" hi cColon					guifg=#00FF00	ctermfg=14
hi TabIndent				guifg=Grey40	ctermfg=18

" Highlight Class and Function names
hi cCustomFunc	gui=bold	guifg=YellowGreen
hi cCustomClass	gui=bold	guifg=#F57CAC	guibg=SteelBlue4
hi cCustomScope	gui=bold	guifg=#00F5FF

"vim:ts=4:tw=4:foldmethod=expr
