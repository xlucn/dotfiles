return {
    {
        'TimUntersberger/neogit',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        opts = {
            kind = 'split',
        },
        cmd = 'Neogit'
    },
    {
        'lewis6991/gitsigns.nvim',
        config = true,
        event = "BufRead"
    },
}
