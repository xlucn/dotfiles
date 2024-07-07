" be Vi IMproved, put this line at TOP of vimrc
set nocompatible
" XDG Base Directories
set runtimepath^=$XDG_CONFIG_HOME/vim
set packpath^=$XDG_DATA_HOME/vim
set directory=$XDG_CACHE_HOME/vim/swap
set viminfo+=n$XDG_CACHE_HOME/vim/viminfo
" vim only settings
set autoindent
set autoread " auto reload files
set encoding=utf-8
set hidden
set incsearch hlsearch
" UI
set background=dark     " color scheme
set belloff=all         " don't beep
set display+=lastline   " show partial line
set laststatus=2        " show status line
set ttimeoutlen=50      " do not wait too long after escape key
set wildmenu            " turn on wild menu on :e <Tab>
" vim-jetpack {{{
packadd vim-jetpack
call jetpack#begin()
call jetpack#add('tani/vim-jetpack', {'opt': 1}) "bootstrap
" Basic
call jetpack#add('tpope/vim-commentary')
call jetpack#add('tpope/vim-endwise')
call jetpack#add('tpope/vim-repeat')
call jetpack#add('tpope/vim-sensible')
call jetpack#add('tpope/vim-surround')
call jetpack#add('tpope/vim-dispatch')
call jetpack#add('tpope/vim-fugitive')
call jetpack#add('ap/vim-buftabline')
" Enhancements
call jetpack#add('majutsushi/tagbar')
call jetpack#add('jpalardy/vim-slime')
call jetpack#add('airblade/vim-gitgutter')
call jetpack#add('liuchengxu/vim-which-key')
" vim language server
call jetpack#add('prabirshrestha/vim-lsp')
call jetpack#add('mattn/vim-lsp-settings')
call jetpack#add('prabirshrestha/async.vim')
call jetpack#add('prabirshrestha/asyncomplete.vim')
call jetpack#add('prabirshrestha/asyncomplete-lsp.vim')
" Snippets
call jetpack#add('honza/vim-snippets')
call jetpack#add('rafamadriz/friendly-snippets')
call jetpack#end()
" }}}
" Vim Settings
set mouse=a             " enable mouse support in console
" mouse support for urxvt and st
if $TERM =~ "rxvt-unicode"
    set ttymouse=urxvt
elseif $TERM =~ "st*"
    set ttymouse=sgr
endif
augroup vim
    autocmd!
    " make sure the cursor reset to block shape, see the cursor shape settings
    autocmd VimEnter * normal! :startinsert :stopinsert
augroup END
" Plugin settings
" Netrw {{{
" Make Netrw function like NerdTree
let g:netrw_banner       = 0    " disable banner (help message, etc. at top)
let g:netrw_browse_split = 4    " open file in previous (CTRL-W_p) window
let g:netrw_winsize      = -20  " split size, minus meaning absolute size
let g:netrw_dirhistmax   = 0    " disable history
let g:netrw_liststyle    = 0    " one file per line with nothing else
nnoremap L :silent Lexplore<CR>
augroup NetrwKeys
    autocmd!
    autocmd Filetype netrw nmap <buffer> h <Plug>NetrwBrowseUpDir
    autocmd Filetype netrw nmap <buffer> l <Plug>NetrwLocalBrowseCheck
augroup END
" }}}
" statusline {{{
" update status on LSP status changes
augroup UpdateStatus
  autocmd!
  autocmd User lsp_diagnostics_updated redrawstatus
augroup END
function! LSPStatus()
    if exists('*lsp#get_buffer_diagnostics_counts')
        let l:counts = lsp#get_buffer_diagnostics_counts()
        let l:lsp_status  = l:counts.error == 0 ? '' : printf('E:%2d ', l:counts.error)
        let l:lsp_status .= l:counts.warning == 0 ? '' : printf('W:%2d ', l:counts.warning)
        let l:lsp_status .= l:counts.information == 0 ? '' : printf('I:%2d ', l:counts.information)
        let l:lsp_status .= l:counts.hint == 0 ? '' : printf('H:%2d ', l:counts.hint)
        let l:lsp_status .= l:lsp_status == '' ? 'OK ' : ''
        return ' ' . l:lsp_status
    else
        return ""
    endif
endfunction
function GitBranch()
    let cmd = 'git -C '.expand("%:h:S").' branch --show-current 2>/dev/null'
    silent return trim(system(cmd))
endfunction
" statusline
let s:modestr = {
    \   'c': 'COMMAND',
    \   'i': 'INSERT',
    \   'n': 'NORMAL',
    \   'R': 'REPLACE',
    \   's': 'SELECT',
    \   't': 'TERMINAL',
    \   'v': 'VISUAL',
    \   'V': 'V-LINE',
    \   '': 'S-BLOCK',
    \   '': 'V-BLOCK',
    \ }
function GetModeStr()
    let mode = mode()
    return get(s:modestr, mode, mode)
endfunction
" NOTE: %{} will be evaluated upon update
" NOTE: keep the spaces in the %(%) group
hi User1 ctermbg=0
hi User2 ctermbg=8
hi User3 ctermfg=0 ctermbg=6
function TagbarToggle(wid, n, bn, mod)
    if a:bn == 'l'
        Tagbar
    endif
endfunction
function TagbarIcon()
    if tagbar#IsOpen() == 1
        return ' >> '
    else
        return ' << '
    endif
endfunction
let stl1 = ' %{GetModeStr()} '                    " vim modes
let stl2 = '%(%( %{GitBranch()}%)%( %r%h%) %)'    " git branch, readonly, help
let stl3 = '%< %t %m %w '                         " file name, modified, preview
let stl4 = '%{&ff} %(| %{&fenc} %)%(| %{&ft} %)'  " format, encoding and type
let stl5 = ' %p%% | %l:%v '                       " cursor location
let stl6 = '%{LSPStatus()}'                     " lsp status
let &stl = '%3*'.stl1.'%2*'.stl2.'%1*'.stl3.'%='.stl4.'%2*'.stl5.'%3*'.stl6.'%*'
nnoremap <leader>b :TagbarToggle<CR>
" }}}
" buftabline {{{
let g:buftabline_numbers = 2
let g:buftabline_indicators = 1
" }}}
" tagbar {{{
let g:tagbar_compact = 1
let g:tagbar_indent = 1
let g:tagbar_left = 1
let g:tagbar_silent = 1
let g:tagbar_sort = 0
let g:tagbar_width = min([30, winwidth(0) / 3])
" }}}
" Git {{{
function! GitTig()
    silent !tig -C "$(dirname "$(realpath "%")")" --all
    redraw!
endfunction
nnoremap <leader>gg :call GitTig()<CR>
" }}}
" Markdown preview{{{
function MarkdownPreviewToggle()
    if !exists('b:mdp_job')
        if has('nvim')
            let b:mdp_job = jobstart(['grip', '-b', expand("%:p")])
        else
            let b:mdp_job = job_start(['grip', '-b', expand("%:p")])
        endif
    else
        if has('nvim')
            call jobstop(b:mdp_job)
        else
            call job_stop(b:mdp_job)
        endif
        unlet b:mdp_job
    endif
endfunction
" }}}
" Vim Which Key {{{
let g:which_key_group_dicts = ''
let g:which_key_centered = 1
let g:which_key_hspace = 2
let g:which_key_use_floating_win = 1        " so won't change current window
let g:which_key_fallback_to_native_key = 1
let g:which_key_disable_default_offset = 1  " fill the width
let g:which_key_map = {
  \ 'k' : 'run current file',
  \ 'z' : 'Goyo mode',
  \ 's' : 'slime',
  \ 'c' : 'comment',
  \ 'l' : 'lsp',
  \ 'g' : {
    \ 'name' : '+git-operation',
    \ 't' : { 'name' : '+stash' },
    \ },
  \ }
let g:which_key_map_local = {
  \ 'l' : { 'name' : '+vimtex' },
  \ }
function WhichKeyRegister()
    if exists("*which_key#register")
        call which_key#register(',', 'g:which_key_map')
        call which_key#register('\', 'g:which_key_map_local')
    endif
    if exists(":WhichKey")
        nnoremap <silent> <leader> :WhichKey '<leader>'<CR>
        vnoremap <silent> <leader> :WhichKeyVisual '<leader>'<CR>
        nnoremap <silent> <localleader> :WhichKey '<localleader>'<CR>
        vnoremap <silent> <localleader> :WhichKeyVisual '<localleader>'<CR>
    endif
endfunction
autocmd VimEnter * call WhichKeyRegister()
" }}}
" slime {{{
xmap <leader>s <Plug>SlimeSend
nmap <leader>s <Plug>SlimeSend
" }}}
" vim-lsp {{{
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> <C-]> <plug>(lsp-definition)
    nmap <buffer> <leader>ls <plug>(lsp-document-symbol-search)
    nmap <buffer> <leader>lS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> <leader>lr <plug>(lsp-references)
    nmap <buffer> <leader>li <plug>(lsp-implementation)
    nmap <buffer> <leader>lt <plug>(lsp-type-definition)
    nmap <buffer> <leader>lR <plug>(lsp-rename)
    nmap <buffer> [d <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]d <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> <leader>lb <plug>(lsp-document-build)
    nmap <buffer> <leader>lf <plug>(lsp-document-forwardsearch)
endfunction
let g:lsp_diagnostics_signs_delay = 200
let g:lsp_diagnostics_echo_delay = 200
let g:lsp_diagnostics_highlights_delay = 200
let g:lsp_diagnostics_echo_cursor = 1
augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
" }}}
" Gitgutter {{{
hi GitGUtterAdd    ctermbg=none ctermfg=2
hi GitGUtterChange ctermbg=none ctermfg=3
hi GitGUtterDelete ctermbg=none ctermfg=1
" the previous ~_ take two columns
let g:gitgutter_sign_modified_removed   = '^'
" update signs after focus
let g:gitgutter_terminal_reports_focus  = 0
let g:gitgutter_max_signs = 1000
" }}}
" vim-lsc {{{
let g:lsc_auto_completeopt = 'popup,noinsert,menu,noselect'
let g:lsc_server_commands = {
  \     'python': {
  \         'command': 'pylsp',
  \         'log_level': -1,
  \         'workspace_config': {
  \             'pylsp.configurationSources': ['pycodestyle'],
  \             'pylsp.plugins.yapf.enabled': v:false,
  \         }
  \     },
  \     'sh': 'bash-language-server start',
  \     'vim': 'vim-language-server --stdio',
  \     'json': 'vscode-json-languageserver --stdio',
  \     'lua': 'lua-language-server',
  \     'tex': {
  \         'command': 'texlab',
  \         'workspace_config': {
  \             "latex.build.args": ["-xelatex", "-synctex=1", "%f"],
  \         }
  \     }
  \ }
" }}}
" asyncomplete {{{
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1
" }}}
" commentary {{{
nnoremap <leader>c <Plug>CommentaryLine
onoremap <leader>c <Plug>Commentary
xnoremap <leader>c <Plug>Commentary
" }}}
" vim-slime {{{
let g:slime_no_mappings = 1
" set config to use the pane on the right by default
let g:slime_default_config = {
    \ "socket_name": get(split($TMUX, ","), 0),
    \ "target_pane": "{right-of}"
    \ }
" vim terminal config
let g:slime_vimterminal_config = {
    \ "vertical": 1
    \ }
let g:slime_dont_ask_default = 0
" use temp file
let g:slime_paste_file = tempname()
" ipython specific setting
let g:slime_python_ipython = 0
" targets
if len($TMUX) != 0
    let g:slime_target = "tmux"
    let g:slime_dont_ask_default = 1
elseif match($TERM, "screen") != -1
    let g:slime_target = "screen"
else
    let g:slime_target = "vimterminal"
endif
" }}}
