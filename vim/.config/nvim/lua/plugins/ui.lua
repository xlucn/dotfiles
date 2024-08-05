return {
    {
        'kevinhwang91/nvim-hlslens',
        config = true,
        event = "BufRead"
    },
    {
        'RRethy/vim-illuminate',
        config = function ()
            require('illuminate').configure({
                filetypes_denylist = { '', 'mail', 'markdown', 'text' },
                modes_denylist = { 'v', 'V', '' },
            })
        end,
        event = "UIEnter"
    },
    {
        'j-hui/fidget.nvim',
        config = true,
        event = 'LspAttach'
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
        cmd = 'TroubleToggle'
    },
}
