local mapopts = { noremap=true, silent=true }

local function config_commentary()
    vim.keymap.set('n', '<leader>c', '<Plug>CommentaryLine', mapopts)
    vim.keymap.set('o', '<leader>c', '<Plug>Commentary', mapopts)
    vim.keymap.set('x', '<leader>c', '<Plug>Commentary', mapopts)
end

local function config_leap()
    require('leap').add_default_mappings()
end

local function config_nvim_lspconfig()
    -- LSP configs
    local lsp = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    local server_config = {
        bashls = { },
        -- ccls = { cmd = {
        --     'ccls', '--init={ "cache": { "directory": "'.. os.getenv('XDG_CACHE_HOME') .. '/ccls" } }'
        -- }},
        clangd = { },
        marksman = { },
        pylsp = { },
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
                         "-outdir=./output/",
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
        }}},
        vimls = { }
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
        modes_denylist = { 'v', 'V', '' },
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
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = true,
        },
        textobjects = {
            select = {
                enable = true,

                -- Automatically jump forward to textobj, similar to targets.vim
                -- lookahead = true,

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

local function config_luasnip()
    require('luasnip.loaders.from_vscode').lazy_load()
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

local function config_lightbulb()
    require('nvim-lightbulb').setup({
        autocmd = { enabled = true }
    })
end

local function config_toggleterm()
    vim.keymap.set({'t', 'n'}, '<C-Bslash>', '<cmd>ToggleTerm<cr>', mapopts)
    vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<cr>', mapopts)
    vim.keymap.set('n', '<leader>ts', '<cmd>ToggleTermSendCurrentLine<cr>', mapopts)
    vim.keymap.set('x', '<leader>ts', '<cmd>ToggleTermSendVisualLines<cr>', mapopts)
    require("toggleterm").setup()
end

local function config_neogit()
    require("neogit").setup({
        kind = 'split',
    })
end

local function config_lualine()
    local colors = {
        black        = 0,
        darkgray     = 0,
        gray         = 7,
        lightgray    = 8,
        white        = 15,
        inactivegray = 0,
        red          = 9,
        green        = 10,
        yellow       = 11,
        blue         = 12,
    }
    local theme = {
        normal = {
            a = { bg = colors.gray, fg = colors.black, gui = 'bold' },
            b = { bg = colors.lightgray, fg = colors.white },
            c = { bg = colors.darkgray, fg = colors.gray }
        },
        insert = {
            a = { bg = colors.blue, fg = colors.black, gui = 'bold' },
            b = { bg = colors.lightgray, fg = colors.white },
            c = { bg = colors.lightgray, fg = colors.white }
        },
        visual = {
            a = { bg = colors.yellow, fg = colors.black, gui = 'bold' },
            b = { bg = colors.lightgray, fg = colors.white },
            c = { bg = colors.inactivegray, fg = colors.black }
        },
        replace = {
            a = { bg = colors.red, fg = colors.black, gui = 'bold' },
            b = { bg = colors.lightgray, fg = colors.white },
            c = { bg = colors.black, fg = colors.white }
        },
        command = {
            a = { bg = colors.green, fg = colors.black, gui = 'bold' },
            b = { bg = colors.lightgray, fg = colors.white },
            c = { bg = colors.inactivegray, fg = colors.black }
        },
        inactive = {
            a = { bg = colors.darkgray, fg = colors.gray, gui = 'bold' },
            b = { bg = colors.darkgray, fg = colors.gray },
            c = { bg = colors.darkgray, fg = colors.gray }
        }
    }
    require('lualine').setup({
        options = {
            theme = theme,
            icons_enabled = false,
            disable_hint = true,
            disable_commit_confirmation = true,
        },
    })
end

local function config_dap_ui()
    local dapui = require("dapui")
    vim.keymap.set('n', '<leader>D', dapui.toggle, mapopts)
    dapui.setup({})
end

local function config_dap_python()
    require('dap-python').setup()
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- { 'aymericbeaumet/vim-symlink' },
    { 'tpope/vim-commentary', config = config_commentary, keys = { "<leader>c" } },
    { 'tpope/vim-dispatch', enabled = true, cmd = "Dispatch" },
    { 'ojroques/nvim-bufdel', config = config_bufdel, cmd = "BufDel" },
    { 'ap/vim-buftabline' },
    { 'kylechui/nvim-surround', config = true, keys = { 'ys', 'ds', 'cs' } },
    { 'TimUntersberger/neogit', config = config_neogit, dependencies = {
        { 'nvim-lua/plenary.nvim' },
    }, cmd = 'Neogit' },
    { 'akinsho/toggleterm.nvim', config = config_toggleterm, keys = { '<C-Bslash>' } },
    { 'lewis6991/gitsigns.nvim', config = true, event = "VeryLazy" },
    { 'nvim-tree/nvim-tree.lua', config = config_nvim_tree, keys = { 'L' } },
    { 'preservim/tagbar', cmd = "Tagbar" },
    { 'RRethy/vim-illuminate', config = config_vim_illuminate, event = "BufRead" },
    { 'ggandor/leap.nvim', config = config_leap, keys = { 's', 'S' } },
    { 'folke/which-key.nvim', config = config_which_key, keys = { '<leader>' } },
    { 'nvim-lualine/lualine.nvim', config = config_lualine, enabled = false },
    { 'nvim-telescope/telescope.nvim', dependencies = {
        { 'nvim-lua/plenary.nvim' },
    }, cmd = "Telescope" },
    { 'nvim-treesitter/nvim-treesitter-textobjects', dependencies = {
        { 'nvim-treesitter/nvim-treesitter', config = config_nvim_treesitter },
    }, ft = {
        'sh', 'c', 'cpp', 'lua', 'python', 'tex'
    }},
    { 'rcarriga/nvim-dap-ui', config = config_dap_ui, dependencies = {
        { 'mfussenegger/nvim-dap' },
        { 'mfussenegger/nvim-dap-python', config = config_dap_python },
    }, keys = { '<leader>D' }},
    -- completion engine and sources
    { 'hrsh7th/nvim-cmp', config = config_nvim_cmp, dependencies = {
        { 'onsails/lspkind.nvim', dependencies = {
            { 'nvim-tree/nvim-web-devicons' },
        }},
        { 'hrsh7th/cmp-buffer', },
        { 'hrsh7th/cmp-path', },
        { 'hrsh7th/cmp-nvim-lua', },
        { 'hrsh7th/cmp-nvim-lsp' },
        -- snippet engine and sources
        { 'saadparwaiz1/cmp_luasnip', dependencies = {
            { 'L3MON4D3/LuaSnip', config = config_luasnip, dependencies = {
                -- { 'honza/vim-snippets' },
                { 'rafamadriz/friendly-snippets' },
            }},
        }},
    }, event = 'InsertEnter' },
    -- lsp and integrations
    { 'neovim/nvim-lspconfig', config = config_nvim_lspconfig, ft = {
        'sh', 'c', 'cpp', 'markdown', 'python', 'lua', 'tex', 'vim'
    }, dependencies = {
        { 'j-hui/fidget.nvim', config = true },
        { 'kosayoda/nvim-lightbulb', config = config_lightbulb, enabled = false },
    }},
})
