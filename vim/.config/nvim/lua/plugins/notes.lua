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
        opts = {
            workspaces = {
                {
                    name = "default",
                    path = "~/Code/Obsidian",
                },
            },
        },
    }
}
