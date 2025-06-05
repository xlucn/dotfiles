return {
    {
        'NeogitOrg/neogit',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        opts = {
            kind = 'split',
        },
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>", "n" },
        },
    },
    {
        'lewis6991/gitsigns.nvim',
        config = true,
        event = "UIEnter"
    },
}
