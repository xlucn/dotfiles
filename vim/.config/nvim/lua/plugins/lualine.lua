return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons'
        },
        opts = {
            options = {
                always_show_tabline = true,
            },
            tabline = {
                lualine_a = {'buffers'},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {'searchcount'},
                lualine_y = {'lsp_status'},
                lualine_z = {'tabs'},
            },
            extensions = {
                'lazy', 'mason', 'aerial', 'nvim-dap-ui', 'nvim-tree',
                'toggleterm', 'trouble'
            }
        },
    }
}
