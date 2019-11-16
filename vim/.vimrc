" Plugin Manager {{{
" Vim-Plug {{{
" automatic installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" begin vim-plug
call plug#begin('~/.vim/bundle')
Plug 'VundleVim/Vundle.vim'           " the Vundle plugin it self
Plug 'ctrlpvim/ctrlp.vim'             " CtrlP, fuzy search everything
Plug 'scrooloose/nerdcommenter'       " commenting code
Plug 'scrooloose/nerdtree'            " tree file browser
Plug 'godlygeek/tabular'              " this plugin must be before vim-markdown
Plug 'plasticboy/vim-markdown'        " markdown plugins
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'maximbaz/lightline-ale'
Plug 'tpope/vim-fugitive'             " git status and commands
Plug 'airblade/vim-gitgutter'         " sign column indicator
Plug 'tpope/vim-surround'             " surround parentheses change
Plug 'liuchengxu/vim-which-key'       " leader guide like in spacevim
Plug 'w0rp/ale'                       " linter plugin
Plug 'majutsushi/tagbar'              " tag bar
Plug 'ervandew/supertab'              " supertab
Plug 'lervag/vimtex'                  " vimtex plugin
Plug 'VoldikSS/vim-mma'               " mathematica
Plug 'lilydjwg/fcitx.vim'             " fcitx
Plug 'jpalardy/vim-slime'             " vim-slime
Plug 'tpope/vim-commentary'
Plug 'neomutt/neomutt.vim'
Plug 'dylanaraps/wal.vim'
call plug#end()
" }}}
" }}}
" Vim Settings {{{
" Vim Config {{{
" be iMproved
set nocompatible
" leader key
let mapleader = ','
let maplocalleader = '\'
" syntax
syntax on
" filetype
filetype on
filetype plugin on
filetype indent on
" auto reload files
set autoread
" set vim folder
let $VIM='~/.vim/'
" set encoding
set encoding=utf-8
set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
" use x11 normal clipboard
set clipboard=unnamedplus
" automatically write a file when leaving a buffer
set autowrite
set hidden
set laststatus=2
" time out for key code delays, decide how long to wait for key code
" sequence and how long leader guide (if installed) will pop up.
set timeoutlen=300
" do not wait after escape key
set ttimeoutlen=0
" open diff window vertically
set diffopt+=vertical
" }}}
" UI basic {{{
" clear sign column highlight
highlight clear SignColumn
" gui options
set guioptions=ci
set guifont=Hack\ 12
" show line number
set number
" enable mouse support in console
set mouse=a
set ttymouse=urxvt
" shows what you are typing as a command
set showcmd
" turn on wild menu on :e <Tab>
set wildmenu
" change the terminal's title
set title
" show matching characters
set showmatch
" minimum lines above and below cursor
set scrolloff=2
" split into right by default
set splitright
" update time, related to fugitive sign column update, etc.
set updatetime=100
" redraw when needed
set lazyredraw
" don't beep
set noerrorbells
" don't show welcome scren
set shortmess+=I
set showtabline=2
set noshowmode
" show partial line
set display+=lastline
" color scheme
colorscheme wal
set background=dark
" }}}
" Space Tabs Indentations {{{
" indentations
set autoindent
set smartindent
set cindent
" tabs
set tabstop=4
set shiftwidth=0  " make it the same as tabstop
set softtabstop=-1  " make it the same as shiftwidth
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
" Autocmd {{{
autocmd BufNewFile,BufRead *.plt setfiletype gnuplot
autocmd BufNewFile,BufRead *.wl setfiletype mma
autocmd BufNewFile,BufRead *.wls setfiletype mma
autocmd BufNewFile,BufRead muttrc,*muttrc setfiletype neomuttrc
autocmd BufWritePost *Xresources :!xrdb %
autocmd FileType tex setlocal sw=2 ts=2 sts=2
" }}}
" }}}
" Plugin Settings {{{
" Vim Which Key {{{
let g:which_key_use_floating_win = 0
let g:which_key_map = {
  \ 'c' : { 'name' : '+commenting' },
  \ 'q' : [ ':q', 'quit'],
  \ 'Q' : [ ':qa', 'quit all'],
  \ 'w' : [ ':w',  'save'],
  \ 'e' : [ ':e',  'edit (reload)'],
  \ 'x' : [ ':x',  'save and quit'],
  \ '.' : [ ':let @/=""', 'clear search hl'],
  \ 'r' : [ ':so $MYVIMRC', 'reload vimrc'],
  \ }
let g:which_key_map_local = {
  \ 'l' : { 'name' : '+vimtex' }
  \ }
nnoremap <silent> <leader> :WhichKey '<leader>'<CR>
vnoremap <silent> <leader> :WhichKeyVisual '<leader>'<CR>
nnoremap <silent> <localleader> :WhichKey '<localleader>'<CR>
vnoremap <silent> <localleader> :WhichKeyVisual '<localleader>'<CR>
call which_key#register(mapleader, "g:which_key_map")
call which_key#register(maplocalleader, "g:which_key_map_local")
" }}}
" Markdown {{{
"set conceallevel=2
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2
" }}}
" Lightline {{{
let g:lightline = {
    \ 'colorscheme': 'base256',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly' ],
    \             [ 'filename', 'modified' ] ],
    \   'right': [ [ 'linter_checking',
    \               'linter_errors',
    \               'linter_warnings',
    \               'linter_ok' ],
    \              [ 'percent', 'lineinfo', 'syntastic' ],
    \              [ 'fileformat', 'fileencoding', 'filetype' ] ],
    \ },
    \ 'tabline': {
    \   'left': [['buffers']],
    \   'right' : [[]]
    \ },
    \ 'component': {
    \   'filename': '%<%{expand("%:t")}'
    \ },
    \ 'component_expand': {
    \   'buffers': 'lightline#bufferline#buffers',
    \   'linter_checking': 'lightline#ale#checking',
    \   'linter_warnings': 'lightline#ale#warnings',
    \   'linter_errors': 'lightline#ale#errors',
    \   'linter_ok': 'lightline#ale#ok',
    \ },
    \ 'component_type': {
    \   'buffers': 'tabsel',
    \   'linter_checking': 'left',
    \   'linter_warnings': 'warning',
    \   'linter_errors': 'error',
    \   'linter_ok': 'left',
    \ },
    \ 'component_function': {
    \   'gitbranch': 'fugitive#head'
    \ },
    \ }
" }}}
" Fugitive {{{
" wrote this by my own, show the log in a pretty way
function! GitRepoLogAll()
    silent Git log --all --decorate --oneline --graph --date-order
    redraw!
endfunction
" key bindings
let g:which_key_map.g = {
  \ 'name' : '+git-operation',
  \ 'b' : [ '!git branch -a', 'git show branch' ],
  \ 'd' : [ ':Gvdiff', 'git diff' ],
  \ 'c' : [ ':Gcommit -v', 'git commit' ],
  \ 's' : [ ':Gstatus', 'git status' ],
  \ 'l' : [ ':call GitRepoLogAll()', 'git show log' ],
  \ 'u' : [ ':Gpush', 'git push' ],
  \ 'f' : [ ':Gpull', 'git pull' ],
  \ 't' : {
    \ 'name' : '+stash',
    \ 's' : [ ':Git stash', 'git stash' ],
    \ 'p' : [ ':Git stash pop', 'git stash pop' ],
    \ 'l' : [ ':Git stash list', 'git stash list' ]
    \ }
  \ }
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
"let g:ale_completion_enabled = 1
let g:ale_sign_column_always   = 1
let g:ale_sign_error           = '>'
let g:ale_sign_warning         = '-'
let g:ale_set_balloons         = 1
" only lint when leaving insert mode
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_text_changed = 'normal'

let g:ale_linters = {
  \ 'c': ['clangd', 'clang'],
  \ 'python': ['pyls'],
  \ 'sh': ['language-server', 'shellcheck'],
  \ 'lua': ['luacheck']
  \ }

" Keymapping
let g:which_key_map.a = {
  \ 'name' : '+ale',
  \ 'n' : [ '<Plug>(ale_next_wrap)' , 'go to next ale mark' ],
  \ 'p' : [ '<Plug>(ale_previous_wrap)' , 'go to previous ale mark' ],
  \ 'j' : [ '<Plug>(ale_next_wrap)' , 'go to next ale mark' ],
  \ 'k' : [ '<Plug>(ale_previous_wrap)' , 'go to previous ale mark' ],
  \ 'h' : [ '<Plug>(ale_hover)' , 'show hover info' ],
  \ }
" }}}
" Nerdtree {{{
let NERDTreeShowBookmarks=1
let NERDTreeShowHidden=1
nnoremap <C-N> :NERDTreeToggle<CR>
" }}}
" Nerd commenter{{{
let g:NERDDefaultAlign = 'left'
let g:NERDSpaceDelims = 1
let g:NERDRemoveExtraSpaces = 1
" }}}
" Vim Tex {{{
" enable vimtex fold
let g:vimtex_fold_enabled = 1
" start vim with a server, see ':h vimtex-clientserver'
if empty(v:servername) && exists('*remote_startserver') && !empty($DISPLAY)
  call remote_startserver('VIM')
endif
" viewer setting
let g:vimtex_view_method = 'zathura'
" matching delimiters is causing performance issues
let g:vimtex_matchparen_enabled = 0
" compiler
let g:vimtex_compiler_method = "latexmk"
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
" Mathematica {{{
let g:mma_candy = 2
" }}}
" ibus-vim {{{
let g:ibus#layout = "xkb:us::eng"
let g:ibus#engine = "libpinyin"
" }}}
" fcitx {{{
" }}}
" vim-slime {{{
if $TERM == "screen-256color"
    let g:slime_target = "tmux"
endif
" set config to use the pane on the right by default
let g:slime_default_config = {
    \ "socket_name": "fbterm",
    \ "target_pane": "{right-of}"
    \ }
" vim terminal config
let g:slime_vimterminal_config = {
    \ "vertical": 1
    \ }
let g:slime_dont_ask_default = 1
" use temp file
let g:slime_paste_file = tempname()
" ipython specific setting
let g:slime_python_ipython = 1
" }}}
" super tab {{{
let g:SuperTabDefaultCompletionType = "context"
" }}}
" }}}
" vim:foldmethod=marker:foldlevel=1
