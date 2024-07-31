return {
    {
        'numToStr/Comment.nvim',
        opts = {
            ignore = '^$',
            toggler = { line = '<leader>c' },
            opleader = { line = '<leader>c' },
        },
        keys = {
            { "<leader>c", mode = {'n', 'x'}, desc = 'Comment lines' },
        }
    },
}
