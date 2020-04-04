let s:Xcolors = { '0': 'NONE',
  \ '1': 'NONE', '2': 'NONE', '3': 'NONE', '4': 'NONE',
  \ '5': 'NONE', '6': 'NONE', '7': 'NONE', '8': 'NONE',
  \ }
" Load colors from Xresources
if has('gui_running')
    let s:regex = '.*\*color\(\d*\):.*\(#[0-9a-fA-F]\{6\}\).*'
    for line in systemlist("xrdb -query")
        let s:color = matchlist(line, s:regex)
        if s:color != []
            let s:Xcolors[s:color[1]] = s:color[2]
        endif
    endfor
endif

let s:bg      = [ 'NONE', 'NONE' ]
let s:black   = [ s:Xcolors['0'], 0 ]
let s:red     = [ s:Xcolors['1'], 1 ]
let s:green   = [ s:Xcolors['2'], 2 ]
let s:yellow  = [ s:Xcolors['3'], 3 ]
let s:blue    = [ s:Xcolors['4'], 4 ]
let s:magenta = [ s:Xcolors['5'], 5 ]
let s:cyan    = [ s:Xcolors['6'], 6 ]
let s:white   = [ s:Xcolors['7'], 7 ]
let s:grey    = [ s:Xcolors['8'], 8 ]

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
