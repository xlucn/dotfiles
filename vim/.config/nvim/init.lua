-- common config for vim and neovim
vim.cmd.source "$HOME/.config/vim/common.vim"

-- nvim configuration
vim.o.cmdheight = 1
vim.o.laststatus = 3
vim.o.foldenable = false
vim.o.mousemodel = 'extend'
vim.o.mousemoveevent = true
vim.o.termguicolors = true

vim.g.health = { style = nil }
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0

-- enable experimental but good new ui framework
require('vim._core.ui2').enable()

vim.diagnostic.config({
    virtual_text = true,
    virtual_lines = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '\u{ea87}',
            [vim.diagnostic.severity.WARN] = '\u{ea6c}',
            [vim.diagnostic.severity.INFO] = '\u{ea74}',
            [vim.diagnostic.severity.HINT] = '\u{eaa2}',
        }
    }
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function ()
        vim.wo.foldlevel = 99
        vim.wo.foldenable = true
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo.foldmethod = 'expr'
    end
})

vim.api.nvim_create_autocmd('BufRead', {
    pattern = 'PKGBUILD',
    callback = function ()
        vim.diagnostic.enable(false)
    end
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function (args)
        local bufnr = args.buf
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local methods = vim.lsp.protocol.Methods

        if client.name == "texlab" then
            local function buf_set_keymap(key, cmd)
                vim.keymap.set('n', key, cmd, { buffer=args.buf })
            end
            buf_set_keymap('<leader>ll', '<cmd>LspTexlabBuild<CR>')
            buf_set_keymap('<leader>lv', '<cmd>LspTexlabForward<CR>')
            buf_set_keymap('<leader>lc', '<cmd>LspTexlabCleanAuxiliary<CR>')
            buf_set_keymap('<leader>lC', '<cmd>LspTexlabCleanArtifacts<CR>')
            buf_set_keymap('<leader>lr', '<cmd>LspTexlabChangeEnvironment<CR>')
        end

        if client:supports_method(methods.textDocument_inlineCompletion, bufnr) then
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
    "wolfram_lsp",
})
vim.lsp.inline_completion.enable(true)

require("config.lazy")
vim.cmd.packadd "nvim.undotree"
vim.cmd.colorscheme "onedark"
