M = {}

local sep_fg = 7
local fill_bg = 8
local sel_bg = 'NONE'
local sel_fg = 6
local vis_bg = 8
local vis_fg = 6
local norm_bg = 8
local norm_fg = 15

local bg = { ctermbg = fill_bg, ctermfg = 'NONE' }
local sel = { ctermbg = sel_bg, ctermfg = sel_fg }
local vis = { ctermbg = vis_bg, ctermfg = vis_fg }
local norm = { ctermbg = norm_bg, ctermfg = norm_fg }
local sel_sep = { ctermbg = sel_bg, ctermfg = sep_fg }
local vis_sep = { ctermbg = vis_bg, ctermfg = sep_fg }
local norm_sep = { ctermbg = norm_bg, ctermfg = sep_fg }

M.bufferline_highlights = {
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
    indicator_visible = vis,
    indicator_selected = sel,
    separator = norm_sep,
    separator_visible = vis_sep,
    separator_selected = sel_sep,
}

local colors = {
    white = 15,
    grey = 7,
    dark = 8,
    black = 237,
    red = 1,
    green = 2,
    magenta = 5,
    cyan = 6,
}

M.lualine_colorscheme = {
  visual = {
    b = { fg = colors.white, bg = colors.dark },
    a = { fg = colors.black, bg = colors.magenta, gui = 'bold' },
  },
  inactive = {
    b = { fg = colors.dark, bg = colors.black },
    c = { fg = colors.dark, bg = colors.black },
    a = { fg = colors.grey, bg = colors.black, gui = 'bold' },
  },
  insert = {
    b = { fg = colors.white, bg = colors.dark },
    a = { fg = colors.black, bg = colors.green, gui = 'bold' },
  },
  replace = {
    b = { fg = colors.white, bg = colors.dark },
    a = { fg = colors.black, bg = colors.red, gui = 'bold' },
  },
  normal = {
    b = { fg = colors.white, bg = colors.dark },
    c = { fg = colors.grey, bg = colors.black },
    a = { fg = colors.black, bg = colors.cyan, gui = 'bold' },
  },
}

return M
