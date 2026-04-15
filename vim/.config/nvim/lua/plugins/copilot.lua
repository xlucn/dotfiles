return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
        },
        opts = {
            chat_autocomplete = true,
        },
        keys = {
            { "<leader>cc", ":CopilotChatToggle<CR>",
              mode = { "n", "x" }, desc = "Toggle" },
            { "<leader>ce", ":CopilotChatExplain<CR>",
              mode = { "n", "x" }, desc = "Explain" },
            { "<leader>cr", ":CopilotChatReview<CR>",
              mode = { "n", "x" }, desc = "Review" },
            { "<leader>cf", ":CopilotChatFix<CR>",
              mode = { "n", "x" }, desc = "Fix" },
            { "<leader>co", ":CopilotChatOptimize<CR>",
              mode = { "n", "x" }, desc = "Optimize" },
            { "<leader>cd", ":CopilotChatDocs<CR>",
              mode = { "n", "x" }, desc = "Docs" },
            { "<leader>ct", ":CopilotChatTests<CR>",
              mode = { "n", "x" }, desc = "Tests" },
            { "<leader>cC", ":CopilotChatCommit<CR>",
              mode = { "n", "x" }, desc = "Commit" },
            { "<leader>cp", ":CopilotChatPrompts<CR>",
              mode = { "n", "x" }, desc = "Commit" },
            { "<leader>cm", ":CopilotChatModels<CR>",
              mode = { "n", "x" }, desc = "Commit" },
        },
    },
}
