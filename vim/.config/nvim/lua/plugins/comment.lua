return {
    {
        'numToStr/Comment.nvim',
        opts = {
            ignore = '^$',
            sticky = true,
        },
        event = "UIEnter",
        keys = {
            { "<leader>c", "<Plug>(comment_toggle_linewise_current)", mode = 'n' },
            { "<leader>c", "<Plug>(comment_toggle_linewise_visual)", mode = 'x' },
        }
    },
}
