if exists('g:loaded_hex_search')
  finish
endif
let g:loaded_hex_search = 1


let s:Esc = char2nr("\e")
let s:Enter = char2nr("\r")

func s:show_prompt(str)
	echohl Operator | echon '/' | echohl NONE
	echon a:str
endfunc

func s:do_search(str)
	if len(a:str) == 0
		return
	endif
	if a:str =~ "[^ \t0-9A-Fa-f]" "treat as normal search
		let x = a:str "just do normal search 
	else
		let x = join(split(a:str, '\s\+'), '\%(\s*\|\s*\p\{0,16}\n0x\x\+:\s*\)')
	endif

	let @/ = x
	return search(x) != 0
endfunc

func s:clean_up() 
	"echon '' "why this not work
	echo ''
endfunc

func s:restore_prev_highlight(prev)
	let @/ = a:prev
endfunc

func s:input()
	let prev = @/ "backup previous search register
	let str = "" "user input string

	call s:show_prompt(str)

	while 1
		let nr = getchar() "read 1 input char
		if nr == s:Esc " esc
			call s:clean_up()
			call s:restore_prev_highlight(prev)
			break
		elseif nr == s:Enter " enter
			call s:clean_up()
			break
		elseif nr is# "\<BS>" "Backspace
			let str = str[:-2] "remove last byte
		endif

		let str = str . nr2char(nr)
		call s:do_search(str)
		redraw 
		call s:show_prompt(str)
	endwhile
endfunc

"map to Control + /
if exists('g:hex_search_ctrl_slash') 
	nnoremap <silent> <expr> <C-_> <Sid>input() 
endif
" replace origin /
if exists('g:hex_search_replace_origin') 
	nnoremap <silent> <expr> / <Sid>input() 
endif


