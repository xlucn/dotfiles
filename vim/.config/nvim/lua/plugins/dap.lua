return {
    {
        'rcarriga/nvim-dap-ui',
        config = true,
        keys = {
            { '<leader>D', function ()
                require'dapui'.toggle()
            end, mode = 'n' }
        },
        dependencies = {
            { 'mfussenegger/nvim-dap' },
            { 'mfussenegger/nvim-dap-python', config = function()
                require('dap-python').setup()
            end },
            { "nvim-neotest/nvim-nio" },
        },
    },
}
