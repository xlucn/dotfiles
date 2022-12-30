-- nvim configuration
require "plugins"
require "statusline"

vim.o.mousemodel = 'extend'
vim.o.cmdheight = 1
vim.o.laststatus = 3

local mapopts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>gg', vim.cmd.Git, mapopts)
vim.keymap.set('n', '<M-j>', '<C-W>w', mapopts)
vim.keymap.set('n', '<M-k>', '<C-W>W', mapopts)
vim.keymap.set('n', '<M-J>', '<C-W>r', mapopts)
vim.keymap.set('n', '<M-K>', '<C-W>R', mapopts)
vim.keymap.set('n', '<M-h>', '<C-W><', mapopts)
vim.keymap.set('n', '<M-l>', '<C-W>>', mapopts)
vim.keymap.set('n', '<M-H>', '<C-W>-', mapopts)
vim.keymap.set('n', '<M-L>', '<C-W>+', mapopts)

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(args.buf, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap=true, silent=true, buffer=args.buf }
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', ',li', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', ',lr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', ',lR', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', ',la', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', ',lf', vim.lsp.buf.format, bufopts)
    end
})
