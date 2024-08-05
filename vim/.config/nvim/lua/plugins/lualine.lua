local colors = {
    color0 = 15,
    color1 = 8,
    color3 = 233,
    color4 = 0,
    color5 = 5,
    color6 = 8,
    color7 = 7,
    color10 = 2,
    color13 = 1,
    color14 = 6,
}

local colorscheme = {
  visual = {
    b = { fg = colors.color0, bg = colors.color1 },
    a = { fg = colors.color3, bg = colors.color5, gui = 'bold' },
  },
  inactive = {
    b = { fg = colors.color6, bg = colors.color4 },
    c = { fg = colors.color6, bg = colors.color4 },
    a = { fg = colors.color7, bg = colors.color4, gui = 'bold' },
  },
  insert = {
    b = { fg = colors.color0, bg = colors.color1 },
    a = { fg = colors.color3, bg = colors.color10, gui = 'bold' },
  },
  replace = {
    b = { fg = colors.color0, bg = colors.color1 },
    a = { fg = colors.color3, bg = colors.color13, gui = 'bold' },
  },
  normal = {
    b = { fg = colors.color0, bg = colors.color1 },
    c = { fg = colors.color7, bg = colors.color4 },
    a = { fg = colors.color3, bg = colors.color14, gui = 'bold' },
  },
}

return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons'
        },
        opts = {
            options = {
                theme = colorscheme,
                globalstatus = true,
            },
            -- tabline = {
            --     lualine_a = {
            --         "buffers"
            --     },
            -- },
            sections = {
                lualine_x = {
                    'encoding',
                    {
                        'fileformat',
                        symbols = {
                            unix = 'unix',
                            dos = 'dos',
                            mac = 'mac',
                        }
                    },
                    'filetype'
                }
            }
        },
        event = "VimEnter",
    }
}
