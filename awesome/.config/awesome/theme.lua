local theme = {}

-- Libraries {{{
local gears = require("gears")
local themes_path = gears.filesystem.get_themes_dir()
local dpi = require("beautiful.xresources").apply_dpi
local theme_assets = require("beautiful.theme_assets")
-- }}}

-- Gruvbox color table {{{
-- https://github.com/morhetz/gruvbox-contrib/blob/master/color.table
-- GRUVCOLR     "HEX    " --  ALIAS     RGB
-------------   "-------" -- --------   -----------
local dark0   = "#282828" -- [bg0]       40- 40- 40
local dark1   = "#3c3836" -- [bg1]       60- 56- 54
local dark2   = "#504945" -- [bg2]       80- 73- 69
local dark3   = "#665c54" -- [bg3]      102- 92- 84
local dark4   = "#7c6f64" -- [bg4]      124-111-100

local light0  = "#fbf1c7" -- [fg0]      251-241-199

local red     = "#fb4934" -- [red]      251- 73- 52
local green   = "#b8bb26" -- [green]    184-187- 38
local yellow  = "#fabd2f" -- [yellow]   250-189- 47
local blue    = "#83a598" -- [blue]     131-165-152
local purple  = "#d3869b" -- [purple]   211-134-155
local aqua    = "#8ec07c" -- [aqua]     142-192-124
local orange  = "#fe8019" -- [orange]   254-128- 25
-- }}}

-- Basic Colors {{{
theme.bg_normal             = dark0
theme.bg_focus              = dark2
theme.bg_urgent             = purple
theme.bg_minimize           = theme.bg_normal

theme.fg_normal             = light0
theme.fg_focus              = blue
theme.fg_urgent             = theme.bg_normal
theme.fg_minimize           = dark4
-- }}}

-- wallpaper {{{
theme.wallpaper = "~/.local/share/backgrounds/wallpaper.jpg"
-- }}}

-- Colors {{{
theme.border_normal         = theme.bg_normal
theme.border_focus          = yellow
theme.border_marked         = red
theme.titlebar_bg_focus     = dark3
-- }}}

-- Widget colors {{{
theme.widget_music          = purple
theme.widget_light          = yellow
theme.widget_ram            = blue
theme.widget_ram_high       = birght_red
theme.widget_cpu            = blue
theme.widget_cpu_high       = red
theme.widget_alsa           = yellow
theme.widget_bat_normal     = green
theme.widget_bat_mid        = green
theme.widget_bat_low        = orange
theme.widget_bat_empty      = red
theme.widget_mail_online    = green
theme.widget_mail_offline   = theme.fg_normal
-- }}}

-- Taglist {{{
theme.taglist_font                = "Hack Nerd Font 14"
theme.taglist_squares_sel         = gears.surface.load_from_shape (4, 4, gears.shape.rectangle, red)
theme.taglist_squares_unsel       = gears.surface.load_from_shape (4, 4, gears.shape.rectangle, red)
-- }}}

-- Tasklist {{{
theme.tasklist_fg_focus     = theme.fg_focus
theme.tasklist_bg_focus     = blue
theme.tasklist_bg_minimize  = dark1
theme.tasklist_spacing      = dpi(0)
-- }}}

-- Tooltip {{{
theme.tooltip_align = "top_left"
-- }}}

-- Sizes {{{
-- choose the largest icon size below this size
awesome.set_preferred_icon_size(48)
theme.font                      = "Hack Bold 10"
theme.widgets_nerdfont          = "Hack Nerd Font 12"
theme.wibox_height              = dpi(28)
theme.useless_gap               = dpi(16)
theme.border_width              = dpi(0)
theme.systray_icon_spacing      = dpi(2)
theme.systray_height            = dpi(24)
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

-- example sizes for a progress bar {{{
theme.progressbar_margins       = dpi(1)
theme.progressbar_paddings      = dpi(1)
theme.progressbar_ticks_size    = dpi(4)
theme.progressbar_ticks_gap     = dpi(1)
-- make the progress bar have 10 blocks (or change the number to what you like)
theme.progressbar_width         = dpi(5 * (theme.progressbar_ticks_size +
                                           theme.progressbar_ticks_gap) +
                                      2 * theme.progressbar_margins +
                                      theme.progressbar_paddings)
theme.progressbar_height        = dpi(8)
theme.progressbar_outer_margin  = dpi((theme.wibox_height - 
                                       theme.progressbar_height) / 2)
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
theme.notification_shape        = gears.shape.rounded_rect
theme.notification_border_width = dpi(4)
theme.notification_border_color = theme.bg_normal
-- }}}

-- awesome-wm-widgets widgets colors {{{
theme.widget_main_color  = blue
theme.widget_red         = red
theme.widget_yellow      = yellow
theme.widget_green       = green
theme.widget_black       = dark0
theme.widget_transparent = "#00000000"
-- }}}

-- Nerd Fonts Glyphs For tags {{{
theme.nerdfont_browser               = ""
theme.nerdfont_terminal              = "" --  
theme.nerdfont_book                  = "龎" --   
theme.nerdfont_briefcase             = ""
theme.nerdfont_note                  = "" -- ﴬ
theme.nerdfont_files                 = "" -- 
theme.nerdfont_movie                 = ""
theme.nerdfont_email                 = "" -- 
theme.nerdfont_git                   = "" -- 
-- }}}

-- Nerd Fonts Glyphs For widgets {{{
theme.nerdfont_music                 = ""
theme.nerdfont_music_off             = ""
theme.nerdfont_music_play            = "契" --  
theme.nerdfont_music_pause           = "" -- 
theme.nerdfont_music_stop            = "栗" -- 
theme.nerdfont_music_next            = "" --  
theme.nerdfont_music_prev            = "" --  
theme.nerdfont_music_shuffle_on      = "列" -- 咽
theme.nerdfont_music_shuffle_off     = "劣"
theme.nerdfont_music_repeat_on       = "凌"
theme.nerdfont_music_repeat_off      = "稜"
theme.nerdfont_music_repeat_one      = "綾"
theme.nerdfont_upspeed               = "祝"
theme.nerdfont_downspeed             = ""
theme.nerdfont_brightness            = ""
theme.nerdfont_brightness_low        = ""
theme.nerdfont_brightness_mid        = ""
theme.nerdfont_brightness_high       = ""
theme.nerdfont_bat_unknown           = ""
theme.nerdfont_bat_empty             = ""
theme.nerdfont_bat_low               = ""
theme.nerdfont_bat_mid               = ""
theme.nerdfont_bat_high              = ""
theme.nerdfont_bat_full              = ""
theme.nerdfont_bat_full_charging     = ""
theme.nerdfont_volume_mute           = "婢" -- ﱝ
theme.nerdfont_volume_low            = "奄" -- 
theme.nerdfont_volume_mid            = "奔" -- 
theme.nerdfont_volume_high           = "墳" -- 
theme.nerdfont_memory                = ""
theme.nerdfont_cpu                   = "" --  
theme.nerdfont_wifi_on               = "直"
theme.nerdfont_wifi_off              = "睊"
theme.nerdfont_ethernet              = ""
-- }}}

-- {{{ Icons
-- {{{ Layout
theme.layout_tile       = themes_path .. "zenburn/layouts/tile.png"
theme.layout_tileleft   = themes_path .. "zenburn/layouts/tileleft.png"
theme.layout_tilebottom = themes_path .. "zenburn/layouts/tilebottom.png"
theme.layout_tiletop    = themes_path .. "zenburn/layouts/tiletop.png"
theme.layout_fairv      = themes_path .. "zenburn/layouts/fairv.png"
theme.layout_fairh      = themes_path .. "zenburn/layouts/fairh.png"
theme.layout_spiral     = themes_path .. "zenburn/layouts/spiral.png"
theme.layout_dwindle    = themes_path .. "zenburn/layouts/dwindle.png"
theme.layout_max        = themes_path .. "zenburn/layouts/max.png"
theme.layout_fullscreen = themes_path .. "zenburn/layouts/fullscreen.png"
theme.layout_magnifier  = themes_path .. "zenburn/layouts/magnifier.png"
theme.layout_floating   = themes_path .. "zenburn/layouts/floating.png"
theme.layout_cornernw   = themes_path .. "zenburn/layouts/cornernw.png"
theme.layout_cornerne   = themes_path .. "zenburn/layouts/cornerne.png"
theme.layout_cornersw   = themes_path .. "zenburn/layouts/cornersw.png"
theme.layout_cornerse   = themes_path .. "zenburn/layouts/cornerse.png"
-- }}}

-- {{{ Titlebar
titlebar_button_height = 12
titlebar_button_width = titlebar_button_height * 2

theme.titlebar_close_button_focus  = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, red)
theme.titlebar_close_button_normal = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, theme.bg_focus)

theme.titlebar_maximized_button_focus_active    = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, green)
theme.titlebar_maximized_button_normal_active   = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, theme.bg_focus)
theme.titlebar_maximized_button_focus_inactive  = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, green)
theme.titlebar_maximized_button_normal_inactive = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, theme.bg_focus)

theme.titlebar_minimize_button_focus  = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, yellow)
theme.titlebar_minimize_button_normal = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, theme.bg_focus)

theme.titlebar_ontop_button_focus_active    = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, blue)
theme.titlebar_ontop_button_normal_active   = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, theme.bg_focus)
theme.titlebar_ontop_button_focus_inactive  = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, blue)
theme.titlebar_ontop_button_normal_inactive = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, theme.bg_focus)

theme.titlebar_sticky_button_focus_active    = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, purple)
theme.titlebar_sticky_button_normal_active   = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, theme.bg_focus)
theme.titlebar_sticky_button_focus_inactive  = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, purple)
theme.titlebar_sticky_button_normal_inactive = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, theme.bg_focus)

theme.titlebar_floating_button_focus_active    = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, aqua)
theme.titlebar_floating_button_normal_active   = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, theme.bg_focus)
theme.titlebar_floating_button_focus_inactive  = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, aqua)
theme.titlebar_floating_button_normal_inactive = gears.surface.load_from_shape (titlebar_button_width, titlebar_button_height, gears.shape.rectangle, theme.bg_focus)
-- }}}

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, blue, theme.bg_normal
)

-- Icon theme
theme.icon_theme = "Papirus"
-- }}}

return theme

-- vim:foldmethod=marker:foldlevel=0
