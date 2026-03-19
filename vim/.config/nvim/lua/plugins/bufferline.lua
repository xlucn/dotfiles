return {
    {
        'akinsho/bufferline.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            options = {
                numbers = "ordinal",
                right_mouse_command = false,
                indicator = { style = 'none' },
                color_icons = false,
                show_buffer_icons = false,
                max_name_length = 30,
                separator_style = {'|', '|'},
                hover = {
                    enabled = true,
                    delay = 0,
                    reveal = {'close'}
                },
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        text_align = "center",
                        separator = true,
                    }
                },
            },
        },
    },
    {
        'ojroques/nvim-bufdel',
        config = true,
        keys = {
            { '<leader>d', '<cmd>BufDel<cr>', mode = 'n', desc = 'Delete buffer' }
        },
    },
}
