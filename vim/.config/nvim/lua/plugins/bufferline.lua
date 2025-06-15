local sep_fg = 7
local fill_bg = 8
local sel_bg = 'NONE'
local sel_fg = 6
local vis_bg = 'lightgray'
local vis_fg = 'black'
local norm_bg = 8
local norm_fg = 'white'

local bg = { ctermbg = fill_bg, ctermfg = 'NONE' }
local sel = { ctermbg = sel_bg, ctermfg = sel_fg }
local vis = { ctermbg = vis_bg, ctermfg = vis_fg }
local norm = { ctermbg = norm_bg, ctermfg = norm_fg }
local sel_sep = { ctermbg = sel_bg, ctermfg = sep_fg }
local vis_sep = { ctermbg = vis_bg, ctermfg = sep_fg }
local norm_sep = { ctermbg = norm_bg, ctermfg = sep_fg }

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
