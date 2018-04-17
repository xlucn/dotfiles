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
call vundle#end()            " required
filetype plugin indent on    " required
syntax on

let g:vim_markdown_folding_style_pythonic = 1

colorscheme Tomorrow-Night-Eighties

" Airline configuration
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_theme = 'dark'
let g:airline_powerline_fonts = 1

" show line number
set number

" update time
set updatetime=100

" indentations
set autoindent
set cindent

" tabs
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

" remove toolvar in gvim
set guioptions-=T

" search
" incremental search
set incsearch
" case-insensitive search
set ignorecase
" smart case search(only when search pattern has no capital letters)
set smartcase
" highlight search
" set hlsearch

" show tabs and trailing whitespace
set list
set listchars=tab:>.,trail:.

" turn on wild menu on :e <Tab>
set wildmenu

" shows what you are typing as a command
set showcmd

" enable mouse support in console
set mouse=a

""""""""""""""""""""""""""""""""""""
" keymaps
""""""""""""""""""""""""""""""""""""
" go up/down
nnoremap <silent> j gj
nnoremap <silent> k gk
" tabs
nnoremap <silent> <C-H> :tabprevious<CR>
nnoremap <silent> <C-L> :tabnext<CR>
nnoremap <silent> <C-J> :tabnew<CR>
nnoremap <silent> <C-K> :tabclose<CR>
" buffers
nnoremap <silent> <M-H> :bprevious<CR>
nnoremap <silent> <M-L> :bnext<CR>
nnoremap <silent> <M-J> :badd<Tab>
nnoremap <silent> <M-K> :bdelete<CR>

" reload vimrc
nnoremap <silent> <M-R> :so $MYVIMRC

" fold
nnoremap <space> za
