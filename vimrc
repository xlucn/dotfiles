" Vundle {{{
set nocompatible              " be iMproved, required
filetype off                  " required, will turn on later

" Vundle settings
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Plugin 'w0rp/ale'
call vundle#end()            " required
filetype plugin indent on    " required
syntax on
" }}}
" Vim Config {{{
" leader key
let mapleader = ','
" reload vimrc
nnoremap <silent> <Leader>r :so $MYVIMRC<CR>
" }}}
" Markdown {{{
let g:vim_markdown_folding_style_pythonic = 1
" }}}
" Theme {{{
colorscheme Tomorrow-Night-Eighties
" }}}
" Airline {{{
let g:airline#extensions#tabline#enabled   = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#ale#enabled       = 1
let g:airline_theme                        = 'dark'
let g:airline_powerline_fonts              = 1
" }}}
" UI basic {{{
" show line number
set number

" remove toolvar in gvim
set guioptions-=T

" enable mouse support in console
set mouse=a
" }}}
" Misc {{{
" update time
set updatetime=100

" turn on wild menu on :e <Tab>
set wildmenu

" shows what you are typing as a command
set showcmd
" }}}
" Space Tabs Indentations {{{
" indentations
set autoindent
set cindent

" tabs
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

" show tabs and trailing whitespace
set list
set listchars=tab:>.,trail:.
" }}}
" Search {{{
" incremental search
set incsearch
" case-insensitive search
set ignorecase
" smart case search(only when search pattern has no capital letters)
set smartcase
" highlight search
" set hlsearch
" }}}
" Navigations {{{
" go up/down
nnoremap <silent> j gj
nnoremap <silent> k gk
" buffers
nnoremap <silent> <C-H> :bprevious<CR>
nnoremap <silent> <C-L> :bnext<CR>
nnoremap <silent> <C-K> :bdelete<CR>

" fold
nnoremap <space> za
" }}}
" Gitgutter {{{
" the previous ~_ take two columns
let g:gitgutter_sign_modified_removed   = '^'
" update signs after focus
let g:gitgutter_terminal_reports_focus  = 0
" always show sign column
set signcolumn=yes
" }}}
" ALE {{{
let g:ale_sign_column_always = 1
" }}}
" vim:foldmethod=marker:foldlevel=0
