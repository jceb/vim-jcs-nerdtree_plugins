" ============================================================================
" File:        grep.vim
" Description: plugin for NERD Tree that integrates vim's grep command.
"              Inspired by http://www.vim.org/scripts/script.php?script_id=3878
" Maintainer:  Jan Christoph Ebersbach <jceb@e-jc.de>
" Last Change: 14 January, 2012
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
"
" ============================================================================
if exists("g:loaded_nerdtree_grep")
	finish
endif
let g:loaded_nerdtree_grep = 1

call NERDTreeAddMenuItem({
			\ 'text': '(g)rep',
			\ 'shortcut': 'g',
			\ 'callback': 'NERDTreeGrep',
            \ 'isActiveCallback': 'NERDTreeGrepIsDirectory' })

function! NERDTreeGrepIsDirectory()
    let node = g:NERDTreeFileNode.GetSelected()
    return node.path.isDirectory
endfunction

" Change tree root to the current working directory
function! NERDTreeGrep()
	" get directory
	let slash = !exists("+shellslash") || &shellslash ? '/' : '\'
    let filepattern = input("Enter file pattern: ", '**'.slash.'*', 'file')
    if filepattern == ''
        echo 'Maybe another time...'
        return
    endif

    " get the pattern
    let pattern = input("Enter search pattern: ")
    if pattern == ''
        echo 'Maybe another time...'
        return
    endif

    exec "vimgrep /".pattern."/j ".fnameescape(g:NERDTreeFileNode.GetSelected().path.str()).filepattern
    if ! empty(getqflist())
		copen
	endif
endfunction
