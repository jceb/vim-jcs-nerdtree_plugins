" ============================================================================
" File:        change_tree_root.vim
" Description: plugin for NERD Tree that provides a quick way of changing the
"              root directory of the tree to the current working directory
" Maintainer:  Jan Christoph Ebersbach <jceb@e-jc.de>
" Last Change: 17 December, 2011
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
"
" ============================================================================
if exists("g:loaded_nerdtree_change_tree_root")
	finish
endif
let g:loaded_nerdtree_change_tree_root = 1

call NERDTreeAddKeyMap({
			\ 'key': 'dc',
			\ 'callback': 'NERDchDir',
			\ 'quickhelpText': 'change tree root to the CWD' })

" Change tree root to the current working directory
function! NERDchDir()
	let targetNode = g:NERDTreeFileNode.New(g:NERDTreePath.New(getcwd()))
	call targetNode.makeRoot()
	exec 'normal '.g:NERDTreeMapRefreshRoot
	call targetNode.putCursorHere(0, 0)
endfunction
