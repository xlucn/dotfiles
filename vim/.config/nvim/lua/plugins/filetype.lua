return {
    {
        'voldikss/vim-mma',
        ft = 'mma'
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = "markdown",
        init = function ()
            vim.api.nvim_set_hl(0, "RenderMarkdownCode", { ctermbg = 0 })
            vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { ctermbg = 'none' })
            vim.api.nvim_set_hl(0, "RenderMarkdownTableFill", { ctermbg = 'none' })
        end,
        opts = {
            latex = { enabled = false },
            code = {
                position = "right",
                min_width = 50,
            },
        },
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons'
        },
    },
}
