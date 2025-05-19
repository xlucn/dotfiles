return {
    {
        'saghen/blink.cmp',
        event = { 'InsertEnter' },
        -- optional: provides snippets for the snippet source
        dependencies = 'rafamadriz/friendly-snippets',

        -- use a release tag to download pre-built binaries
        version = '1.*',

        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- see the "default configuration" section below for full documentation on how to define
            -- your own keymap.
            keymap = {
                preset = 'enter',
                -- ['<C-g>'] = { 'hide', 'fallback' },
                -- ['<C-y>'] = { 'accept', 'fallback' },
                ['<C-p>'] = { 'snippet_backward', 'fallback' },
                ['<C-n>'] = { 'snippet_forward', 'fallback' },
                ['<Tab>'] = { 'select_next', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'fallback' },
            },

            appearance = {
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            completion = {
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = true,
                    }
                },
                keyword = {
                    range = 'full',
                },
                documentation = {
                    auto_show = true,
                },
                menu = {
                    draw = {
                        treesitter = { 'lsp' },
                    }
                },
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            cmdline = {
                enabled = false
            }
        },
    },
}
