return {
    {
        'stevearc/aerial.nvim',
        opts = {
            disable_max_lines = 100000,
        },
        keys = {
            { '<leader>b', function()
                require("aerial").toggle()
            end, mode = 'n' },
        }
    },
}
