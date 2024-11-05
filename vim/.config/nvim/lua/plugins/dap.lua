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
            -- First, configure debug adapters
            dap.adapters.cppdbg = {
                type = 'executable',
                command = 'cppdbg',  -- packaged in AUR
            }
            dap.adapters.lldb = {
                type = 'executable',
                command = 'lldb-dap', -- from lldb package
            }
            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
            }
            -- Then, configure different filetypes to use specific adapters
            dap.configurations.cpp = {
                {
                    name = "Launch file (cppdbg)",
                    type = "cppdbg",
                    request = "launch",
                    program = prompt_inputfile,
                    cwd = '${workspaceFolder}',
                    -- console = 'integratedTerminal',
                    -- terminalKind = "integrated",
                    stopAtEntry = true,
                },
                {
                    name = "Launch file (lldb)",
                    type = "lldb",
                    request = "launch",
                    program = prompt_inputfile,
                    cwd = '${workspaceFolder}',
                    -- console = 'integratedTerminal',
                    -- terminalKind = "integrated",
                    stopOnEntry = false,
                    args = {},
                },
                {
                    name = "Launch file (gdb)",
                    type = "gdb",
                    request = "launch",
                    program = prompt_inputfile,
                    cwd = "${workspaceFolder}",
                    -- console = 'integratedTerminal',
                    -- terminalKind = "integrated",
                    stopAtBeginningOfMainSubprogram = false,
                },
            }
            dap.configurations.c = dap.configurations.cpp
            dap.configurations.rust = dap.configurations.cpp
        end,
    },
}
