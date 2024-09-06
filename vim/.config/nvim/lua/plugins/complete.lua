return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'onsails/lspkind.nvim',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            -- "zbirenbaum/copilot-cmp",
            -- snippet engine and sources
            'saadparwaiz1/cmp_luasnip',
            'L3MON4D3/LuaSnip'
        },
        config = function ()
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            cmp.setup({
                view = {
                    entries = {  -- dynamic menu direction
                        name = 'custom',
                        selection_order = 'near_cursor'
                    }
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-g>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    -- { name = "copilot", keyword_length = 0 },
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'nvim_lua' },
                    { name = 'nvim_lsp_signature_help' },
                }, {
                    { name = 'path' },
                    { name = 'buffer' },
                }),
                formatting = {
                    format = require'lspkind'.cmp_format({
                        mode = 'symbol_text',
                        preset = 'codicons',
                        maxwidth = 30, -- pop up menu width
                        -- symbol_map = { Copilot = "" },
                    })
                },
                experimental = { ghost_text = true },
            })
        end,
        init = function ()
            -- highlightings
            local colors = {
                CmpItemAbbrDeprecated = { ctermfg = 7, strikethrough = true },
                CmpItemAbbrMatch = { ctermfg = 12, bold = true },
                CmpItemAbbrMatchFuzzy = { ctermfg = 12, bold = true },
                CmpItemMenu = { ctermfg = 13, italic = true },
                CmpItemKind = { ctermfg = 0, ctermbg = 12 },
            }
            for key, value in pairs(colors) do
                vim.api.nvim_set_hl(0, key, value)
            end

            local kind_colors = {
                -- [base16 colors] = { completion types }
                [1] = { "Field", "Property", "Event", },
                [2] = { "Text", "Enum", "Keyword", },
                [3] = { "Unit", "Snippet", "Folder", },
                [4] =  { "Method", "Value", "EnumMember", },
                [5] = { "Function", "Struct", "Class", "Module", "Operator", },
                [7] = { "Variable", "File", },
                [11] = { "Constant", "Constructor", "Reference", },
                [14] = { "Interface", "Color", "TypeParameter", }
            }
            for color, kinds in pairs(kind_colors) do
                for _, kind in ipairs(kinds) do
                    vim.api.nvim_set_hl(0, 'CmpItemKind' .. kind, { ctermfg = color })
                end
            end
        end,
        event = 'InsertEnter'
    },
}
