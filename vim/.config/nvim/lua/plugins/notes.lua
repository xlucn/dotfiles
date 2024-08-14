return {
    {
        'nvim-neorg/neorg',
        opts = {
            load = {
                ["core.defaults"] = {},
                ["core.concealer"] = {},
                ["core.completion"] = {
                    config = {
                        engine = "nvim-cmp"
                    }
                },
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            main = "~/Code/notes",
                            test = "~/Code/test"
                        }
                    }
                }
            }
        },
        dependencies = {
            { 'vhyrro/luarocks.nvim', config = true, priority = 1000 }
        },
        cmd = 'Neorg',
        ft = 'norg',
    },
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
        "epwalsh/obsidian.nvim",
        version = "*",  -- recommended, use latest release instead of latest commit
        ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
        --   -- refer to `:h file-pattern` for more examples
        --   "BufReadPre path/to/my-vault/*.md",
        --   "BufNewFile path/to/my-vault/*.md",
        -- },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            workspaces = {
                {
                    name = "default",
                    path = "~/Code/Obsidian",
                },
            },
            ui = {
                enable = false,
            },
            -- Completion of wiki links, local markdown links, and tags
            completion = {
                nvim_cmp = true,
                min_chars = 0,
            },
        },
    }
}
