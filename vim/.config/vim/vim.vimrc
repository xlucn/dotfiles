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
function! ConfigComm() abort
    echo "test"
endfunction
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
