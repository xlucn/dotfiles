return {
    {
        'RRethy/vim-illuminate',
        config = function()
            require('illuminate').configure({
                filetypes_denylist = { '', 'mail', 'markdown', 'text' },
                modes_denylist = { 'v', 'V', '', '' },
            })
            vim.api.nvim_set_hl(0, 'IlluminatedWordText', { link = 'Visual' })
            vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { link = 'Visual' })
            vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { link = 'Visual' })
        end,
        event = "UIEnter"
    },
    {
        'folke/which-key.nvim',
        ---@class wk.Opts
        opts = {
            preset = "helix",
            spec = {
                { '<leader>l', group = "language server" },
                { '<leader>z', group = "zk notes" },
            },
        },
    },
    {
        'folke/trouble.nvim',
        config = true,
        cmd = 'Trouble'
    },
    {
        "navarasu/onedark.nvim",
        priority = 1000,
        opts = {
            style = 'dark',
            transparent = true,
        }
    },
    {
        'lewis6991/gitsigns.nvim',
        config = true,
    },
}
