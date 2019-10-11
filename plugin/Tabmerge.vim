" TODO vimdoc header
" ============================================================================
" Tabmerge -- Merge the windows in a tab with the current tab.
" Author: Connor de la Cruz <github.com/connordelacruz>
" 
" Based on script by Christian J. Robinson <infynity@onewest.net>: 
" http://www.vim.org/scripts/script.php?script_id=1961
"
" Usage:
"
" :Tabmerge [tab number] [top|bottom|left|right]
"
" The tab number can be "$" for the last tab. If the tab number isn't
" specified the tab to the right of the current tab is merged. If there is no
" right tab, the left tab is merged.
"
" The location specifies where in the current tab to merge the windows. If the
" location isn't provided, defaults to the value of g:tm_default_location or
" "top" if g:tm_default_location is not set
"
" Limitations:
"
" Vertical windows are merged as horizontal splits. Doing otherwise would be
" nearly impossible.
" ============================================================================

if v:version < 700
	echoerr "Tabmerge.vim requires at least Vim version 7"
	finish
endif

if !exists("g:tm_default_location")
    ""
    " Default location to merge windows when calling @command(Tabmerge)
    " without specifying the location argument
    let g:tm_default_location = 'top'
endif

""
" Merge tab [tab_number] into the current window at the specified [location]
" (top,bottom,left,right).
"
" @default tab_number=the tab to the right, or to the left if there is none to the right
" @default location=@setting(tm_default_location)
command! -nargs=* Tabmerge call Tabmerge(<f-args>)

" TODO: mapping configs

""
" Merge tab [tab_number] into the current window at the specified [location].
" Implementation for @command(Tabmerge)
" @default tab_number=the tab to the right, or to the left if there is none to the right
" @default location=@setting(tm_default_location)
function! Tabmerge(...)  " {{{1
	if a:0 > 2
		echohl ErrorMsg
		echo "Too many arguments"
		echohl None
		return
	elseif a:0 == 2
		let tabnr = a:1
		let where = a:2
	elseif a:0 == 1
		if a:1 =~ '^\d\+$' || a:1 == '$'
			let tabnr = a:1
		else
			let where = a:1
		endif
	endif

	if !exists('l:where')
		let where = g:tm_default_location
	endif

	if !exists('l:tabnr')
		if type(tabpagebuflist(tabpagenr() + 1)) == 3
			let tabnr = tabpagenr() + 1
		elseif type(tabpagebuflist(tabpagenr() - 1)) == 3
			let tabnr = tabpagenr() - 1
		else
			echohl ErrorMsg
			echo "Already only one tab"
			echohl None
			return
		endif
	endif

	if tabnr == '$'
		let tabnr = tabpagenr(tabnr)
	else
		let tabnr = tabnr
	endif

	let tabwindows = tabpagebuflist(tabnr)

	if type(tabwindows) == 0 && tabwindows == 0
		echohl ErrorMsg
		echo "No such tab number: " . tabnr
		echohl None
		return
	elseif tabnr == tabpagenr()
		echohl ErrorMsg
		echo "Can't merge with the current tab"
		echohl None
		return
	endif

	if where =~? '^t\(op\)\?$'
		let where = 'topleft'
	elseif where =~? '^b\(ot\(tom\)\?\)\?$'
		let where = 'botright'
	elseif where =~? '^l\(eft\)\?$'
		let where = 'leftabove vertical'
	elseif where =~? '^r\(ight\)\?$'
		let where = 'rightbelow vertical'
	else
		echohl ErrorMsg
		echo "Invalid location: " . a:2
		echohl None
		return
	endif

	let save_switchbuf = &switchbuf
	let &switchbuf = ''

	if where == 'top'
		let tabwindows = reverse(tabwindows)
	endif

	for buf in tabwindows
		exe where . ' sbuffer ' . buf
	endfor

	exe 'tabclose ' . tabnr

	let &switchbuf = save_switchbuf
endfunction

