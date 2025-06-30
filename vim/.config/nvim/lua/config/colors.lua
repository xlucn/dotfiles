local c = {
    -- gray scale, assume dark background
    bg = nil,
    fg = 15,
    black = 16,
    dark3 = 235,
    dark = 237,
    dark2 = 239,
    light3 = 243,
    light = 245,
    light2 = 247,
    white = 231,
    -- normal colors
    red = 1,
    green = 2,
    yellow = 3,
    blue = 4,
    magenta = 5,
    cyan = 6,
    -- bright colors
    red2 = 9,
    green2 = 10,
    yellow2 = 11,
    blue2 = 12,
    magenta2 = 13,
    cyan2 = 14,
    -- dark colors
    red3 = 88,
    green3 = 28,
    yellow3 = 178,
    blue3 = 25,
    magenta3 = 91,
    cyan3 = 31,
}

c.none = "NONE"

c.diff = {
    add = c.green,
    delete = c.red,
    change = c.blue,
    text = c.blue,
}

c.border = c.blue
-- Popups and statusline always get a dark background
c.bg_popup = c.dark3
c.bg_statusline = c.dark3
c.bg_highlight = c.dark3
c.fg_gutter = c.light
-- Sidebar and Floats are configurable
c.bg_sidebar = c.dark3
c.bg_float = c.dark3
c.bg_visual = c.dark
c.bg_search = c.dark2
c.fg_sidebar = c.light2
c.fg_float = c.fg
-- Diagnostics and messages
c.error = c.red
c.todo = c.blue
c.warning = c.yellow
c.info = c.blue
c.hint = c.cyan
c.comment = c.green

local colorscheme = {
    -- used for the columns set with 'colorcolumn'
    ColorColumn   = { ctermbg = c.dark3 },
    -- placeholder characters substituted for concealed text (see 'conceallevel')
    Conceal       = { ctermfg = c.dark },
    -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    CurSearch     = { ctermbg = c.bg_search },
    -- character under the cursor
    Cursor        = { ctermfg = c.bg, ctermbg = c.fg },
    -- like Cursor, but used when in IME mode |CursorIM|
    CursorIM      = { ctermfg = c.bg, ctermbg = c.fg },
    -- Screen-column at the cursor, when 'cursorcolumn' is set.
    CursorColumn  = { ctermbg = c.bg_highlight },
    -- Screen-line at the cursor, when 'cursorline' is set.
    -- Low-priority if foreground (cctermfg OR guifg) is not set.
    CursorLine    = { ctermbg = c.bg_highlight },
    -- directory names (and other special names in listings)
    Directory     = { ctermfg = c.blue },
    -- diff mode: Added line |diff.txt|
    DiffAdd       = { ctermbg = c.diff.add },
    -- diff mode: Changed line |diff.txt|
    DiffChange    = { ctermbg = c.diff.change },
    -- diff mode: Deleted line |diff.txt|
    DiffDelete    = { ctermbg = c.diff.delete },
    -- diff mode: Changed text within a changed line |diff.txt|
    DiffText      = { ctermbg = c.diff.text },
    -- cursor in a focused terminal
    TermCursor    = { ctermfg = c.bg, ctermbg = c.fg },
    -- error messages on the command line
    ErrorMsg      = { ctermfg = c.error },
    -- line used for closed folds
    Folded        = { ctermfg = c.blue, ctermbg = c.fg_gutter },
    -- column where |signs| are displayed
    SignColumn    = { ctermbg = c.none, ctermfg = c.fg_gutter },
    -- |:substitute| replacement text highlighting
    Substitute    = { ctermbg = c.red, ctermfg = c.black },
    -- Line number for ":number" and ":#" commands
    LineNr        = { ctermfg = c.fg_gutter },
    -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
    CursorLineNr  = { ctermfg = c.yellow, bold = true },
    -- The character under the cursor or just before it, if it is a paired
    -- bracket, and its match. |pi_paren.txt|
    MatchParen    = { ctermfg = c.yellow, bold = true },
    -- 'showmode' message (e.g., "-- INSERT")
    ModeMsg       = { ctermfg = c.fg_dark, bold = true },
    -- Area for messages and cmdline
    MsgArea       = { ctermfg = c.fg_dark },
    -- |more-prompt|
    MoreMsg       = { ctermfg = c.blue },
    -- '@' at the end of the window, characters from 'showbreak' and
    -- other characters that do not really exist in the text (e.g., ">"
    -- displayed when a double-wide character doesn't fit at the end of
    -- the line). See also |hl-EndOfBuffer|.
    NonText       = { ctermfg = c.dark },
    -- normal text
    Normal        = { ctermfg = c.fg, ctermbg = c.none },
    -- Normal text in floating windows.
    NormalFloat   = { ctermfg = c.fg_float, ctermbg = c.bg_float },
    FloatBorder   = { ctermfg = c.border, ctermbg = c.bg_float },
    FloatTitle    = { ctermfg = c.border, ctermbg = c.bg_float },
    -- normal text in non-current windows
    NormalNC      = { ctermfg = c.fg, ctermbg = c.none },
    -- Popup menu: normal item.
    Pmenu         = { ctermbg = c.bg_popup, ctermfg = c.fg },
    -- Popup menu: selected item.
    PmenuSel      = { ctermbg = c.fg_gutter },
    -- Popup menu: Matched text in normal item.
    PmenuMatch    = { ctermbg = c.bg_popup, ctermfg = c.blue1 },
    -- Popup menu: Matched text in selected item.
    PmenuMatchSel = { ctermbg = c.fg_gutter, ctermfg = c.blue1 },
    -- Popup menu: scrollbar.
    PmenuSbar     = { ctermbg = c.bg_popup },
    -- Popup menu: Thumb of the scrollbar.
    PmenuThumb    = { ctermbg = c.fg_gutter },
    -- |hit-enter| prompt and yes/no questions
    Question      = { ctermfg = c.blue },
    -- Current |quickfix| item in the quickfix window.
    -- Combined with |hl-CursorLine| when the cursor is there.
    QuickFixLine  = { ctermbg = c.bg_visual, bold = true },
    -- Last search pattern highlighting (see 'hlsearch').
    -- Also used for similar items that need to stand out.
    Search        = { ctermbg = c.bg_search, ctermfg = c.bg },
    -- Unprintable characters: text displayed differently from what it really is.
    -- But not 'listchars' whitespace. |hl-Whitespace|
    SpecialKey    = { ctermfg = c.dark },
    -- Word that is not recognized by the spellchecker.
    -- |spell| Combined with the highlighting used otherwise.
    SpellBad      = { undercurl = true },
    -- Word that should start with a capital.
    -- |spell| Combined with the highlighting used otherwise.
    SpellCap      = { undercurl = true },
    -- Word that is recognized by the spellchecker as one that is used in another region.
    -- |spell| Combined with the highlighting used otherwise.
    SpellLocal    = { undercurl = true },
    -- Word that is recognized by the spellchecker as one that is hardly ever used.
    -- |spell| Combined with the highlighting used otherwise.
    SpellRare     = { undercurl = true },
    -- status line of current window
    StatusLine    = { ctermfg = c.fg_sidebar, ctermbg = c.bg_statusline },
    -- status lines of not-current windows
    -- Note: if this is equal to "StatusLine" Vim will use "^^^" in the
    -- status line of the current window.
    StatusLineNC  = { ctermfg = c.fg_gutter, ctermbg = c.bg_statusline },
    -- tab pages line, not active tab page label
    TabLine       = { ctermbg = c.bg_statusline, ctermfg = c.fg_gutter },
    -- tab pages line, where there are no labels
    TabLineFill   = { ctermbg = nil },
    -- tab pages line, active tab page label
    TabLineSel    = { ctermfg = nil, ctermbg = c.blue },
    -- titles for output from ":set all", ":autocmd" etcolors.
    Title         = { ctermfg = c.blue, bold = true },
    -- Visual mode selection
    Visual        = { ctermbg = c.bg_visual },
    -- Visual mode selection when vim is "Not Owning the Selection".
    VisualNOS     = { ctermbg = c.bg_visual },
    -- warning messages
    WarningMsg    = { ctermfg = c.warning },
    -- "nbsp", "space", "tab" and "trail" in 'listchars'
    Whitespace    = { ctermfg = c.fg_gutter },
    -- current match in 'wildmenu' completion
    WildMenu      = { ctermbg = c.bg_visual },
    -- window bar
    WinBar        = { ctermfg = c.fg_sidebar, ctermbg = c.bg_statusline },
    -- window bar in inactive windows
    WinBarNC      = { ctermfg = c.fg_gutter, ctermbg = c.bg_statusline },

    -- any comment
    Comment       = { ctermfg = c.comment },
    -- (preferred) any constant
    Constant      = { ctermfg = c.yellow },
    -- a string constant: "this is a string"
    String        = { ctermfg = c.green },
    -- a character constant: 'c', '\n'
    Character     = { ctermfg = c.green },
    -- a number constant: 234, 0xff
    Number        = { ctermfg = c.yellow2 },
    -- a boolean constant: TRUE, false
    Boolean       = { ctermfg = c.yellow2 },
    -- a floating point constant: 2.3e10
    Float         = { ctermfg = c.yellow2 },
    -- (preferred) any variable name
    Identifier    = { ctermfg = c.magenta2 },
    -- function name (also: methods for classes)
    Function      = { ctermfg = c.blue, bold = true },
    -- (preferred) any statement
    Statement     = { ctermfg = c.magenta },
    -- "sizeof", "+", "*", etcolors.
    Operator      = { ctermfg = c.blue2 },
    -- any other keyword
    Keyword       = { ctermfg = c.cyan2, italic = true },
    -- (preferred) generic Preprocessor
    PreProc       = { ctermfg = c.cyan },
    -- (preferred) int, long, char, etcolors.
    Type          = { ctermfg = c.blue },
    -- (preferred) any special symbol
    Special       = { ctermfg = c.magenta },
    -- character that needs attention
    Delimiter     = { ctermfg = c.light2 },
    -- debugging statements
    Debug         = { ctermfg = c.yellow },
    -- (preferred) text that stands out, HTML links
    Underlined    = { underline = true },
    -- (preferred) any erroneous construct
    Error         = { ctermfg = c.error },
    -- (preferred) anything that needs extra attention;
    -- mostly the keywords TODO FIXME and XXX
    Todo          = { ctermbg = c.yellow, ctermfg = c.bg },

    -- Tree-sitter, most are linked to existing groups by default
    ["@property"] = { ctermfg = c.blue2 },
    ["@variable"] = { ctermfg = c.fg },
    ["@variable.member"] = { ctermfg = c.blue2 },
    ["@variable.parameter"] = { ctermfg = c.yellow3 },
}

for group, hl in pairs(colorscheme) do
    vim.api.nvim_set_hl(0, group, hl)
end
