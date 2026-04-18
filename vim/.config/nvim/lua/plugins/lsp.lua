return {
    {
        'neovim/nvim-lspconfig',
        lazy = false,
    },
    {
        "mason-org/mason.nvim",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                },
                height = 0.8,
            }
        }
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            automatic_enable = {
                exclude = { 'copilot', 'zuban' }
            }
        },
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
    },
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        config = true,
    },
}
