return {
    {
        "obsidian-nvim/obsidian.nvim",
        version = "*",  -- recommended, use latest release instead of latest commit
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "Saghen/blink.cmp",
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim",
        },
        init = function()
            vim.opt.conceallevel = 2 -- Enable conceal for markdown
        end,
        opts = {
            -- use all sub-directories in ~/Code/Obsidian as workspaces
            workspaces = vim.iter(
                vim.fn.glob("~/Code/notes/*/", false, true)
            ):map(function (d)
                return { name = vim.fs.basename(d), path = d, }
            end):totable(),
            legacy_commands = false,
            ui = { enable = false },
        },
    }
}
