return {
    {
        'akinsho/toggleterm.nvim',
        opts = {
            direction = 'float',
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
    },
}
