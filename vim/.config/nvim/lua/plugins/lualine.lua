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

local colorscheme = {
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

return {
    {
        'nvim-lualine/lualine.nvim',
        event = { 'UIEnter' },
        dependencies = {
            'nvim-tree/nvim-web-devicons'
        },
        opts = {
            options = {
                theme = colorscheme,
            },
        },
    }
}
