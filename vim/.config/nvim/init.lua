vim.cmd('packadd vim-packager')
require('packager').setup(function(packager)
    -- Package manager
    packager.add('kristijanhusak/vim-packager', {type = 'opt'})
    -- Basic
    packager.add('tpope/vim-commentary')
    packager.add('tpope/vim-endwise')
    packager.add('tpope/vim-repeat')
    packager.add('tpope/vim-sensible')
    packager.add('tpope/vim-surround')
    packager.add('tpope/vim-dispatch')
    packager.add('tpope/vim-unimpaired')
    packager.add('ap/vim-buftabline')
    -- Language server
    packager.add('neovim/nvim-lspconfig', {type = 'opt'});
    packager.add('hrsh7th/nvim-cmp', {type = 'opt'});
    packager.add('hrsh7th/cmp-nvim-lsp', {type = 'opt'});
    packager.add('hrsh7th/vim-vsnip', {type = 'opt'});
    packager.add('hrsh7th/cmp-vsnip', {type = 'opt'});
    packager.add('hrsh7th/vim-vsnip-integ', {type = 'opt'});
    -- Enhancements
    packager.add('majutsushi/tagbar')
    packager.add('liuchengxu/vim-which-key')
    packager.add('jpalardy/vim-slime')
    packager.add('airblade/vim-gitgutter')
end)

vim.cmd('packadd nvim-lspconfig')
vim.cmd('packadd cmp-nvim-lsp')
vim.cmd('packadd nvim-cmp')
vim.cmd('packadd cmp-vsnip')
vim.cmd('packadd vim-vsnip')
vim.cmd('packadd vim-vsnip-integ')

local lsp = require('lspconfig')
local cmp = require('cmp')
cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    })
})
lsp['pylsp'].setup({})
lsp['bashls'].setup({})
lsp['sumneko_lua'].setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})
lsp['texlab'].setup({
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
