return {
    {
        "github/copilot.vim",
        init = function ()
            vim.g.copilot_no_tab_map = true
            vim.g.copilot_filetypes = {
                mail = false,
            }
        end,
        event = "VimEnter",
        keys = {
            { '<C-J>', 'copilot#Accept("\\<CR>")',
                mode = 'i',
                expr = true,
                replace_keycodes = false
            }
        }
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "main",
        dependencies = {
            { "github/copilot.vim" },
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
