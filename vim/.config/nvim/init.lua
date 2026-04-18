-- common config for vim and neovim
vim.cmd(":source $XDG_CONFIG_HOME/vim/common.vim")

-- nvim configuration
vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.o.foldenable = false
vim.o.mousemodel = 'extend'
vim.o.mousemoveevent = true
vim.o.termguicolors = true
vim.o.concealcursor = 'n'

vim.g.health = { style = nil }
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0

local mapopts = { noremap=true, silent=true }
vim.keymap.set('n', '<C-j>', '<cmd>bnext<cr>', mapopts)
vim.keymap.set('n', '<C-k>', '<cmd>bprevious<cr>', mapopts)
vim.keymap.set('n', '<M-j>', '<C-W>w', mapopts)
vim.keymap.set('n', '<M-k>', '<C-W>W', mapopts)

-- enable experimental but good new ui framework
require('vim._core.ui2').enable()

vim.diagnostic.config({
    virtual_text = true,
    virtual_lines = {severity = { min = vim.diagnostic.severity.ERROR }},
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function ()
        vim.wo.foldexpr = 'v:lua.vim.treesitter#foldexpr()'
        vim.wo.foldmethod = 'expr'
    end
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function (args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        if client.name == "texlab" then
            local function buf_set_keymap(key, cmd)
                vim.keymap.set('n', key, cmd, { buffer=args.buf })
            end
            buf_set_keymap('<leader>ll', '<cmd>LspTexlabBuild<CR>')
            buf_set_keymap('<leader>lv', '<cmd>LspTexlabForward<CR>')
            buf_set_keymap('<leader>lc', '<cmd>LspTexlabCleanAuxiliary<CR>')
            buf_set_keymap('<leader>lC', '<cmd>LspTexlabCleanArtifacts<CR>')
            buf_set_keymap('<leader>lr', '<cmd>LspTexlabChangeEnvironment<CR>')
        -- else
            -- vim.lsp.inlay_hint.enable()
        end

        local bufnr = args.buf
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
            vim.lsp.inline_completion.enable(true, { bufnr = bufnr })

            vim.keymap.set(
                'i', '<C-J>', vim.lsp.inline_completion.get,
                { desc = 'LSP: accept inline completion', buffer = bufnr }
            )
            vim.keymap.set(
                'i', '<C-F>', vim.lsp.inline_completion.select,
                { desc = 'LSP: switch inline completion', buffer = bufnr }
            )
        end
    end
})

-- Additional lsp enable, others are managed by Mason
vim.lsp.enable({
    "clangd",
    "texlab",
    "wolfram_lsp",
})

require("config.lazy")
vim.cmd.colorscheme "onedark"
