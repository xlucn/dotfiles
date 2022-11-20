-- nvim configuration
vim.o.mousemodel = 'extend'
vim.o.cmdheight = 1

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldenable = false

require('packer').startup(function(use)
    -- packer itself
    use("wbthomason/packer.nvim")
    -- basic
    use('tpope/vim-commentary')
    use('tpope/vim-endwise')
    use('tpope/vim-repeat')
    use('tpope/vim-sensible')
    use('tpope/vim-surround')
    use('tpope/vim-dispatch')
    use('ap/vim-buftabline')
    -- lsp related
    use('neovim/nvim-lspconfig')
    use('hrsh7th/nvim-cmp')
    use('hrsh7th/cmp-nvim-lsp')
    use('hrsh7th/cmp-vsnip')
    use('hrsh7th/vim-vsnip')
    use('hrsh7th/vim-vsnip-integ')
    -- others
    use('majutsushi/tagbar')
    use('jpalardy/vim-slime')
    use('airblade/vim-gitgutter')
    use({'RRethy/vim-illuminate', config=function()
        require('illuminate').configure({
            filetypes_denylist = { '', 'mail', 'markdown' },
        })
    end})
    use({'folke/which-key.nvim', config=function()
        local which_key = require("which-key")
        -- which_key.setup()
        which_key.register({
            l = { name = "language server" },
        }, {
            prefix = ","
        })
    end})
    use('nvim-lua/plenary.nvim')
    use('nvim-lualine/lualine.nvim')
    use('nvim-telescope/telescope.nvim')
    use({'nvim-treesitter/nvim-treesitter', config=function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { 'c', 'bash', 'python', 'lua' },
            highlight = { enable = true, disable = { 'latex' } },
        })
    end})
end)

function NvimLSPStatus()
    local messages = {}
    local levels = { E = 'ERROR', W = 'WARN', I = 'INFO', H = 'HINT' }
    for key, severity in pairs(levels) do
        local count = #vim.diagnostic.get(0, {
            severity = vim.diagnostic.severity[severity]
        })
        if count > 0 then
            table.insert(messages, key .. ':' .. count)
        end
    end
    return next(messages) and table.concat(messages) or 'OK'
end

-- LSP configs
local lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local cmp = require('cmp')

cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    })
})

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
        vim.keymap.set('n', ',lf', vim.lsp.buf.formatting, bufopts)
    end
})

-- servers with simple setup
local servers = {
    'clangd',
    'pylsp',
    'bashls',
    'marksman',
}
for _, server in ipairs(servers) do
    lsp[server].setup({ capabilities = capabilities })
end

lsp['sumneko_lua'].setup({
    capabilities = capabilities,
    settings = { Lua = { diagnostics = { globals = { 'vim' } } } },
})

lsp['texlab'].setup({
    capabilities = capabilities,
    settings = {
        texlab = {
            build = {
                executable = "latexmk",
                args = { "-xelatex", "-interaction=nonstopmode", "-synctex=1", "%f" },
                onSave = true,
            },
            forwardSearch = {
                executable = "zathura",
                args = { "--synctex-forward", "%l:1:%f", "%p" },
            },
            auxDirectory = "./output",
            chktex = {
                onOpenAndSave = false,
            }
        }
    }
})
