" Some rules for vi init file: .exrc
" Starting a comment line with ", apparently :)
" No empty lines
"
" Vi options only (might be marked red in vim):
set noflash
"
" Options
" Vi will show tab as ^I, literally. It's not good looking.
set nolist
" Automatically indent on the next line
set autoindent
" Highlight the matching () {} when closing it.
set showmatch
" Ignore case when searching
set ignorecase
" Show messsage for edits exceeds this number of lines
set report=1
" Tab 4 spaces
set tabstop=4
" Indent 4 spaces with autoindent, >> or <<
set shiftwidth=4
" Do not line number
" In my case the cursor ignores the line number colomns in normal mode.
set nonumber
" Show mode change
set showmode
" No repeat mapping
set noremap
"
"
" Mappings with , as <leader>. Don't know why exactly this could work,
"   since the manual only specify one character as lhs (here are two).
"   According to 'An introduction to display editing with vi', the lhs
"   only need to be entered within 1 second when timeout is set.
"
" Quit, edit(reload) and save
map ,q :q
map ,e :e
map ,w :w
" Reload .exrc file in $HOME
map ,r :source ~/.exrc
" Other mappings
" Make backspace delete as expected, this works for all situations
map!  sa
map!  sa
" Copied a macro somewhere, complete with last word
" map!  a. hbmmi?\<2h"zdt.@zywmx`mP xi
