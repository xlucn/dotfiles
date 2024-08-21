local white = 15
local black = 233
local fill_bg = 0
local sel_bg = 6
local vis_bg = 7
local norm_bg = 233

local bg = { ctermbg = fill_bg }
local sel = { ctermbg = sel_bg, ctermfg = black }
local vis = { ctermbg = vis_bg, ctermfg = black }
local norm = { ctermbg = norm_bg, ctermfg = white }
local sel_sep = { ctermbg = sel_bg, ctermfg = fill_bg }
local vis_sep = { ctermbg = vis_bg, ctermfg = fill_bg }
local norm_sep = { ctermbg = norm_bg, ctermfg = fill_bg }

return {
    {
        'akinsho/bufferline.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            options = {
                color_icons = false,
                numbers = "ordinal",
                right_mouse_command = false,
                show_buffer_icons = false,
                max_name_length = 30,
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
                fill = bg,
                background = norm,
                buffer_visible = vis,
                buffer_selected = sel,
                close_button = norm,
                close_button_visible = vis,
                close_button_selected = sel,
                numbers = norm,
                numbers_visible = vis,
                numbers_selected = sel,
                modified = norm,
                modified_visible = vis,
                modified_selected = sel,
                duplicate = norm,
                duplicate_visible = vis,
                duplicate_selected = sel,
                separator = norm_sep,
                separator_visible = vis_sep,
                separator_selected = sel_sep,
            }
        },
        event = "VimEnter",
    },
    {
        'ojroques/nvim-bufdel',
        config = true,
        keys = {
            { '<leader>d', '<cmd>BufDel<cr>', mode = 'n', desc = 'Delete buffer' }
        },
    },
}
