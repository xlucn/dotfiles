return {
    {
        'voldikss/vim-mma',
        ft = 'mma',
        init = function ()
            vim.g.mma_candy = 2
        end
    },
    {
        'brianhuster/live-preview.nvim',
        ft = 'markdown',
        dependencies = {
            'nvim-telescope/telescope.nvim',
        },
    }
}
