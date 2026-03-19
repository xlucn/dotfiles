return {
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter' },
        },
        opts = {
            -- max_lines = 3,
            trim_scope = 'outer',
            multiline_threshold = 1,
        },
    },
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        main = 'nvim-treesitter.configs',
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter-textobjects' },
        },
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
                enable = true,
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
        },
    },
}
