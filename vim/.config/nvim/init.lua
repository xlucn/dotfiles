-- common config for vim and neovim
vim.cmd(":source $XDG_CONFIG_HOME/vim/common.vim")

-- nvim configuration
vim.o.cmdheight = 1
vim.o.laststatus = 3
vim.o.foldenable = false
vim.o.mousemodel = 'extend'
vim.o.mousemoveevent = true
vim.o.termguicolors = false
vim.g.health = { style = 'float' }

-- color scheme
local highlights = {
    ColorColumn = { ctermbg = 237 },
    CursorColumn = { ctermbg = 237 },
    CursorLine = { ctermbg = 237 },
    FoldColumn = { ctermbg = nil, ctermfg = 8 },
    Folded = { ctermbg = nil, ctermfg = 8 },
    LineNr = { ctermbg = nil, ctermfg = 8 },
    NonText = { ctermbg = nil, ctermfg = 8 },
    Normal = { ctermbg = nil },
    NormalFloat = { ctermbg = 237 },
    SignColumn = { ctermbg = nil },
    SpellBad = { ctermbg = nil, undercurl = true },
    SpellCap = { ctermbg = nil, ctermfg = 3 },
    Visual = { ctermbg = 237, ctermfg = nil },
    DiffAdd = { ctermbg = 10, ctermfg = 0 },
    DiffChange = { ctermbg = 3, ctermfg = 0 },
    DiffDelete = { ctermbg = nil, ctermfg = 1 },
    Pmenu = { ctermbg = 235 },
    PmenuSel = { ctermbg = 237 },
    TabLine = { ctermbg = nil, ctermfg = 8 },
    TabLineSel = { ctermbg = 6, ctermfg = 0 },
    TabLineFill = { ctermbg = nil, ctermfg = 8 },
    StatusLine = { ctermbg = 235 },
    -- Syntax groups
    Boolean = { ctermfg = 3 },
    Comment = { ctermfg = 2 },
    Conceal = { ctermbg = 237 },
    Constant = { ctermfg = 3 },
    Delimiter = { ctermfg = 3 },
    Error = { ctermbg = 1 },
    Function = { ctermfg = 12 },
    Identifier = { ctermfg = 14 },
    Ignore = { ctermfg = 0 },
    Keyword = { ctermfg = 13, bold = true },
    Number = { ctermfg = 3 },
    Operator = { ctermfg = 3 },
    PreProc = { ctermfg = 5, bold = true },
    Special = { ctermfg = 13 },
    Statement = { ctermfg = 5, bold = true },
    String = { ctermfg = 13 },
    Todo = { ctermbg = 3, bold = true },
    Type = { ctermfg = 6, bold = true },
    Underlined = { ctermfg = 4, underline = true }
}
for group, hl in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, hl)
end

local mapopts = { noremap=true, silent=true }
vim.keymap.set('n', '<M-j>', '<C-W>w', mapopts)
vim.keymap.set('n', '<M-k>', '<C-W>W', mapopts)
vim.keymap.set('n', '<M-J>', '<C-W>r', mapopts)
vim.keymap.set('n', '<M-K>', '<C-W>R', mapopts)
vim.keymap.set('n', '<M-h>', '<C-W><', mapopts)
vim.keymap.set('n', '<M-l>', '<C-W>>', mapopts)
vim.keymap.set('n', '<M-H>', '<C-W>-', mapopts)
vim.keymap.set('n', '<M-L>', '<C-W>+', mapopts)
vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump({ count = -1, float = true })
end, mapopts)
vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump({ count = 1, float = true })
end, mapopts)

vim.diagnostic.config({
    virtual_text = true,
    virtual_lines = {severity = { min = vim.diagnostic.severity.ERROR }},
})
vim.lsp.inlay_hint.enable()

-- Convert IM Toggle to Lua
local function check_fcitx_cmd()
    if not vim.g.fcitx_cmd then
        local fcitx_cmd = vim.fn.exepath('fcitx5-remote')
        if fcitx_cmd ~= '' then
            vim.g.fcitx_cmd = fcitx_cmd
        else
            return false
        end
    end
    return true
end
local function im_disable()
    if check_fcitx_cmd() then
        local fcitx_stats = tonumber(vim.fn.system(vim.g.fcitx_cmd))
        vim.g.fcitx_stats = fcitx_stats
        if fcitx_stats ~= 0 then
            vim.system({vim.g.fcitx_cmd, '-c'})
        end
    end
end
local function im_enable()
    if check_fcitx_cmd() and vim.g.fcitx_stats == 2 then
        vim.system({vim.g.fcitx_cmd, '-o'})
    end
end
vim.api.nvim_create_autocmd(
    'InsertEnter',
    { callback = im_enable }
)
vim.api.nvim_create_autocmd(
    {'VimEnter', 'InsertLeave', 'CmdlineLeave'},
    { callback = im_disable }
)

require("config.lazy")
