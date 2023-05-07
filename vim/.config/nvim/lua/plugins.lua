local mapopts = { noremap=true, silent=true }

local function config_commentary()
    vim.keymap.set('n', '<leader>c', '<Plug>CommentaryLine', mapopts)
    vim.keymap.set('x', '<leader>c', '<Plug>Commentary', mapopts)
end

local function config_leap()
    require('leap').add_default_mappings()
end

local function config_nvim_lspconfig()
    -- LSP configs
    local server_config = {
        bashls = { },
        clangd = { },
        marksman = { },
        pylsp = { },
        lua_ls = { settings = { Lua = {
            diagnostics = { globals = { 'vim' } }
        }}},
        texlab = { settings = { texlab = {
            build = {
                executable = "latexmk",
                args = { "-outdir=./output/", "-xelatex", "-synctex=1",
                         "-interaction=nonstopmode", "%f" },
                onSave = true,
            },
            forwardSearch = {
                executable = "zathura",
                args = { "--synctex-forward", "%l:1:%f", "%p" },
            },
            auxDirectory = "./output",
            chktex = { onOpenAndSave = false, },
        }}},
        vimls = { }
    }

    vim.lsp.stop_client(vim.lsp.get_active_clients())
    local lsp = require('lspconfig')
    for server, config in pairs(server_config) do
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
            { name = 'nvim_lsp_signature_help' },
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
        experimental = { ghost_text = true },
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

local function config_toggleterm()
    vim.keymap.set({'t', 'n'}, '<C-Bslash>', '<cmd>ToggleTerm<cr>', mapopts)
    vim.keymap.set('n', '<leader>s', '<cmd>ToggleTermSendCurrentLine<cr>', mapopts)
    vim.keymap.set('v', '<leader>s', '<cmd>ToggleTermSendVisualSelection<cr>', mapopts)
    require("toggleterm").setup({
        -- size = function(_) return math.min(vim.o.lines / 2, 15) end,
        -- persist_size = false,
    })
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

local function config_telescope()
    local actions = require("telescope.actions")
    require("telescope").setup({
        defaults = {
            layout_strategy = 'flex',
            layout_config = {
                flex = { flip_columns = 140, },
                vertical = { preview_cutoff = 20 },
            },
            mappings = {
                i = { ["<esc>"] = actions.close },
            },
        }
    })
end

local function config_neorg()
    require('neorg').setup({
        load = {
            ["core.defaults"] = {},
            ["core.norg.concealer"] = {},
        }
    })
end

local function config_ufo()
    require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
            return {'treesitter', 'indent'}
        end
    })
end

local function config_symbols_outline()
    vim.api.nvim_set_hl(0, 'FocusedSymbol', { ctermfg = 2, ctermbg = 8 })
    vim.api.nvim_set_hl(0, 'SymbolsOutlineConnector', { ctermfg = 8 })

    local augroup = vim.api.nvim_create_augroup('SymbolsOutline', { clear = true })
    vim.api.nvim_create_autocmd(
        { 'FileType' },
        { group = augroup, pattern = 'Outline', callback = function()
            vim.o.signcolumn = 'no'
            vim.o.cursorline = true
        end }
    )

    require('symbols-outline').setup({
        auto_close = true,
        -- lsp_blacklist = { 'pylsp' },
    })
end

local function config_scrollbar()
    require('scrollbar').setup()
    require("scrollbar.handlers.gitsigns").setup()
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
    { 'tpope/vim-commentary', config = config_commentary, keys = {
        { "<leader>c", mode = { 'n', 'v' } },
    }},
    { 'simrat39/symbols-outline.nvim', config = config_symbols_outline, cmd = 'SymbolsOutline' },
    { 'liuchengxu/vista.vim', cmd = 'Vista' },
    { 'stevearc/aerial.nvim', config = function()
        require('aerial').setup()
    end, cmd = 'AerialToggle' },
    { 'folke/trouble.nvim', config = true, cmd = 'TroubleToggle' },
    { 'tpope/vim-dispatch', enabled = true, cmd = "Dispatch" },
    { 'ojroques/nvim-bufdel', config = config_bufdel, cmd = "BufDel" },
    -- { 'kevinhwang91/nvim-ufo', config = config_ufo, dependencies =
    --     { 'kevinhwang91/promise-async' }
    -- },
    { 'ap/vim-buftabline', event = 'BufRead' },
    { 'kylechui/nvim-surround', config = true, keys = {
        'ys', 'ds', 'cs', { 'S', mode = 'v' },
    }},
    { 'TimUntersberger/neogit', config = config_neogit, dependencies = {
        { 'nvim-lua/plenary.nvim' },
    }, cmd = 'Neogit' },
    { 'akinsho/toggleterm.nvim', config = config_toggleterm, keys = { '<C-Bslash>' }},
    { 'lewis6991/gitsigns.nvim', config = true, event = "BufRead" },
    { 'nvim-tree/nvim-tree.lua', config = config_nvim_tree, keys = { 'L' } },
    { 'nvim-neo-tree/neo-tree.nvim', config = true, dependencies = {
        'MunifTanjim/nui.nvim',
    }, cmd = 'NeoTreeShowToggle'},
    -- { 'petertriho/nvim-scrollbar', config = config_scrollbar, dependencies = {
    --     'kevinhwang91/nvim-hlslens'
    -- }},
    { 'preservim/tagbar', cmd = "Tagbar" },
    { 'RRethy/vim-illuminate', config = config_vim_illuminate, event = "BufRead" },
    { 'ggandor/leap.nvim', config = config_leap, keys = { 's', 'S' } },
    { 'folke/which-key.nvim', config = config_which_key, keys = { '<leader>' } },
    { 'nvim-telescope/telescope.nvim', dependencies = {
        { 'nvim-lua/plenary.nvim' },
    }, cmd = "Telescope", config = config_telescope },
    { 'nvim-treesitter/nvim-treesitter', tag = 'v0.8.5.2', dependencies = {
        { 'nvim-treesitter/nvim-treesitter-textobjects' },
    }, ft = {
        'sh', 'c', 'cpp', 'lua', 'python', 'tex',
    }, config = config_nvim_treesitter },
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
        { 'hrsh7th/cmp-nvim-lsp-signature-help' },
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
    }},
    { 'j-hui/fidget.nvim', config = true, event = 'LspAttach' },
    { 'nvim-neorg/neorg', config = config_neorg, cmd = 'Neorg', ft = 'norg' },
    { "utilyre/barbecue.nvim", config = true, dependencies = {
        "SmiteshP/nvim-navic"
    }, event = 'BufRead' },
})
