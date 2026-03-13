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

vim.diagnostic.config({
    virtual_text = true,
    virtual_lines = {severity = { min = vim.diagnostic.severity.ERROR }},
})
vim.lsp.inlay_hint.enable()

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function (args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "texlab" then
            local function buf_set_keymap(key, cmd)
                vim.api.nvim_buf_set_keymap(args.buf, 'n', key, cmd, {
                    noremap = true, silent = true
                })
            end
            buf_set_keymap('<leader>ll', '<cmd>LspTexlabBuild<CR>')
            buf_set_keymap('<leader>lv', '<cmd>LspTexlabForward<CR>')
            buf_set_keymap('<leader>lc', '<cmd>LspTexlabCleanAuxiliary<CR>')
            buf_set_keymap('<leader>lC', '<cmd>LspTexlabCleanArtifacts<CR>')
            buf_set_keymap('<leader>lr', '<cmd>LspTexlabChangeEnvironment<CR>')
        end
    end
})

vim.lsp.enable({
    "bashls",
    "clangd",
    -- "copilot",
    "fortls",
    "marksman",
    "pylsp",
    -- "ruff",
    "lua_ls",
    "rust_analyzer",
    "texlab",
    "tinymist",
    "ts_ls",
    "vimls",
    "wolfram_lsp",
})

-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(args)
--     local bufnr = args.buf
--     local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
--
--     if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
--       vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
--
--       vim.keymap.set(
--         'i',
--         '<C-F>',
--         vim.lsp.inline_completion.get,
--         { desc = 'LSP: accept inline completion', buffer = bufnr }
--       )
--       vim.keymap.set(
--         'i',
--         '<C-G>',
--         vim.lsp.inline_completion.select,
--         { desc = 'LSP: switch inline completion', buffer = bufnr }
--       )
--     end
--   end
-- })

-- Convert IM Toggle to Lua
local fcitx_cmd = nil
local fcitx_status = nil
local function check_fcitx_cmd()
    local search_result = vim.fn.exepath('fcitx5-remote')
    if search_result ~= '' then
        fcitx_cmd = 'fcitx5-remote'
    end
end
local function im_disable()
    if fcitx_cmd == nil then return end
    fcitx_status = tonumber(vim.fn.system(fcitx_cmd))
    if fcitx_status == 2 then
        vim.system({fcitx_cmd, '-c'})
    end
end
local function im_enable()
    if fcitx_cmd == nil then return end
    if fcitx_status == 2 then
        vim.system({fcitx_cmd, '-o'})
    end
end
vim.api.nvim_create_autocmd('VimEnter', { callback = check_fcitx_cmd })
vim.api.nvim_create_autocmd('InsertEnter', { callback = im_enable })
vim.api.nvim_create_autocmd('InsertLeave', { callback = im_disable })

require("config.lazy")
require("config.colors")
