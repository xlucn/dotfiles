-- Libraries {{{
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")
local config_path = gears.filesystem.get_configuration_dir()
local theme_assets = require("beautiful.theme_assets")
-- }}}

local theme = {}

-- wallpaper {{{
theme.wallpaper = "~/.local/share/backgrounds/wallpaper.jpg"
-- }}}

-- Colorscheme files from wal {{{
local walfile = io.open(os.getenv("HOME") .. "/.cache/wal/colors")
if not walfile then
    walfile = io.open(config_path .. "/colors") -- gruvbox colors here now
end

local colors = {}
for each in walfile:lines() do
  colors[#colors + 1] = each
end

local dark0   = colors[1]
local dark4   = colors[9]
local light0  = colors[8]
local red     = colors[2]
local green   = colors[3]
local yellow  = colors[4]
local blue    = colors[5]
local purple  = colors[6]
local aqua    = colors[7]
-- }}}

-- Basic Colors {{{
theme.bg_normal             = dark0
theme.bg_focus              = dark4
theme.bg_urgent             = purple
theme.bg_minimize           = dark4 .. "60"

theme.fg_normal             = light0
theme.fg_focus              = theme.fg_normal
theme.fg_urgent             = theme.bg_normal
theme.fg_minimize           = dark4
-- }}}

-- Sizes {{{
awesome.set_preferred_icon_size(48)
theme.font                      = "Hack Bold 10"
theme.wibox_height              = dpi(32)
theme.systray_icon_spacing      = dpi(4)
theme.systray_height            = dpi(22)
-- }}}

-- Window {{{
theme.useless_gap               = dpi(24)
theme.border_width              = dpi(0)
theme.border_normal         = theme.bg_normal
theme.border_focus          = yellow
theme.border_marked         = red
theme.titlebar_bg_focus     = theme.bg_normal
-- }}}

-- Taglist {{{
theme.taglist_font                = "Hack Nerd Font 16"
theme.taglist_squares_sel         = gears.surface.load_from_shape (4, 4, gears.shape.rectangle, theme.fg_normal)
theme.taglist_squares_unsel       = gears.surface.load_from_shape (4, 4, gears.shape.rectangle, theme.fg_normal)
theme.nerdfont_browser               = "爵" -- 
theme.nerdfont_terminal              = "" -- 
theme.nerdfont_book                  = "" -- ﴬ
theme.nerdfont_briefcase             = "ﲂ" -- ﴕ
theme.nerdfont_files                 = "" -- 
theme.nerdfont_movie                 = "" -- 輸
theme.nerdfont_email                 = "" -- 
-- }}}

-- Tasklist {{{
theme.tasklist_fg_focus     = theme.fg_focus
theme.tasklist_bg_focus     = dark4
theme.tasklist_bg_minimize  = theme.bg_minimize
theme.tasklist_spacing      = dpi(0)
-- }}}

-- Slider {{{
theme.slider_bar_border_width = 0
theme.slider_handle_border_width = 0
theme.slider_handle_width = 12
theme.slider_handle_shape = gears.shape.circle
theme.slider_handle_color = light0
theme.slider_bar_shape = gears.shape.rounded_rect
theme.slider_bar_height = 3
theme.slider_bar_color = dark4
-- }}}

-- Tooltip {{{
theme.tooltip_align = "top_left"
-- }}}

-- Hotkey {{{
theme.hotkeys_fg               = theme.fg_normal
theme.hotkeys_modifiers_fg     = theme.fg_minimize
-- next three make it a large padding
theme.hotkeys_bg               = theme.bg_normal
theme.hotkeys_border_color     = theme.bg_normal
theme.hotkeys_border_width     = dpi(16)
-- fonts
theme.hotkeys_font             = "Hack Bold 12"
theme.hotkeys_description_font = "Hack 9"
theme.hotkeys_group_margin     = dpi(16)
-- }}}

-- Menu {{{
theme.menu_font                 = "Hack Bold 12"
theme.menu_height               = dpi(32)
theme.menu_width                = dpi(320)
theme.menu_border_color         = theme.bg_normal
theme.menu_border_width         = dpi(4)
theme.menu_fg_normal            = theme.fg_normal
theme.menu_bg_normal            = theme.bg_normal
theme.menu_fg_focus             = theme.fg_normal
theme.menu_bg_focus             = theme.bg_focus
-- }}}

-- Notifications {{{
--theme.notification_shape        = gears.shape.rounded_rect
theme.notification_border_width = dpi(88)
theme.notification_margin   = dpi(88)
theme.notification_border_color = theme.bg_normal
theme.notification_opacity      = 0.8
-- }}}

-- {{{ Icons
-- Layout
theme.layout_tile       = gears.surface.load_from_shape (24, 24, gears.shape.rectangle, yellow)
theme.layout_max        = gears.surface.load_from_shape (24, 24, gears.shape.rectangle, green)
theme.layout_floating   = gears.surface.load_from_shape (24, 24, gears.shape.rectangle, aqua)

-- Titlebar
height = 12
width = height * 2

theme.titlebar_close_button_focus  = gears.surface.load_from_shape (width, height, gears.shape.rectangle, red)
theme.titlebar_close_button_normal = gears.surface.load_from_shape (width, height, gears.shape.rectangle, theme.bg_focus)

theme.titlebar_maximized_button_focus_active    = gears.surface.load_from_shape (width, height, gears.shape.rectangle, green)
theme.titlebar_maximized_button_normal_active   = gears.surface.load_from_shape (width, height, gears.shape.rectangle, theme.bg_focus)
theme.titlebar_maximized_button_focus_inactive  = gears.surface.load_from_shape (width, height, gears.shape.rectangle, green)
theme.titlebar_maximized_button_normal_inactive = gears.surface.load_from_shape (width, height, gears.shape.rectangle, theme.bg_focus)

theme.titlebar_minimize_button_focus  = gears.surface.load_from_shape (width, height, gears.shape.rectangle, yellow)
theme.titlebar_minimize_button_normal = gears.surface.load_from_shape (width, height, gears.shape.rectangle, theme.bg_focus)

theme.titlebar_ontop_button_focus_active    = gears.surface.load_from_shape (width, height, gears.shape.rectangle, blue)
theme.titlebar_ontop_button_normal_active   = gears.surface.load_from_shape (width, height, gears.shape.rectangle, theme.bg_focus)
theme.titlebar_ontop_button_focus_inactive  = gears.surface.load_from_shape (width, height, gears.shape.rectangle, blue .. "60")
theme.titlebar_ontop_button_normal_inactive = gears.surface.load_from_shape (width, height, gears.shape.rectangle, theme.bg_focus)

theme.titlebar_sticky_button_focus_active    = gears.surface.load_from_shape (width, height, gears.shape.rectangle, purple)
theme.titlebar_sticky_button_normal_active   = gears.surface.load_from_shape (width, height, gears.shape.rectangle, theme.bg_focus)
theme.titlebar_sticky_button_focus_inactive  = gears.surface.load_from_shape (width, height, gears.shape.rectangle, purple .. "60")
theme.titlebar_sticky_button_normal_inactive = gears.surface.load_from_shape (width, height, gears.shape.rectangle, theme.bg_focus)

theme.titlebar_floating_button_focus_active    = gears.surface.load_from_shape (width, height, gears.shape.rectangle, aqua)
theme.titlebar_floating_button_normal_active   = gears.surface.load_from_shape (width, height, gears.shape.rectangle, theme.bg_focus)
theme.titlebar_floating_button_focus_inactive  = gears.surface.load_from_shape (width, height, gears.shape.rectangle, aqua .. "60")
theme.titlebar_floating_button_normal_inactive = gears.surface.load_from_shape (width, height, gears.shape.rectangle, theme.bg_focus)

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.fg_normal, theme.bg_normal
)

-- Icon theme
theme.icon_theme = "Papirus"
-- }}}

theme.dark0  = dark0
theme.dark4  = dark4
theme.light0 = light0
theme.red    = red
theme.green  = green
theme.yellow = yellow
theme.blue   = blue
theme.purple = purple
theme.aqua   = aqua

return theme

-- vim:foldmethod=marker:foldlevel=0
