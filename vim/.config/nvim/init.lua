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
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0

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
require("config.colors")
require("config.lsp")
