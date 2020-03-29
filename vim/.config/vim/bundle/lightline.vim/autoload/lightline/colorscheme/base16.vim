" source "$HOME/.cache/wal/colors-wal.vim"

let s:bg      = [ '#212121', 'NONE' ]
let s:black   = [ '#212121', 0 ]
let s:red     = [ '#d68787', 1 ]
let s:green   = [ '#87af87', 2 ]
let s:yellow  = [ '#d7875f', 3 ]
let s:blue    = [ '#87afaf', 4 ]
let s:magenta = [ '#df5f87', 5 ]
let s:cyan    = [ '#87d7d7', 6 ]
let s:white   = [ '#808070', 7 ]
let s:grey    = [ '#4e4e43', 8 ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.left     = [ [ s:black, s:cyan    ], [ s:white, s:grey ] ]
let s:p.normal.right    = [ [ s:black, s:white   ], [ s:white, s:grey ] ]
let s:p.inactive.right  = [ [ s:black, s:grey    ], [ s:white, s:bg   ] ]
let s:p.inactive.left   = [ [ s:white, s:bg      ], [ s:grey,  s:bg   ] ]
let s:p.insert.left     = [ [ s:black, s:green   ], [ s:white, s:grey ] ]
let s:p.replace.left    = [ [ s:black, s:magenta ], [ s:white, s:grey ] ]
let s:p.visual.left     = [ [ s:black, s:yellow  ], [ s:white, s:grey ] ]
let s:p.normal.middle   = [ [ s:white, s:bg      ] ]
let s:p.normal.error    = [ [ s:black, s:red     ] ]
let s:p.normal.warning  = [ [ s:black, s:yellow  ] ]
let s:p.inactive.middle = [ [ s:grey,  s:bg      ] ]
let s:p.tabline.left    = [ [ s:white, s:bg      ] ]
let s:p.tabline.tabsel  = [ [ s:black, s:white   ] ]
let s:p.tabline.middle  = [ [ s:grey,  s:bg      ] ]
let s:p.tabline.right   = copy(s:p.normal.right)

let g:lightline#colorscheme#base16#palette = lightline#colorscheme#flatten(s:p)
