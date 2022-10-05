function NvimLSPStatus()
    local total, count = 0, 0
    local message = ' '
    local levels = { E = 'ERROR', W = 'WARN', I = 'INFO', H = 'HINT' }
    for k, v in pairs(levels) do
        count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[v] })
        if count > 0 then
            message = message .. k .. ': ' .. count .. ' '
            total = total + count
        end
    end
    if total == 0 then
        message = message .. 'OK '
    end
    return message
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lsp = require('lspconfig')
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

        -- Mappings.
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
}
for _, server in ipairs(servers) do
    lsp[server].setup({
        capabilities = capabilities,
    })
end

lsp['sumneko_lua'].setup({
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})
lsp['texlab'].setup({
    capabilities = capabilities,
    settings = {
        texlab = {
            build = {
                executable = "latexmk",
                args = {
                    "-xelatex",
                    "-interaction=nonstopmode",
                    "-synctex=1",
                    "%f"
                },
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

require("which-key").register({
    l = { name = "language server" },
    c = "Commentary"
}, {
    prefix = "<leader>"
})
