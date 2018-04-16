set nocompatible              " be iMproved, required
filetype off                  " required, will turn on later
" Vundle settings
" set the runtime path to include Vundle and initialize
""set rtp+=~/.vim/bundle/Vundle.vim
""call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
""Plugin 'VundleVim/Vundle.vim'

" vim-markdown
""Plugin 'godlygeek/tabular'
""Plugin 'plasticboy/vim-markdown'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
""call vundle#end()            " required
filetype plugin indent on    " required
syntax on

""let g:vim_markdown_folding_style_pythonic = 1

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" show line number
set number

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
" tabs
nnoremap <silent> <C-H> :tabprevious<CR>
nnoremap <silent> <C-L> :tabnext<CR>
nnoremap <silent> <C-J> :tabnew<CR>
nnoremap <silent> <C-K> :tabclose<CR>

" fold
nnoremap <space> za
