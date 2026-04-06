return {
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { }
    },
    {
        'akinsho/toggleterm.nvim',
        opts = {
            direction = 'tab',
            auto_scroll = false,
            open_mapping = '<C-BSlash>'
        },
        keys = {
            { '<C-BSlash>', mode = { 'n', 't' } },
            { '<leader>s', '<cmd>ToggleTermSendCurrentLine<cr>', mode = 'n' },
            { '<leader>s', '<cmd>ToggleTermSendVisualSelection<cr>', mode = 'v' },
        }
    },
    {
        "danymat/neogen",
        opts = {
            languages = {
                python = {
                    template = {
                        annotation_convention = "numpydoc"
                    }
                }
            }
        },
        keys = {
            { "<leader>nn", "<cmd>Neogen<cr>", desc = "Generate documentation" },
            { "<leader>nf", "<cmd>Neogen func<cr>", desc = "Generate function documentation" },
            { "<leader>nc", "<cmd>Neogen class<cr>", desc = "Generate class documentation" },
            { "<leader>nt", "<cmd>Neogen type<cr>", desc = "Generate type documentation" },
            { "<leader>nF", "<cmd>Neogen file<cr>", desc = "Generate file documentation" },
        },
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
        },
        cmd = "Telescope",
        opts = {
            defaults = {
                layout_strategy = 'flex',
                layout_config = {
                    flex = { flip_columns = 200, },
                    vertical = { preview_cutoff = 20 },
                },
                mappings = {
                    i = { ["<esc>"] = function(...)  -- arg passthrough
                        return require("telescope.actions").close(...)
                    end },
                },
            }
        },
    {
    {
        'ojroques/nvim-bufdel',
        config = true,
        keys = {
            { '<leader>d', '<cmd>BufDel<cr>', mode = 'n', desc = 'Delete buffer' }
        },
    },
}
