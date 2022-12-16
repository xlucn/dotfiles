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
" Vim-Packager {{{
function! s:packager_init(packager) abort
  " Package manager
  call a:packager.add('kristijanhusak/vim-packager', {'type': 'opt'})
  " Basic
  call a:packager.add('tpope/vim-commentary')
  call a:packager.add('tpope/vim-endwise')
  call a:packager.add('tpope/vim-repeat')
  call a:packager.add('tpope/vim-sensible')
  call a:packager.add('tpope/vim-surround')
  call a:packager.add('tpope/vim-dispatch')
  call a:packager.add('ap/vim-buftabline')
  " Enhancements
  call a:packager.add('majutsushi/tagbar')
  call a:packager.add('jpalardy/vim-slime')
  call a:packager.add('airblade/vim-gitgutter')
  call a:packager.add('liuchengxu/vim-which-key')
  " vim language server
  call a:packager.add('prabirshrestha/vim-lsp')
  call a:packager.add('mattn/vim-lsp-settings')
  call a:packager.add('prabirshrestha/async.vim')
  call a:packager.add('prabirshrestha/asyncomplete.vim')
  call a:packager.add('prabirshrestha/asyncomplete-lsp.vim')
  call a:packager.add('natebosch/vim-lsc', {'type': 'opt'})
  " Snippets
  call a:packager.add('honza/vim-snippets')
  call a:packager.add('rafamadriz/friendly-snippets')
endfunction
packadd vim-packager
if exists("*packager#setup")
    call packager#setup(function('s:packager_init'))
endif
" }}}
" Vim Settings
set mouse=a             " enable mouse support in console
" mouse support for urxvt and st
if $TERM =~ "rxvt-unicode"
    set ttymouse=urxvt
elseif $TERM =~ "st*"
    set ttymouse=sgr
endif
" Plugin settings
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
