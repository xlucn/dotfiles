local selbg, selfg, visbg, visfg, bg = 6, 233, 0, 7, 233
local vis = { ctermbg = visbg, ctermfg = visfg }
local sel = { ctermbg = selbg, ctermfg = selfg }

return {
    {
        'akinsho/bufferline.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            options = {
                color_icons = false,
                numbers = function(opts) return opts.id end,
                right_mouse_command = false,
                show_buffer_icons = false,
                max_name_length = 30,
                -- indicator = { style = 'icon' },
                separator_style = 'slant',
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
            highlights = {
                fill = {
                    ctermbg = bg
                },
                background = vis,
                buffer_visible = vis,
                buffer_selected = {
                    ctermbg = selbg, ctermfg = selfg, italic = false,
                },
                close_button = vis,
                close_button_selected = sel,
                numbers = vis,
                numbers_selected = sel,
                modified = vis,
                modified_selected = sel,
                duplicate = vis,
                duplicate_selected = {
                    ctermbg = selbg, ctermfg = selfg, italic = true, bold = true,
                },
                separator = {
                    ctermbg = visbg, ctermfg = bg
                },
                separator_selected = {
                    ctermbg = selbg, ctermfg = bg
                },
                indicator_selected = {
                    ctermbg = selbg
                },
            }
        },
        event = "VimEnter",
    },
    {
        'ojroques/nvim-bufdel',
        config = true,
        keys = {
            { '<leader>J', '<cmd>BufDel<cr>', mode = 'n' }
        },
    },
}
