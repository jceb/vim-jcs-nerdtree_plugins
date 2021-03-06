" ============================================================================
" File:        change_fp.vim
" Description: plugin for NERD Tree that provides an interface for changing
"              file permissions and owner/group ownership
" Maintainer:  Jan Christoph Ebersbach <jceb@e-jc.de>
" Last Change: 14 January, 2012
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
"
" ============================================================================
if exists("g:loaded_nerdtree_change_mode")
    finish
endif
let g:loaded_nerdtree_change_mode = 1

let s:chown = system('which chown')
let s:chmod = system('which chmod')
let s:stat = system('which stat')

if s:chown == '' || s:chmod == '' || s:stat == ''
	echoe 'Error, unable to find commands chmod, chown and stat.'
	finish
endif

call NERDTreeAddMenuItem({
            \ 'text': '(w)chown',
            \ 'shortcut': 'w',
            \ 'callback': 'NERDTreeChown' })

call NERDTreeAddMenuItem({
            \ 'text': '(o)chmod',
            \ 'shortcut': 'o',
            \ 'callback': 'NERDTreeChmod' })

call NERDTreeAddMenuItem({
            \ 'text': '(x)chmod a+x',
            \ 'shortcut': 'x',
            \ 'callback': 'NERDTreeMakeExecutable',
            \ 'isActiveCallback': 'NERDTreeFileNotExecutable' })

call NERDTreeAddMenuItem({
            \ 'text': '(x)chmod a-x',
            \ 'shortcut': 'x',
            \ 'callback': 'NERDTreeMakeNonExecutable',
            \ 'isActiveCallback': 'NERDTreeFileExecutable' })

function! s:Chown(node, owner, group, recursive)
	let l:owner = a:owner
	let l:group = a:owner
	let l:recursive = ''
	let l:changed = 0

	if l:owner == ''
		let l:owner_cur = substitute(system('stat -c %U '.a:node.path.str({'escape': 1})), '\n*$', '', '')
		let l:res = input('Owner ('.l:owner_cur.'): ')
		if tolower(l:res) == ''
			let l:owner = l:owner_cur
		else
			let l:owner = fnameescape(l:res)
			let l:changed = 1
		endif
	endif

	if l:group == ''
		let l:group_cur = substitute(system('stat -c %G '.a:node.path.str({'escape': 1})), '\n*$', '', '')
		let l:res = input('Group ('.l:group_cur.'): ')
		if tolower(l:res) == ''
			let l:group = l:group_cur
		else
			let l:group = fnameescape(l:res)
			let l:changed = 1
		endif
	endif

    if a:node.path.isDirectory && a:recursive == -1
    	let l:res = input('Recursive [yN]: ')
    	if tolower(l:res) == 'y'
			let l:recursive = '-R'
		endif
	elseif l:changed == 0
		echom 'Nothing changed.'
		return
	endif

	exec ':!chown '.l:recursive.' '.l:owner.':'.l:group.' '.a:node.path.str({'escape': 1})
endfunction

function! s:Chmod(node, mode, recursive)
	let l:mode = a:mode
	let l:recursive = ''
	let l:changed = 0

	if l:mode == ''
		let l:mode_cur = substitute(system('stat -c %a '.a:node.path.str({'escape': 1})), '\n*$', '', '')
		let l:res = input('Mode ('.l:mode_cur.'): ')
		if tolower(l:res) == ''
			let l:mode = l:mode_cur
		else
			let l:mode = l:res
			let l:changed = 1
		endif
	endif

    if a:node.path.isDirectory && a:recursive == -1
    	let l:res = input('Recursive [yN]: ')
    	if tolower(l:res) == 'y'
			let l:recursive = '-R'
		endif
	elseif l:changed == 0
		echom 'Nothing changed.'
		return
	endif

	exec ':!chmod '.l:recursive.' '.l:mode.' '.a:node.path.str({'escape': 1})
	exec 'normal '.g:NERDTreeMapRefreshRoot
endfunction

function! NERDTreeFileExecutable()
    let node = g:NERDTreeFileNode.GetSelected()
    return node.path.isExecutable
endfunction

function! NERDTreeFileNotExecutable()
    let node = g:NERDTreeFileNode.GetSelected()
    return ! node.path.isExecutable
endfunction

function! NERDTreeChown()
    let node = g:NERDTreeFileNode.GetSelected()
    call s:Chown(node, '', '', -1)
endfunction

function! NERDTreeChmod()
    let node = g:NERDTreeFileNode.GetSelected()
    call s:Chmod(node, '', -1)
endfunction

function! NERDTreeMakeExecutable()
    let node = g:NERDTreeFileNode.GetSelected()
    call s:Chmod(node, 'a+x', -1)
endfunction

function! NERDTreeMakeNonExecutable()
    let node = g:NERDTreeFileNode.GetSelected()
    call s:Chmod(node, 'a-x', -1)
endfunction
