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
        opts = {
            spec = {
                { '<leader>l', group = "language server" },
                { '<leader>z', group = "zk notes" },
            },
        },
        event = "VeryLazy",
    },
    {
        'folke/trouble.nvim',
        config = true,
        cmd = 'Trouble'
    },
}
