local prompt_inputfile = function()
    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
end

return {
    {
        'rcarriga/nvim-dap-ui',
        dependencies = {
            { 'mfussenegger/nvim-dap' },
            { 'mfussenegger/nvim-dap-python' },
            { "nvim-neotest/nvim-nio" },
        },
        config = true,
        keys = {
            { '<leader>D', function ()
                require'dapui'.toggle()
            end, mode = 'n' }
        },
    },
    {
        'mfussenegger/nvim-dap-python',
        config = function()
            require('dap-python').setup()
            -- Allow step into library code
            -- require('dap').configurations.python[1].justMyCode = false
        end
    },
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            { 'mfussenegger/nvim-dap-python' }
        },
        config = function()
            local dap = require('dap')
            dap.adapters.cppdbg = {
                id = 'cppdbg',
                type = 'executable',
                command = 'cppdbg',  -- packaged in AUR
            }
            dap.adapters.lldb = {
                type = 'executable',
                command = '/usr/bin/lldb-dap',
                name = "lldb",
            }
            dap.configurations.cpp = {
                {
                    name = "Launch file (cppdbg)",
                    type = "cppdbg",
                    request = "launch",
                    program = prompt_inputfile,
                    cwd = '${workspaceFolder}',
                    stopAtEntry = true,
                },
                {
                    name = "Launch file (lldb)",
                    type = "lldb",
                    request = "launch",
                    program = prompt_inputfile,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                    args = {},
                },
            }
            dap.configurations.c = dap.configurations.cpp
            dap.configurations.rust = dap.configurations.cpp
        end,
    },
}
