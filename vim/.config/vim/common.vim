" leader key, for key mappings
let mapleader = ','
let maplocalleader = '\'
set backupdir=$XDG_CACHE_HOME/vim/backup
" }}}
" Vim basic config {{{
" detect filetype and apply syntax highlighting
syntax on
filetype on
filetype plugin on
filetype indent on
set backup " create back files
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
set guioptions=di       " gui options: dark, icon
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
set wrap
set smoothscroll
set conceallevel=2      " replace concealable texts
" cursor shape for terminal emulators or linux console
if has("gui_running") == 0
    if $TERM != "linux"
        let &t_SI = "\e[6 q"  " sent when entering insert mode
        let &t_SR = "\e[4 q"  " sent when entering replace mode
        let &t_EI = "\e[2 q"  " sent when leaving insert or replace mode
    else  " for Linux tty
        let &t_ve = "\e[?25h"
        let &t_vi = "\e[?25l"
        let &t_SI = "\e[?0c"
        let &t_SR = "\e[?4c"
        let &t_EI = "\e[?8c"
    endif
endif
" color scheme
hi Normal       ctermbg=None ctermfg=15   cterm=None
hi NormalFloat  ctermbg=0
hi SignColumn   ctermbg=None              cterm=None
hi CursorColumn ctermbg=0
hi CursorLine   ctermbg=0                 cterm=None
hi ColorColumn  ctermbg=0                 cterm=None
hi LineNr       ctermbg=None ctermfg=8
hi Folded       ctermbg=None ctermfg=8
hi FoldColumn   ctermbg=None ctermfg=7
hi NonText      ctermbg=None ctermfg=8
hi SpellBad     ctermbg=None ctermfg=None cterm=undercurl
hi SpellCap     ctermbg=None ctermfg=11
hi Visual       ctermbg=8    ctermfg=None
hi VertSplit    ctermbg=None ctermfg=7    cterm=None
" Diff
hi DiffAdd      ctermbg=10   ctermfg=0
hi DiffChange   ctermbg=11   ctermfg=0
hi DiffDelete   ctermbg=None ctermfg=9
" popup menu
hi Pmenu        ctermbg=0    ctermfg=7    cterm=None
hi PmenuSel     ctermbg=8    ctermfg=15   cterm=None
" tab line
hi TabLine      ctermbg=None ctermfg=7    cterm=None
hi TabLineSel   ctermbg=6    ctermfg=0    cterm=None
hi TabLineFill  ctermbg=None ctermfg=7    cterm=None
" symbol highlight
hi LspReferenceText  ctermbg=8
hi LspReferenceRead  ctermbg=8
hi LspReferenceWrite ctermbg=8
hi IlluminatedWordText  ctermbg=8
hi IlluminatedWordRead  ctermbg=8
hi IlluminatedWordWrite ctermbg=8
" Syntax
hi Delimiter       ctermfg=3
hi Identifier      ctermfg=14
hi Type            ctermfg=6   cterm=bold
hi Constant        ctermfg=11
hi Comment         ctermfg=2
hi Keyword         ctermfg=13  cterm=bold
hi Boolean         ctermfg=3
hi Number          ctermfg=3
hi Function        ctermfg=12
hi String          ctermfg=13
hi Underlined      ctermfg=4   cterm=underline
hi Todo            ctermbg=11  cterm=bold
hi Statement       ctermfg=5   cterm=bold
hi Special         ctermfg=13
hi Ignore          ctermfg=0
hi PreProc         ctermfg=5   cterm=bold
hi Conceal         ctermbg=0
hi! link Operator  Delimiter
hi! link Error     ErrorMsg
" }}}
" built-in plugins or file type supports {{{
let g:loaded_python3_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_node_provider = 0
let g:loaded_ruby_provider = 0
let g:termdebug_wide=1
" let g:markdown_folding = 1
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
set listchars=tab:│\ ,trail:.,eol:
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
    autocmd FileType gnuplot setlocal commentstring=#%s
    autocmd FileType maxima setlocal commentstring=/*%s*/
    autocmd FileType mma setlocal commentstring=(*%s*)
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
augroup makeprg
    autocmd!
    autocmd Filetype sh compiler shellcheck
    autocmd Filetype perl compiler perl
    autocmd Filetype tex compiler tex | let &makeprg = "latexmk -xelatex -interaction=nonstopmode %"
    autocmd BufWrite tex exe 'Make'
augroup END
" }}}
" IM Toggle {{{
" restore input method state when enter insert mode
function CheckFcitxCmd()
    if !exists("s:fcitx_cmd")
        let s:find_exe = "command -v fcitx-remote || command -v fcitx5-remote"
        let s:fcitx_cmd = trim(system(s:find_exe))
    endif
endfunction
function IMDisable()
    call CheckFcitxCmd()
    if !exists("s:fcitxon")
        let s:fcitxon = system(s:fcitx_cmd) =~ '^\d'
    endif
    if s:fcitxon
        let b:fcitx = system(s:fcitx_cmd)
        call system(s:fcitx_cmd . ' -c')
    endif
endfunction
function IMEnable()
    call CheckFcitxCmd()
    if exists('b:fcitx') && b:fcitx == 2
        call system(s:fcitx_cmd . ' -o')
    endif
endfunction
augroup im_toggle
    autocmd!
    autocmd InsertLeave * call IMDisable()
    autocmd InsertEnter * call IMEnable()
augroup END
" }}}
" My own goyo mode {{{
function Goyo()
    if exists("g:goyo_status")
        unlet g:goyo_status
        set nu rnu ru scl=auto stal=2 ls=2
    else
        let g:goyo_status = 1
        set nonu nornu noru scl=no stal=0 ls=0
    endif
endfunction
" }}}
" Execute current file {{{
function ShowOutput(channel, msg)
    if bufwinnr("exec_out") == -1
        sbuffer exec_out
    endif
endfunction

function AsyncRun(cmd)
    if bufexists("exec_out")
        call deletebufline("exec_out", 1, '$')
    endif
    call job_start(a:cmd, {
    \   "out_io": "buffer",
    \   "err_io": "buffer",
    \   "out_name": "exec_out",
    \   "err_name": "exec_out",
    \   "callback": function('ShowOutput'),
    \ })
endfunction

function ExecCurrentFile()
    if index(['gnuplot', 'perl', 'python', 'sh'], &ft) >= 0
        let command = [&ft, expand("%:p")]
    elseif &ft == "maxima"
        let command = ["maxima", "-b", expand("%:p")]
    elseif &ft == "tex"
        let command = ["latexmk", "-xelatex", "-pvc", expand("%:p")]
    else
        if &ft == "markdown"
            call MarkdownPreviewToggle()
        else
            echo "Not supported file type"
        endif
        return
    endif
    call AsyncRun(command)
endfunction

function Make()
    let makefile = findfile("Makefile", ".;")
    call AsyncRun(["make", "-C", makefile])
endfunction
" }}}
" vim:foldmethod=marker:foldlevel=0
