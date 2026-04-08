return {
    {
        'rcarriga/nvim-dap-ui',
        dependencies = {
            { 'mfussenegger/nvim-dap' },
            { "nvim-neotest/nvim-nio" },
        },
        init = function ()
            local dap = require'dap'
            local dapui = require'dapui'
            -- Open UI automatically when debugging starts
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end

            -- Close UI automatically when debugging ends
            -- dap.listeners.before.event_terminated.dapui_config = function()
            --     vim.ui.input({
            --         prompt = 'Program exited, press Enter to close:'
            --     }, function () dapui.close() end)
            -- end
            dap.listeners.before.event_exited.dapui_config = function()
                vim.ui.input({
                    prompt = 'Program exited, press Enter to close:'
                }, function () dapui.close() end)
            end
        end,
        opts = {
            layouts = {
                {
                    elements = {
                        { id = "scopes", size = 0.4 },
                        { id = "breakpoints", size = 0.15 },
                        { id = "stacks", size = 0.15 },
                        { id = "watches", size = 0.3 },
                    },
                    size = 40,
                    position = 'left',
                },
                {
                    elements = { "repl", "console" },
                    size = 10,
                    position = 'bottom',
                }
            }
        },
        keys = {
            { '<localleader>dd', function ()
                require'dapui'.toggle()
            end, mode = 'n' },
            { 'H', function ()
                require'dapui'.eval()
            end, mode = {'n', 'v'} },
        },
    },
    {
        "igorlfs/nvim-dap-view",
        dependencies = {
            { 'mfussenegger/nvim-dap' },
            { "nvim-neotest/nvim-nio" },
        },
        version = "1.*",
        ---@module 'dap-view'
        ---@type dapview.Config
        opts = {
            winbar = {
                sections = {
                    "watches",
                    "scopes",
                    "exceptions",
                    "breakpoints",
                    "threads",
                    "repl",
                    "console",
                },
                default_section = "scopes",
                show_keymap_hints = false,
                controls = { enabled = true }
            },
            windows = {
                size = 0.4,
                position = "right",
            },
            auto_toggle = true,
        },
        keys = {
            { '<localleader>dv', function ()
                require"dap-view".toggle()
            end, mode = 'n'}
        }
    },
    {
        'theHamsta/nvim-dap-virtual-text',
        opts = {},
    },
    {
        'mfussenegger/nvim-dap-python',
        dependencies = {
            { 'mfussenegger/nvim-dap' },
        },
        config = function()
            require('dap-python').setup()
            -- Allow step into library code
            -- require('dap').configurations.python[1].justMyCode = false
        end
    },
    {
        'mfussenegger/nvim-dap',
        config = function()
            local dap = require('dap')
            -- First, configure debug adapters
            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
            }
            -- Then, configure different filetypes to use specific adapters
            dap.configurations.cpp = {
                {
                    name = "Launch file (gdb)",
                    type = "gdb",
                    request = "launch",
                    program = function()
                        return vim.fn.input(
                            'Path to executable: ',
                            vim.fn.getcwd() .. '/',
                            'file'
                        )
                    end,
                    cwd = "${workspaceFolder}",
                    -- console = 'integratedTerminal',
                    -- terminalKind = "integrated",
                    stopAtBeginningOfMainSubprogram = false,
                },
            }
            dap.configurations.c = dap.configurations.cpp
            dap.configurations.rust = dap.configurations.cpp

            vim.keymap.set("n", "<F5>", function()
                require("dap").continue()
            end, { desc = "Continue" })
            vim.keymap.set("n", "<F10>", function()
                require("dap").step_over()
            end, { desc = "Step over" })
            vim.keymap.set("n", "<F11>", function()
                require("dap").step_into()
            end, { desc = "Step into" })
            vim.keymap.set("n", "<F12>", function()
                require("dap").step_out()
            end, { desc = "Step Out" })
            vim.keymap.set("n", "<localleader>b", function()
                require("dap").toggle_breakpoint()
            end, { desc = "Toggle breakpoint" })
            vim.keymap.set("n", "<localleader>dl", function()
                require("dap").run_last()
            end, { desc = "Run last" })
            vim.keymap.set({'n', 'v'}, '<localleader>dh', function()
                require('dap.ui.widgets').hover()
            end, { desc = "Hover" })
            vim.keymap.set({'n', 'v'}, '<localleader>dp', function()
                require('dap.ui.widgets').preview()
            end, { desc = "Preview" })
        end,
    },
}
