return {
    {
        'saghen/blink.cmp',
        event = { 'InsertEnter', 'CmdlineEnter' },
        -- optional: provides snippets for the snippet source
        dependencies = {
            'rafamadriz/friendly-snippets',
            'folke/lazydev.nvim',
        },

        -- use a release tag to download pre-built binaries
        version = '*',

        opts = {
            keymap = {
                preset = 'enter',
                ['<C-c>'] = { 'hide', 'fallback' },
                ['<Enter>'] = { 'accept', 'fallback' },
                ['<C-p>'] = { 'snippet_backward', 'fallback' },
                ['<C-n>'] = { 'snippet_forward', 'fallback' },
                ['<Tab>'] = { 'select_next', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'fallback' },
            },
            completion = {
                keyword = { range = 'full' },
                list = { selection = {
                    preselect = false,
                    auto_insert = true,
                } },
                documentation = { auto_show = true },
                menu = { draw = { treesitter = { 'lsp' } } },
            },
            sources = {
                default = { "lsp", "buffer", "path", "snippets" },
                per_filetype = { lua = {
                    inherit_defaults = true, 'lazydev'
                } },
                providers = {
                    lazydev = { module = "lazydev.integrations.blink" },
                    path = { opts = {
                        show_hidden_files_by_default = true,
                    }}
                },
            },
            cmdline = {
                enabled = true,
                keymap = { preset = 'inherit' },
                completion = {
                    menu = { auto_show = true },
                    list = { selection = {
                        preselect = false,
                        auto_insert = false,
                    } }
                },
            },
            signature = {
                enabled = true,
                trigger = { show_on_insert = true },
            },
        },
    },
}
