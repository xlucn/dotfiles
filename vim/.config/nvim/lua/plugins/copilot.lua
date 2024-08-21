return {
    -- {
    --     "github/copilot.vim",
    --     init = function ()
    --         vim.g.copilot_no_tab_map = true
    --         vim.g.copilot_filetypes = {
    --             mail = false,
    --         }
    --     end,
    --     event = "VimEnter",
    --     keys = {
    --         { '<C-J>', 'copilot#Accept("\\<CR>")',
    --             mode = 'i',
    --             expr = true,
    --             replace_keycodes = false
    --         }
    --     }
    -- },
    {
        "zbirenbaum/copilot.lua",
        lazy = false,
        init = function ()
            vim.g.copilot_proxy = os.getenv("PROXY")  -- my proxy settings
            vim.api.nvim_set_hl(0, "CopilotSuggestion", { link = "NonText" })
            vim.api.nvim_set_hl(0, "CopilotAnnotation", { link = "NonText" })
        end,
        opts = {
            filetypes = { mail = false },
            suggestion = { enabled = false },
            panel = { enabled = false },
        }
    },
    {
        "zbirenbaum/copilot-cmp",
        config = true,
        event = "InsertEnter",
        dependencies = {
            "zbirenbaum/copilot.lua"
        },
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        dependencies = {
            { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
            { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
        },
        config = function()
            require("CopilotChat.integrations.cmp").setup()
            require("CopilotChat").setup({
                debug = true, -- Enable debugging
                proxy = os.getenv("PROXY"),
                -- window = {
                --     layout = 'float',
                --     relative = 'cursor',
                --     width = 1,
                --     height = 0.4,
                --     row = 1
                -- },
                mappings = {
                    complete = {
                        insert ='',  -- disable to use cmp
                    },
                }
            })
        end,
        keys = {
            {
                "<localleader>cc",
                ":CopilotChatToggle<CR>",
                mode = { "n", "x" },
                desc = "Toggle"
            },
            {
                "<localleader>ce",
                ":CopilotChatExplain<CR>",
                mode = { "n", "x" },
                desc = "Explain"
            },
            {
                "<localleader>cr",
                ":CopilotChatReview<CR>",
                mode = { "n", "x" },
                desc = "Review"
            },
            {
                "<localleader>cf",
                ":CopilotChatFix<CR>",
                mode = { "n", "x" },
                desc = "Fix"
            },
            {
                "<localleader>co",
                ":CopilotChatOptimize<CR>",
                mode = { "n", "x" },
                desc = "Optimize"
            },
            {
                "<localleader>cd",
                ":CopilotChatDocs<CR>",
                mode = { "n", "x" },
                desc = "Docs"
            },
            {
                "<localleader>ct",
                ":CopilotChatTests<CR>",
                mode = { "n", "x" },
                desc = "Tests"
            },
            {
                "<localleader>cF",
                ":CopilotChatFixDiagnostic<CR>",
                mode = { "n", "x" },
                desc = "Fix Diagnostics"
            },
            {
                "<localleader>cC",
                ":CopilotChatCommit<CR>",
                mode = { "n", "x" },
                desc = "Commit"
            },
            {
                "<localleader>cS",
                ":CopilotChatCommitStaged<CR>",
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
