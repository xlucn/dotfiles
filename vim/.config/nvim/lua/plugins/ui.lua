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
        "catgoose/nvim-colorizer.lua",
        event = "BufReadPre",
        opts = {}
    },
    {
        'lewis6991/gitsigns.nvim',
        config = true,
    },
    {
        "navarasu/onedark.nvim",
        priority = 1000,
        opts = {
            style = 'dark',
            transparent = true,
        }
    },
}
