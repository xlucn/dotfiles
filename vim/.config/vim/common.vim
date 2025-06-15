" leader key, for key mappings
let mapleader = ','
let maplocalleader = '\'
" }}}
" Vim basic config {{{
set backup " create back files
set backupdir-=. " do not create backup files in current directory
set autowrite " automatically write a file when leaving a buffer
set undofile " persistent undo between restarts
set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
set spelllang=en,cjk " spell check but exclude CJK language
set clipboard=unnamedplus " use x11 normal clipboard
set timeoutlen=500 " time out for key code delays
set diffopt+=vertical " open diff window vertically
set nrformats+=alpha " use Ctrl-A/X to in/decrease alphabets
set completeopt=menu,menuone,noselect " completion
set formatoptions+=jormB " roj for comments, mB for CJK
set ignorecase smartcase
" }}}
" UI basic {{{
set number              " show line number
set relativenumber      " show relative number
set showcmd             " shows what you are typing as a command
set title               " change the terminal's title
set showmatch           " show matching characters
set scrolloff=5         " minimum lines above and below cursor
set splitright          " split into right by default
set splitbelow          " split to below by default
set updatetime=100      " update time, related to fugitive sign column update, etc.
set signcolumn=yes      " always show sign column
set colorcolumn=80      " highlight column 80
set lazyredraw          " redraw when needed
set shortmess+=nocI     " don't show welcome screen
set showtabline=2       " show tabs on top
set noshowmode          " do not show mode on the last line
set foldcolumn=0
set foldmethod=expr
set wrap
set smoothscroll
" built-in plugins or file type supports {{{
let g:termdebug_wide=1
let g:tex_flavor = "latex"
" }}}
" Space Tabs Indentations {{{
" tabs
set tabstop=4
set shiftwidth=0  " make it the same as tabstop
set softtabstop=-1  " make it the same as shiftwidth
set expandtab       " change tab to spaces
set smarttab
" show tabs and trailing white space
set list
set listchars=tab:│\ ,trail:·
" show fold indicator as arrows
set fillchars=eob:\ ,fold:\ ,foldopen:,foldsep:│,foldclose:
" }}}
" Navigations {{{
" go up/down in one wrapped long line
nnoremap <silent> j gj
nnoremap <silent> k gk
xnoremap <silent> j gj
xnoremap <silent> k gk
nnoremap <silent> gj j
nnoremap <silent> gk k
xnoremap <silent> gj j
xnoremap <silent> gk k
" buffers
nnoremap <silent> <C-K> :bprevious<CR>
nnoremap <silent> <C-J> :bnext<CR>
nnoremap <silent> <C-P> :cprevious<CR>
nnoremap <silent> <C-N> :cnext<CR>
nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> ]l :lnext<CR>
" toggle fold
nnoremap <space> za
" center the screen when searching
" n/N: search, zz: center, zv: unfold
nnoremap n nzzzv
nnoremap N Nzzzv
" some simple key bindings
noremap <leader>q :q<CR>
noremap <leader>Q :qa<CR>
noremap <leader>d :bd<CR>
noremap <leader>w :w<CR>
noremap <leader>e :e<CR>
noremap <leader>x :x<CR>
noremap <leader>k :call ExecCurrentFile()<CR>
noremap <leader>r :so $XDG_CONFIG_HOME/vim/vimrc<CR>
noremap <leader>Z :call Goyo()<CR>
" }}}
" Autocmd {{{
augroup normal
    autocmd!
    " some file types
    autocmd BufNewFile,BufRead *.mac setlocal ft=maxima
    autocmd BufNewFile,BufRead *.plt setlocal ft=gnuplot
    autocmd BufNewFile,BufRead *.muttrc setlocal ft=muttrc
    " load Xresources on save
    autocmd BufWritePost Xresources,*Xresources call system("xrdb -load ".expand('%'))
    " tabs for these file types
    autocmd FileType tex,markdown,mma setlocal sw=2 ts=2 sts=2
    autocmd FileType c,cpp,mma,json setlocal noet
    " spell check for these file types
    autocmd FileType tex,markdown,gitcommit setlocal spell
    " comment strings for vim-commentary
    autocmd FileType gnuplot setlocal commentstring=#\ %s
    autocmd FileType maxima setlocal commentstring=/*\ %s\ */
    autocmd FileType mma setlocal commentstring=(*\ %s\ *)
    " wrap lines even in diff
    autocmd VimEnter * if &diff | execute 'windo set wrap' | endif
augroup END
augroup latex
    autocmd!
    " add normal font in math
    autocmd FileType tex xnoremap <localleader>n s\mathrm{}<Esc>P
    autocmd FileType tex nnoremap <localleader>n a\mathrm{}<Left>
    " add red color, or to existing text
    autocmd FileType tex xnoremap <localleader>m s\red{}<Esc>P
    autocmd FileType tex nnoremap <localleader>m a\red{}<Left>
    autocmd FileType tex xnoremap <localleader>b s\blue{}<Esc>P
    autocmd FileType tex xnoremap <localleader>r s\red{}<Esc>P
    " remove red color depends on vim-surround
    autocmd FileType tex nnoremap <localleader>d F{mr%x`rd12l
augroup END
" }}}
