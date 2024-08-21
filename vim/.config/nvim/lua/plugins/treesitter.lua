return {
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter' },
        },
        init = function()
            vim.api.nvim_set_hl(0, 'TreesitterContext', { ctermbg = 8 })
            vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { ctermbg = 8 })
        end,
        opts = {
            max_lines = 2,
            trim_scope = 'outer',
        },
        event = "BufEnter",
    },
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter-textobjects' },
        },
        -- ft = {
        --     'sh', 'c', 'cpp', 'lua', 'python', 'tex', 'fortran', "markdown",
        -- },
        event = "BufEnter",
        main = 'nvim-treesitter.configs',  -- tell lazy what setup function is
        opts = {
            ensure_installed = {
                'bash', 'c', 'cpp', 'lua', 'python', 'latex',
                'markdown', 'markdown_inline', 'html',  -- markview
                'java',
            },
            auto_install = true,
            highlight = {
                enable = true,
            },
            incremental_selection = {
                enable = true,
            },
            indent = {
                enable = true,
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
                        ['@function.outer'] = 'V',
                        ['@function.inner'] = 'V',
                        ['@class.outer'] = 'V',
                        ['@class.inner'] = 'V',
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
        }
    },
}
