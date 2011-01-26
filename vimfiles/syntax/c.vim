" 下面有另一种解决方案
" " highlight Functions
" syn match cFuntions display "[a-zA-Z_]\{-1,}\s\{-0,}(\{1}"ms=s,me=e-1
" hi def link cFuntions WildMenu		" Title

" C math operators
" syn match       cParenthesisL			display "[\(]"
" syn match       cParenthesisR			display "[\)]"
" syn match		cBracketL				display "[\[]"
" syn match		cBracketR				display "[\]]"
" syn match		cBraceL					display "[\{]"
" syn match		cBraceR					display "[\}]"
" syn match       cParenthesesL			display "[\[\(\{]"
" syn match       cParenthesesR			display "[\]\)\}]"
syn match       cMathOperator			display "[-+\*\%=]"
syn match       cPointerOperator		display "->\|\."
syn match       cLogicalOperator		display "[!<>]=\="
syn match       cLogicalOperator		display "=="
syn match       cBinaryOperator			display "\(&\||\|\^\|<<\|>>\)=\="
syn match       cBinaryOperator			display "\~"
syn match       cBinaryOperatorError	display "\~="
syn match       cLogicalOperator		display "&&\|||"
syn match       cLogicalOperatorError	display "\(&&\|||\)="
syn match       cSemicolon				display ";"
syn match       cThis					display "this"
syn match       ccString				display "string"
syn match       cccout					display "cout"
syn match       ccendl					display "endl"
syn match       cAsk					display "?"
" syn match       cColon					display ":"
syn match       TabIndent				display "\t"

" Highlight Class and Function names
syn match    cCustomParen    "(" contains=cParen contains=cCppParen
syn match    cCustomFunc     "\w\+\s*(" contains=cCustomParen
syn match    cCustomScope    "::"
syn match    cCustomClass    "\w\+\s*::" contains=cCustomScope
syn match    cCustomClassName		/class/
syn match    cCustomClassDef    "\w+\s+\w\+" contains=cCustomClassName
" hi def link cCustomClassDef Function
" hi def link cCustomFunc  Function
" hi def link cCustomClass Function

" syntax region cWhile matchgroup=cWhile start=/while\s*(/ end=/)/ contains=cCondNest
" syntax region cFor matchgroup=cFor start=/for\s*(/ end=/)/ contains=cCondNest
" syntax region cCondNest start=/(/ end=/)/ contained transparent

" Qt
syn keyword cppStatement SLOT,SIGNAL
syn keyword cppAccess slots,signals
