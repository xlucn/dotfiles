local mapopts = { noremap=true, silent=true }

local function config_leap()
    require('leap').add_default_mappings()
end

local function config_nvim_lspconfig()
    -- LSP configs
    local lsp = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    local server_config = {
        bashls = {},
        ccls = {},
        marksman = {},
        pylsp = {},
        sumneko_lua = { settings = { Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }}},
        texlab = { settings = { texlab = {
            build = {
                executable = "latexmk",
                args = { "-xelatex",
                         "-interaction=nonstopmode",
                         "-synctex=1",
                         "%f" },
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
        }}}
    }

    vim.lsp.stop_client(vim.lsp.get_active_clients())
    for server, config in pairs(server_config) do
        config.capabilities = capabilities
        lsp[server].setup(config)
    end
end

local function config_nvim_cmp()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    cmp.setup({
        view = {
            entries = {  -- dynamic menu direction
                name = 'custom',
                selection_order = 'near_cursor'
            }
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'nvim_lua' },
        }, {
            { name = 'path' },
            { name = 'buffer' },
        }),
        formatting = {
            format = require'lspkind'.cmp_format({
                mode = 'symbol_text',
                preset = 'codicons',
                maxwidth = 30, -- pop up menu width
            })
        },
    })

    -- highlightings
    local colors = {
        CmpItemAbbrDeprecated = { ctermfg = 7, strikethrough = true },
        CmpItemAbbrMatch = { ctermfg = 12, bold = true },
        CmpItemAbbrMatchFuzzy = { ctermfg = 12, bold = true },
        CmpItemMenu = { ctermfg = 13, italic = true },
        CmpItemKind = { ctermfg = 0, ctermbg = 12 },
    }
    for key, value in pairs(colors) do
        vim.api.nvim_set_hl(0, key, value)
    end

    local kind_colors = {  -- base16 colors for completion types
        [1] = { "Field", "Property", "Event", },
        [2] = { "Text", "Enum", "Keyword", },
        [3] = { "Unit", "Snippet", "Folder", },
        [4] =  { "Method", "Value", "EnumMember", },
        [5] = { "Function", "Struct", "Class", "Module", "Operator", },
        [7] = { "Variable", "File", },
        [11] = { "Constant", "Constructor", "Reference", },
        [14] = { "Interface", "Color", "TypeParameter", }
    }
    for color, kinds in pairs(kind_colors) do
        for _, kind in ipairs(kinds) do
            vim.api.nvim_set_hl(0, 'CmpItemKind' .. kind, { ctermfg = color })
        end
    end
end

local function config_vim_illuminate()
    require('illuminate').configure({
        filetypes_denylist = { '', 'mail', 'markdown', 'text' },
        modes_denylist = { 'v', 'V' },
    })
end

local function config_which_key()
    local which_key = require("which-key")
    which_key.register({
        l = { name = "language server" },
    }, { prefix = "," })
end

local function config_nvim_treesitter()
    vim.o.foldmethod = 'expr'
    vim.o.foldenable = false
    vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

    require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        textobjects = {
            select = {
                enable = true,

                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,

                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["ap"] = "@parameter.outer",
                    ["ip"] = "@parameter.inner",
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
                -- You can choose the select mode (default is charwise 'v')
                selection_modes = {
                    ['@parameter.outer'] = 'v',
                    ['@function.outer'] = 'V',
                    ['@class.outer'] = 'V',
                },
                -- Extended textobjects to include preceding or succeeding
                -- whitespace. Succeeding whitespace has priority.
                include_surrounding_whitespace = true,
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>a"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>A"] = "@parameter.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]]"] = "@function.outer",
                    ["]c"] = "@class.outer",
                },
                goto_next_end = {
                    ["]["] = "@function.outer",
                    ["]C"] = "@class.outer",
                },
                goto_previous_start = {
                    ["[["] = "@function.outer",
                    ["[c"] = "@class.outer",
                },
                goto_previous_end = {
                    ["[]"] = "@function.outer",
                    ["[C"] = "@class.outer",
                },
            },
            lsp_interop = {
                enable = true,
                border = "none",
                peek_definition_code = {
                    ["<leader>pf"] = "@function.outer",
                    ["<leader>pF"] = "@class.outer",
                },
            },
        }
    })
end

local function config_gitsigns()
    require('gitsigns').setup({})
end

local function config_luasnip()
    require('luasnip.loaders.from_vscode').lazy_load()
end

local function config_slime()
    vim.keymap.set({'x', 'n'}, '<leader>s', '<Plug>SlimeSend<CR>', mapopts)
end

local function config_nvim_tree()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.keymap.set('n', 'L', '<CMD>NvimTreeToggle<CR>', mapopts)
    vim.api.nvim_set_hl(0, 'NvimTreeCursorLine', { ctermbg = 8 })

    require('nvim-tree').setup({
        hijack_cursor = true,
        renderer = {
            icons = { show = { git = false } },
            symlink_destination = false
        },
        diagnostics = { enable = true }
    })
end

local function config_bufdel()
    vim.keymap.set('n', '<leader>D', '<cmd>BufDel<cr>', mapopts)
end

local function config_fidget()
    require('fidget').setup({})
end

-- check or install dep plugin manager
local dep_path = vim.fn.stdpath("data") .. "/site/pack/deps/opt/dep"
local dep_url = "https://github.com/oliverlew/dep"
if vim.fn.empty(vim.fn.glob(dep_path)) > 0 then
  vim.fn.system({ "git", "clone", "--depth=1", dep_url, dep_path })
end
vim.cmd("packadd dep")

require('dep')({
    -- basic
    -- { 'aymericbeaumet/vim-symlink' },
    { 'tpope/vim-commentary' },
    { 'tpope/vim-endwise' },
    { 'tpope/vim-repeat' },
    { 'tpope/vim-sensible' },
    { 'tpope/vim-surround' },
    { 'tpope/vim-dispatch' },
    { 'tpope/vim-fugitive' },
    { 'ojroques/nvim-bufdel', config_bufdel },
    { 'ap/vim-buftabline' },
    -- others
    { 'lewis6991/gitsigns.nvim', config_gitsigns },
    { 'nvim-tree/nvim-web-devicons', deps = 'nvim-tree/nvim-tree.lua' },
    { 'nvim-tree/nvim-tree.lua', config_nvim_tree },
    { 'preservim/tagbar' },
    { 'jpalardy/vim-slime', config_slime },
    { 'RRethy/vim-illuminate', config_vim_illuminate },
    { 'ggandor/leap.nvim', config_leap },
    { 'folke/which-key.nvim', config_which_key },
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-lualine/lualine.nvim' },
    { 'nvim-telescope/telescope.nvim' },
    { 'nvim-treesitter/nvim-treesitter', config_nvim_treesitter },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    -- snippet engine and sources
    { 'honza/vim-snippets', deps = 'L3MON4D3/LuaSnip' },
    { 'rafamadriz/friendly-snippets', deps = 'L3MON4D3/LuaSnip' },
    { 'L3MON4D3/LuaSnip', config_luasnip, deps = 'hrsh7th/nvim-cmp' },
    -- completion engine and sources
    { 'onsails/lspkind.nvim', deps = 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-nvim-lua' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/nvim-cmp', config_nvim_cmp },
    -- lsp and integrations
    { 'j-hui/fidget.nvim', config_fidget },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'neovim/nvim-lspconfig', config_nvim_lspconfig },
    sync="never"
})
