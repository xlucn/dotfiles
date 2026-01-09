return {
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        init = function()
            vim.api.nvim_set_hl(0, "CopilotSuggestion", { link = "NonText" })
        end,
        opts = {
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = '<C-J>'
                }
            }
        },
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "main",
        dependencies = {
            { "zbirenbaum/copilot.lua" },
            { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
        },
        opts = {
            chat_autocomplete = true,
        },
        keys = {
            {
                "<localleader>cc",
                "<CMD>CopilotChatToggle<CR>",
                mode = { "n", "x" },
                desc = "Toggle"
            },
            {
                "<localleader>ce",
                "<CMD>CopilotChatExplain<CR>",
                mode = { "n", "x" },
                desc = "Explain"
            },
            {
                "<localleader>cr",
                "<CMD>CopilotChatReview<CR>",
                mode = { "n", "x" },
                desc = "Review"
            },
            {
                "<localleader>cf",
                "<CMD>CopilotChatFix<CR>",
                mode = { "n", "x" },
                desc = "Fix"
            },
            {
                "<localleader>co",
                "<CMD>CopilotChatOptimize<CR>",
                mode = { "n", "x" },
                desc = "Optimize"
            },
            {
                "<localleader>cd",
                "<CMD>CopilotChatDocs<CR>",
                mode = { "n", "x" },
                desc = "Docs"
            },
            {
                "<localleader>ct",
                "<CMD>CopilotChatTests<CR>",
                mode = { "n", "x" },
                desc = "Tests"
            },
            {
                "<localleader>cF",
                "<CMD>CopilotChatFixDiagnostic<CR>",
                mode = { "n", "x" },
                desc = "Fix Diagnostics"
            },
            {
                "<localleader>cC",
                "<CMD>CopilotChatCommit<CR>",
                mode = { "n", "x" },
                desc = "Commit"
            },
            {
                "<localleader>cS",
                "<CMD>CopilotChatCommitStaged<CR>",
                mode = { "n", "x" },
                desc = "Commit Staged"
            },
            {
                "<localleader>cq",
                function()
                    local input = vim.fn.input("Quick Chat: ")
                    if input ~= "" then
                        require("CopilotChat").ask(input, {
                            selection = require("CopilotChat.select").buffer
                        })
                    end
                end,
                mode = { "n", "x" },
                desc = "Quick chat",
            }
        }
    },
}
