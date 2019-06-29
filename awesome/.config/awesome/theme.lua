local theme = {}

-- Gruvbox color table {{{
-- https://github.com/morhetz/gruvbox-contrib/blob/master/color.table
--    GRUVCOLR         "HEX    " -- RELATV ALIAS   TERMCOLOR      RGB           ITERM RGB     OSX HEX
-------------------    "-------" -- ------------   ------------   -----------   -----------   -------
local dark0_hard     = "#1d2021" -- [   ]  [   ]   234 [h0][  ]    29- 32- 33    22- 24- 25   #161819
local dark0          = "#282828" -- [bg0]  [fg0]   235 [ 0][  ]    40- 40- 40    30- 30- 30   #1e1e1e
local dark0_soft     = "#32302f" -- [   ]  [   ]   236 [s0][  ]    50- 48- 47    38- 36- 35   #262423
local dark1          = "#3c3836" -- [bg1]  [fg1]   237 [  ][15]    60- 56- 54    46- 42- 41   #2e2a29
local dark2          = "#504945" -- [bg2]  [fg2]   239 [  ][  ]    80- 73- 69    63- 57- 53   #3f3935
local dark3          = "#665c54" -- [bg3]  [fg3]   241 [  ][  ]   102- 92- 84    83- 74- 66   #534a42
local dark4          = "#7c6f64" -- [bg4]  [fg4]   243 [  ][ 7]   124-111-100   104- 92- 81   #685c51

local gray_245       = "#928374" -- [gray] [   ]   245 [ 8][  ]   146-131-116   127-112- 97   #7f7061
local gray_244       = "#928374" -- [   ] [gray]   244 [  ][ 8]   146-131-116   127-112- 97   #7f7061

local light0_hard    = "#f9f5d7" -- [   ]  [   ]   230 [  ][h0]   249-245-215   248-244-205   #f8f4cd
local light0         = "#fbf1c7" -- [fg0]  [bg0]   229 [  ][ 0]   251-241-199   250-238-187   #faeebb
local light0_soft    = "#f2e5bc" -- [   ]  [   ]   228 [  ][s0]   242-229-188   239-223-174   #efdfae
local light1         = "#ebdbb2" -- [fg1]  [bg1]   223 [15][  ]   235-219-178   230-212-163   #e6d4a3
local light2         = "#d5c4a1" -- [fg2]  [bg2]   250 [  ][  ]   213-196-161   203-184-144   #cbb890
local light3         = "#bdae93" -- [fg3]  [bg3]   248 [  ][  ]   189-174-147   175-159-129   #af9f81
local light4         = "#a89984" -- [fg4]  [bg4]   246 [ 7][  ]   168-153-132   151-135-113   #978771

local bright_red     = "#fb4934" -- [red]   [  ]   167 [ 9][  ]   251- 73- 52   247- 48- 40   #f73028
local bright_green   = "#b8bb26" -- [green] [  ]   142 [10][  ]   184-187- 38   170-176- 30   #aab01e
local bright_yellow  = "#fabd2f" -- [yellow][  ]   214 [11][  ]   250-189- 47   247-177- 37   #f7b125
local bright_blue    = "#83a598" -- [blue]  [  ]   109 [12][  ]   131-165-152   113-149-134   #719586
local bright_purple  = "#d3869b" -- [purple][  ]   175 [13][  ]   211-134-155   199-112-137   #c77089
local bright_aqua    = "#8ec07c" -- [aqua]  [  ]   108 [14][  ]   142-192-124   125-182-105   #7db669
local bright_orange  = "#fe8019" -- [orange][  ]   208 [  ][  ]   254-128- 25   251-106- 22   #fb6a16

local neutral_red    = "#cc241d" -- [   ]  [   ]   124 [ 1][ 1]   204- 36- 29   190- 15- 23   #be0f17
local neutral_green  = "#98971a" -- [   ]  [   ]   106 [ 2][ 2]   152-151- 26   134-135- 21   #868715
local neutral_yellow = "#d79921" -- [   ]  [   ]   172 [ 3][ 3]   215-153- 33   204-136- 26   #cc881a
local neutral_blue   = "#458588" -- [   ]  [   ]    66 [ 4][ 4]    69-133-136    55-115-117   #377375
local neutral_purple = "#b16286" -- [   ]  [   ]   132 [ 5][ 5]   177- 98-134   160- 75-115   #a04b73
local neutral_aqua   = "#689d6a" -- [   ]  [   ]    72 [ 6][ 6]   104-157-106    87-142- 87   #578e57
local neutral_orange = "#d65d0e" -- [   ]  [   ]   166 [  ][  ]   214- 93- 14   202- 72- 14   #ca480e

local faded_red      = "#9d0006" -- [   ]   [red]   88 [  ][ 9]   157-  0-  6   137-  0-  9   #890009
local faded_green    = "#79740e" -- [   ] [green]  100 [  ][10]   121-116- 14   102- 98- 13   #66620d
local faded_yellow   = "#b57614" -- [   ][yellow]  136 [  ][11]   181-118- 20   165- 99- 17   #a56311
local faded_blue     = "#076678" -- [   ]  [blue]   24 [  ][12]     7-102-120    14- 83-101   #0e5365
local faded_purple   = "#8f3f71" -- [   ][purple]   96 [  ][13]   143- 63-113   123- 43- 94   #7b2b5e
local faded_aqua     = "#427b58" -- [   ]  [aqua]   66 [  ][14]    66-123- 88    53-106- 70   #356a46
local faded_orange   = "#af3a03" -- [   ][orange]  130 [  ][  ]   175- 58- 3    157- 40- 7    #9d2807
-- }}}

-- Libraries {{{
local gears = require("gears")
local themes_path = gears.filesystem.get_themes_dir()
local config_path = gears.filesystem.get_configuration_dir()
local dpi = require("beautiful.xresources").apply_dpi
local theme_assets = require("beautiful.theme_assets")
-- }}}

-- Basic Colors {{{
theme.blue                  = neutral_blue
theme.red                   = neutral_red
theme.bg_normal             = dark0
theme.bg_focus              = dark2 -- neutral_blue
theme.bg_urgent             = bright_purple
theme.bg_minimize           = theme.bg_normal

theme.fg_normal             = light0
theme.fg_focus              = neutral_blue
theme.fg_urgent             = theme.bg_normal
theme.fg_minimize           = gray_244
-- }}}

-- wallpaper {{{
--theme.wallpaper = themes_path .. "zenburn/zenburn-background.png"
gears.wallpaper.set(dark2)
-- }}}

-- Colors {{{
theme.border_normal         = theme.bg_normal
theme.border_focus          = dark1
theme.border_marked         = neutral_red
theme.titlebar_bg_focus     = theme.bg_normal
-- }}}

-- Widget colors {{{
theme.widget_music          = bright_purple
theme.widget_light          = bright_yellow
theme.widget_ram            = bright_blue
theme.widget_ram_high       = birght_red
theme.widget_cpu            = bright_blue
theme.widget_cpu_high       = birght_red
theme.widget_alsa           = bright_yellow
theme.widget_bat_normal     = bright_green
theme.widget_bat_mid        = bright_orange
theme.widget_bat_low        = bright_red
-- }}}

-- Taglist {{{
theme.taglist_font          = "Hack Nerd Font 14"
theme.taglist_squares_sel   = nil
theme.taglist_squares_unsel = nil
theme.taglist_fg_empty      = theme.fg_normal
theme.taglist_bg_empty      = theme.bg_normal -- dark1
theme.taglist_fg_occupied   = neutral_orange -- theme.fg_focus
theme.taglist_bg_occupied   = theme.bg_normal -- dark1
theme.taglist_fg_focus      = neutral_orange -- theme.fg_focus
theme.taglist_bg_focus      = faded_blue
-- }}}

-- Tasklist {{{
theme.tasklist_fg_focus     = theme.fg_focus
theme.tasklist_bg_focus     = neutral_aqua
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
--theme.useless_gap               = dpi(16)
theme.border_width              = dpi(0)
theme.systray_icon_spacing      = dpi(0)
-- }}}

-- Hotkey {{{
theme.hotkeys_fg               = theme.fg_normal
theme.hotkeys_modifiers_fg     = theme.fg_minimize
-- next three make it a large padding
theme.hotkeys_bg               = theme.bg_normal
theme.hotkeys_border_color     = theme.bg_normal
theme.hotkeys_border_width     = dpi(16)
-- fonts
theme.hotkeys_font             = "Hack Bold 11"
theme.hotkeys_description_font = "Hack 9"
theme.hotkeys_group_margin     = dpi(24)
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
theme.titlebar_close_button_focus  = themes_path .. "zenburn/titlebar/close_focus.png"
theme.titlebar_close_button_normal = themes_path .. "zenburn/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = themes_path .. "zenburn/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "zenburn/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path .. "zenburn/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = themes_path .. "zenburn/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = themes_path .. "zenburn/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "zenburn/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path .. "zenburn/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = themes_path .. "zenburn/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = themes_path .. "zenburn/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = themes_path .. "zenburn/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = themes_path .. "zenburn/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = themes_path .. "zenburn/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = themes_path .. "zenburn/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "zenburn/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path .. "zenburn/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = themes_path .. "zenburn/titlebar/maximized_normal_inactive.png"

theme.titlebar_minimize_button_focus  = config_path .. "icons/titlebar/minimize_focus.png"
theme.titlebar_minimize_button_normal = config_path .. "icons/titlebar/minimize_normal.png"
-- }}}

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, bright_blue, theme.bg_normal
)

-- Icon theme
theme.icon_theme = "Papirus"
-- }}}

return theme

-- vim:foldmethod=marker:foldlevel=0
