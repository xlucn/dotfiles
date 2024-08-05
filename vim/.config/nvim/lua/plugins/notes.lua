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
}
