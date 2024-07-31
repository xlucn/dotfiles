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
    { 'zk-org/zk-nvim' },
}
