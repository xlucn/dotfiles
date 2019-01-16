" Vundle {{{
set nocompatible              " be iMproved, required
filetype off                  " required, will turn on later

" Vundle settings
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" the Vundle plugin it self
Plugin 'VundleVim/Vundle.vim'
" Nerd plugin series
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
" Plugin 'Xuyuanp/nerdtree-git-plugin'
" markdown plugins
Plugin 'godlygeek/tabular' " this plugin must be before vim-markdown
Plugin 'plasticboy/vim-markdown'
" airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" git
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
" theme
Plugin 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
" leader guide like in spacevim
Plugin 'hecal3/vim-leader-guide'
" linter plugin
Plugin 'w0rp/ale'
"  asynchronous run tasks in parallel
Plugin 'skywind3000/asyncrun.vim'
" tag bar
Plugin 'majutsushi/tagbar'
" supertab
Plugin 'ervandew/supertab'
" vim session manager
Plugin 'tpope/vim-obsession'
" vimtex plugin
Plugin 'lervag/vimtex'
call vundle#end()            " required
filetype plugin indent on    " required
syntax on
" }}}
" Vim Config {{{
" set vim folder
let $VIM='~/.vim/'
" set encoding
set encoding=utf-8
" leader key
let mapleader = ','
" use x11 normal clipboard
set clipboard=unnamedplus
" automatically write a file when leaving a buffer
set autowrite
" reload vimrc
nnoremap <silent> <Leader>r :so $MYVIMRC<CR>
" update time
set updatetime=100
" time out for key code delays, decide how long to wait for key code
" sequence and how long leader guide (if installed) will pop up.
set timeoutlen=300
set ttimeoutlen=0
" redraw when needed
set lazyredraw
" open diff window vertically
set diffopt+=vertical
" search for tags file up to root folder
set tags=./tags;/
" }}}
" UI basic {{{
" show line number
set number

" remove toolvar in gvim
set guioptions-=T

" enable mouse support in console
set mouse=a
if !has('nvim')
    set ttymouse=xterm2
endif

" highlight current line
set cursorline

" color the 80th column
set colorcolumn=80
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
set listchars=tab:>-,trail:.
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
" This unsets the *last search pattern* register by hitting return
" Also redraw the screen. Just do the cleaning stuff at one time.
nnoremap <silent> <leader><space> :noh <bar> redraw!<CR>
" }}}
" Navigations {{{
" go up/down
nnoremap <silent> j gj
nnoremap <silent> k gk
" buffers
nnoremap <silent> <C-H> :bprevious<CR>
nnoremap <silent> <C-L> :bnext<CR>

" toggle fold
nnoremap <space> za
" }}}
" Markdown {{{
"set conceallevel=2
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2
" }}}
" Airline {{{
let g:airline#extensions#tabline#enabled   = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#ale#enabled       = 1
let g:airline_theme                        = 'dark'
let g:airline_powerline_fonts              = 1
let g:airline_highlighting_cache           = 0
" }}}
" fugitive {{{
" wrote this by my own, show the log in a pretty way
function! GitRepoLogAll()
    silent Git log --all --decorate --oneline --graph --date-order
    redraw!
endfunction
" key bindings
nnoremap <leader>gb :Git branch -a<CR>
nnoremap <leader>gd :Gvdiff<CR>
nnoremap <leader>gc :Gcommit -v<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gl :call GitRepoLogAll()<CR>
nnoremap <leader>gk :Git checkout<space>
nnoremap <leader>gu :Gpush<CR>
nnoremap <leader>gf :Gpull<CR>
nnoremap <leader>gts :Git stash<CR>
nnoremap <leader>gtp :Git stash pop<space>
nnoremap <leader>gtl :Git stash list<CR>
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
let g:ale_sign_column_always   = 1
let g:ale_sign_error           = '>'
let g:ale_sign_warning         = '-'
" only lint when leaving insert mode
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_text_changed = 'normal'

" Keymapping
nnoremap <leader>aj <Plug>(ale_next_wrap)
nnoremap <leader>ak <Plug>(ale_previous_wrap)
" }}}
" Nerdtree {{{
let NERDTreeShowBookmarks=1
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
" Vim Leader Guide {{{
let g:lmap = {}
let g:lmap.g = { 'name' : 'Git operation' }
let g:lmap.c = { 'name' : 'Comments' }
call leaderGuide#register_prefix_descriptions("<leader>", "g:lmap")
nnoremap <silent> <leader> :<c-u>LeaderGuide '<leader>'<CR>
vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<leader>'<CR>
" }}}
" Asyncrun {{{
let g:asyncrun_open = 8
" fugitive related, see official website
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
" vim-airline
let g:asyncrun_status = ''
let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])
" }}}
" Vim Tex Settings {{{
" enable vimtex fold
let g:vimtex_fold_enabled = 1
" The vim in archlinux repo is not compiled with clientserver option
let g:vimtex_compiler_latexmk = {'callback' : 1}
" matching delimiters is causing performance issues
let g:vimtex_matchparen_enabled = 0
" compiler engine
let g:vimtex_compiler_latexmk_engines = {
        \ '_'                : '-xelatex',
        \ 'pdflatex'         : '-pdf',
        \ 'dvipdfex'         : '-pdfdvi',
        \ 'lualatex'         : '-lualatex',
        \ 'xelatex'          : '-xelatex',
        \ 'context (pdftex)' : '-pdf -pdflatex=texexec',
        \ 'context (luatex)' : '-pdf -pdflatex=context',
        \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
        \}
" }}}
" vim:foldmethod=marker:foldlevel=0
