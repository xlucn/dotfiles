return {
    {
        'nvim-tree/nvim-tree.lua',
        init = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            vim.api.nvim_set_hl(0, 'NvimTreeCursorLine', { ctermbg = 8 })
        end,
        keys = {
            { '<leader>t', function()
                require('nvim-tree.api').tree.toggle()
            end, mode = 'n' }
        },
        opts = {
            hijack_cursor = true,
            renderer = {
                icons = { show = { git = false } },
                symlink_destination = false
            },
            diagnostics = { enable = true }
        }
    },
    {
        'nvim-neo-tree/neo-tree.nvim',
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            'MunifTanjim/nui.nvim',
        },
        config = true,
        cmd = 'Neotree'
    },
}
