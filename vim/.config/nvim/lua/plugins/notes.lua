return {
    {
        'zk-org/zk-nvim',
        config = function ()
            require('zk').setup({
                picker = 'telescope',
            })
        end,
        keys = {
            { '<leader>zo', ':ZkNotes<cr>', desc = "open notes" },
            { '<leader>zn', ':ZkNew<cr>', desc = "create new notes" },
            { '<leader>zb', ':ZkBacklinks<cr>', desc = "show back links" },
            { '<leader>zl', ':ZkLinks<cr>', desc = "show links" },
            { '<leader>zt', ':ZkTags<cr>', desc = "show tags" },
        },
    },
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
