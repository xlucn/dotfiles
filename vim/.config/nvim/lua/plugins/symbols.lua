return {
    {
        'stevearc/aerial.nvim',
        opts = {
            disable_max_lines = 100000,
            min_width = 30,
        },
        keys = {
            { '<leader>b', function()
                require("aerial").toggle()
            end, mode = 'n' },
        }
    },
}
