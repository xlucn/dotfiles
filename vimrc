" Vundle {{{
set nocompatible              " be iMproved, required
filetype off                  " required, will turn on later

" Vundle settings
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
" Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'godlygeek/tabular' " this plugin must be before vim-markdown
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
" automatically write a file when leaving a buffer
set autowrite
" reload vimrc
nnoremap <silent> <Leader>r :so $MYVIMRC<CR>
" update time
set updatetime=100
" redraw when needed
set lazyredraw
" }}}
" UI basic {{{
" show line number
set number

" remove toolvar in gvim
set guioptions-=T

" enable mouse support in console
set mouse=a
set ttymouse=xterm2

" highlight current line
set cursorline

" shows what you are typing as a command
set showcmd

" turn on wild menu on :e <Tab>
set wildmenu

" show matching characters
set showmatch

" minimum lines above and below cursor
set scrolloff=3

" split into right by default
set splitright
" }}}
" Theme {{{
colorscheme Tomorrow-Night-Eighties
" }}}
" Space Tabs Indentations {{{
" indentations
set autoindent
set cindent

" tabs
set tabstop=4
set softtabstop=4
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
set hlsearch
"This unsets the *last search pattern* register by hitting return
nnoremap <silent> <leader><space> :noh<CR>
" }}}
" Navigations {{{
" go up/down
nnoremap <silent> j gj
nnoremap <silent> k gk
" buffers
nnoremap <silent> <C-H> :bprevious<CR>
nnoremap <silent> <C-L> :bnext<CR>
"   learned from here: https://stackoverflow.com/a/16505009, gorgeous!
"   prevent from closing the window when deleting a buffer
nnoremap <silent> <C-K> :bp<CR>:bd #<CR>

" toggle fold
nnoremap <space> za
" }}}
" Markdown {{{
let g:vim_markdown_folding_style_pythonic = 1
" }}}
" Airline {{{
let g:airline#extensions#tabline#enabled   = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#ale#enabled       = 1
let g:airline_theme                        = 'dark'
let g:airline_powerline_fonts              = 1
" }}}
" fugitive {{{
" key bindings
nnoremap <leader>gd :Gvdiff<CR>
nnoremap <leader>gc :Gcommit -v<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <leader>gps :Gpush<CR>
nnoremap <leader>gpl :Gpull<CR>
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
let g:ale_sign_error = '>'
let g:ale_sign_warning = '-'
" }}}
" Nerdtree {{{
nnoremap <C-N> :NERDTreeToggle<CR>
" }}}
" nerdtree git plugin {{{
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "~",
    \ "Staged"    : "+",
    \ "Untracked" : "*",
    \ "Renamed"   : ">",
    \ "Unmerged"  : "=",
    \ "Deleted"   : "x",
    \ "Dirty"     : "!",
    \ "Clean"     : "o",
    \ 'Ignored'   : '#',
    \ "Unknown"   : "?"
    \ }
" }}}
" vim:foldmethod=marker:foldlevel=0
" TODO: change mapping to <leader>[plugin specific key][motion specific key]
" TODO: change save to <leader>w
