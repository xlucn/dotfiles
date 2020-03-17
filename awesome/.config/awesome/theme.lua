-- Libraries {{{
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi
-- my local config
local config = require("config")
-- }}}

local theme = {}

-- helper function {{{
local function fg(color, text)
    return string.format("<span foreground='%s'>%s</span>", color, text)
end
-- }}}

-- Colorscheme files from Xresources {{{
local xresources_theme = beautiful.xresources.get_current_theme()
theme.dark   = xresources_theme.color0
theme.red    = xresources_theme.color1
theme.green  = xresources_theme.color2
theme.yellow = xresources_theme.color3
theme.blue   = xresources_theme.color4
theme.purple = xresources_theme.color5
theme.cyan   = xresources_theme.color6
theme.light  = xresources_theme.color7
theme.grey   = xresources_theme.color8
theme.fg     = xresources_theme.foreground
theme.bg     = xresources_theme.background
-- }}}

-- Basic Colors {{{
theme.bg_normal             = theme.bg
theme.bg_focus              = theme.grey
theme.bg_urgent             = theme.purple
theme.bg_minimize           = theme.red
theme.fg_normal             = theme.fg
theme.fg_focus              = theme.fg
theme.fg_urgent             = theme.bg
theme.fg_minimize           = theme.grey
-- }}}

-- wallpaper {{{
local wallpaper = gears.filesystem.get_xdg_data_home() .. "backgrounds/wallpaper.jpg"
if gears.filesystem.file_readable(wallpaper) then
    theme.wallpaper = wallpaper
else
    theme.wallpaper = theme.grey
end
-- }}}

-- Sizes {{{
theme.preferred_icon_size       = dpi(48)
theme.wibox_height              = dpi(48)
theme.systray_icon_spacing      = dpi(8)
theme.systray_height            = dpi(24)
-- }}}

-- Fonts {{{
theme.fontname                 = config.fontname
theme.font                     = theme.fontname .. " 11"
theme.taglist_font             = theme.fontname .. " 18"
theme.tooltip_font             = theme.fontname .. " 12"
theme.hotkeys_font             = theme.fontname .. " 14"
theme.hotkeys_description_font = theme.fontname .. " 11"
theme.menu_font                = theme.fontname .. " 12"
-- }}}

-- Window {{{
theme.useless_gap           = dpi(8)
theme.gap_single_client     = false
theme.border_width          = dpi(0)
theme.border_normal         = theme.bg_normal
theme.border_focus          = theme.bg_focus
theme.border_marked         = theme.bg_urgent
theme.titlebar_bg           = theme.fg_normal
theme.titlebar_fg           = theme.bg_normal
-- }}}

-- Taglist {{{
theme.taglist_bg_focus = theme.bg_focus
theme.taglist_squares_sel   = gears.surface.load_from_shape (2, theme.wibox_height, gears.shape.rectangle, theme.blue)
theme.taglist_squares_unsel = gears.surface.load_from_shape (2, theme.wibox_height, gears.shape.rectangle, theme.blue)
theme.taglist_textmargin = dpi(8)
theme.button_textmargin = dpi(4)
theme.button_imagemargin = dpi(8)
-- }}}

-- Tasklist {{{
theme.tasklist_bg_normal    = theme.bg_normal
theme.tasklist_fg_focus     = theme.fg_focus
theme.tasklist_bg_focus     = theme.blue
theme.tasklist_bg_minimize  = theme.bg_minimize
theme.tasklist_spacing      = dpi(0)
theme.tasklist_icon_vmargin = dpi(16)
theme.tasklist_icon_margin  = dpi(4)
-- }}}

-- Slider and progressbar {{{
theme.slider_bar_border_width = 0
theme.slider_handle_border_width = 0
theme.slider_handle_border_color = theme.blue
theme.slider_handle_width = dpi(24)
theme.slider_handle_shape = gears.shape.circle
theme.slider_handle_color = theme.light
theme.slider_bar_shape = gears.shape.rounded_bar
theme.slider_bar_height = dpi(6)
theme.slider_bar_color = theme.grey
theme.progressbar_bg = theme.grey
theme.progressbar_fg = theme.fg_normal
theme.progressbar_shape = gears.shape.rounded_bar
theme.progressbar_border_width = 0
theme.progressbar_bar_shape = gears.shape.rectangle
theme.progressbar_bar_border_width = 0
-- theme.progressbar_bar_border_color
-- theme.progressbar_margins
-- theme.progressbar_paddings
-- }}}

-- Tooltip {{{
theme.tooltip_align = "top_left"
theme.tooltip_shape = gears.shape.rounded_rect
theme.tooltip_marginv = dpi(16)
theme.tooltip_marginh = dpi(8)
-- }}}

-- Hotkey {{{
theme.hotkeys_fg               = theme.fg_normal
theme.hotkeys_bg               = theme.bg_normal
theme.hotkeys_modifiers_fg     = theme.fg_minimize
theme.hotkeys_border_color     = theme.bg_normal
theme.hotkeys_border_width     = dpi(16)
theme.hotkeys_group_margin     = dpi(16)
-- }}}

-- Icons related functions {{{
local function find_symbolic_icon_in_dir(dir, name)
    if not gears.filesystem.dir_readable(dir) then return nil end

    local theme_file = dir .. "/index.theme"
    if not gears.filesystem.file_readable(theme_file) then return nil end

    for line in io.lines(theme_file) do
        local sub_dirs = line:match('^Directories=(.+)');
        if sub_dirs then
            for sub_dir in string.gmatch(sub_dirs, '([^,%s]+)') do
                if string.find(sub_dir, "symbolic") or
                    string.find(sub_dir, "scalable") then
                    local icon_file = string.format("%s/%s/%s.svg", dir, sub_dir, name)
                    if gears.filesystem.file_readable(icon_file) then
                        return icon_file
                    end
                end
            end
        end
    end
end
local function find_symbolic_icon(icon_name)
    if icon_name == nil then return nil end
    if not icon_name:find("symbolic") then
        icon_name = icon_name .. "-symbolic"
    end
    -- naughty.notify { text = "finding " .. icon_name }
    local data_dirs = { gears.filesystem.get_xdg_data_home(),
                        table.unpack(gears.filesystem.get_xdg_data_dirs()) }
    local icon_themes = { config.icon_theme, "Adwaita", "hicolor" }
    for _, data_dir in ipairs(data_dirs) do
        for _, icon_theme in ipairs(icon_themes) do
            local icon_theme_dir = string.format("%s/icons/%s", data_dir, icon_theme)
            local icon = find_symbolic_icon_in_dir(icon_theme_dir, icon_name)
            if icon then
                return icon
            end
        end
    end
end
local function add_icon_to_theme(icon_table, theme_table)
    for k, v in pairs(icon_table) do
        if type(v) == "table" and (type(v[1]) ~= "string") then
            theme_table[k] = {}
            add_icon_to_theme(v, theme_table[k])
        else
            theme_table[k] = { v[1], find_symbolic_icon(v[2]), v[3], v[4] }
        end
    end
end
-- }}}

-- Icons {{{
-- The icons are used only by *icon_button* function in widgets.lua
-- The table elements are
--  1: Font character.
--  2: Icon name, default to symbolic icons "icon_name_symbolic.svg".
--  3: Font margin fix, applied to right margin, optional.
--     Specify this if the character is not center aligned.
--  4: Icon margin fix, applied to all margins on top of button_imagemargin, optional.
--     Specify this if the icon is too large.
-- The tables are passed to add_icon_to_theme function only to replace the
--     second element to the corresponding icon path
add_icon_to_theme({
        layout_floating = { "穀", "view-restore" },
        layout_tile = { "﬿", "view-grid" },
        layout_max = { "", "view-fullscreen" },

        menuicon = { "", "view-app-grid" }, -- start-here
        sidebar_open = { "", "pan-end" }, -- 
        sidebar_close = { "", "pan-start" },
        closebutton = { "", "window-close" },
        newterm = { "樂", "list-add", nil, 8 },

        nerdfont_music = { "", "audio-x-generic" },
        nerdfont_music_state = { -- state is opposite to action
            play  = { "", "media-playback-pause" },
            pause = { "契", "media-playback-start" },
            stop  = { "栗", "media-playback-stop" },
        },
        nerdfont_music_next = { "怜", "media-skip-forward" },
        nerdfont_music_prev = { "玲", "media-skip-backward" },
        nerdfont_music_forward = { "淪", "media-seek-forward" },
        nerdfont_music_backward = { "倫", "media-seek-backward" },
        nerdfont_music_random_on = { "列", "media-playlist-shuffle" },
        nerdfont_music_random_off = { "劣", "media-playlist-consecutive" },
        nerdfont_music_repeat_on = { "凌", "media-playlist-repeat" },
        nerdfont_music_repeat_one = { "綾", "media-playlist-repeat-one" },

        nerdfont_volume_mute = { "ﱝ", "audio-volume-muted" },
        nerdfont_volume_low = { "奄", "audio-volume-low" },
        nerdfont_volume_mid = { "奔", "audio-volume-medium" },
        nerdfont_volume_high = { "墳", "audio-volume-high" },

        nerdfont_brightness = { "", "display-brightness", 8 }, -- ﯦ
        nerdfont_memory = { "", "", 4 },
        nerdfont_cpu = { "異", "" }, --   --

        nerdfont_batteries = {
            { fg(theme.red,    ""), "battery-level-0" },
            { fg(theme.red,    ""), "battery-level-10" },
            { fg(theme.yellow, ""), "battery-level-20" },
            {                  "",  "battery-level-30" },
            {                  "",  "battery-level-40" },
            {                  "",  "battery-level-50" },
            {                  "",  "battery-level-60" },
            {                  "",  "battery-level-70" },
            {                  "",  "battery-level-80" },
            {                  "",  "battery-level-90" },
            {                  "",  "battery-level-100" },
        },
        nerdfont_batteries_charging = {
            { fg(theme.red,    ""), "battery-level-0-charging"  }, -- 20 icon
            { fg(theme.red,    ""), "battery-level-10-charging" }, -- 20 icon
            { fg(theme.yellow, ""), "battery-level-20-charging" },
            {                  "",  "battery-level-30-charging" },
            {                  "",  "battery-level-40-charging" }, -- 30 icon
            {                  "",  "battery-level-50-charging" }, -- 40 icon
            {                  "",  "battery-level-60-charging" },
            {                  "",  "battery-level-70-charging" }, -- 60 icon
            {                  "",  "battery-level-80-charging" },
            {                  "",  "battery-level-90-charging" },
            {                  "",  "battery-level-100-charged" },
        },
        nerdfont_battery_charging = { "", "battery-charging" },
        nerdfont_battery_unknown = { "", "battery-missing" },
        nerdfont_upspeed = { "祝", "go-up" },
        nerdfont_downspeed = { "", "go-down" },

        nerdfont_wireless = { "直", "network-wireless", 8 },
        nerdfont_wireless_off = { fg(theme.fg_normal .. "40", "直", 8),
                                  "network-wireless-offline" },
        nerdfont_wired = { "", "network-wired" },
        nerdfont_wired_off = { fg(theme.fg_normal .. "40", ""),
                               "network-wired-offline" },

        nerdfont_email_unread = { "", "mail-unread", 4 },
        nerdfont_email_read = { "", "mail-read", 4 },
        nerdfont_browser  = { "爵", "web-browser" },
        nerdfont_terminal = { "", "utilities-terminal" },
        nerdfont_book     = { "", "accessories-text-editor" },
        nerdfont_work     = { "ﲂ", "applications-science" },
        nerdfont_files    = { "", "folder" }, -- 
        nerdfont_movie    = { "ﱘ", "applications-multimedia" },
        nerdfont_email    = { "", "mail-unread" },
    },
    theme
)

theme.tag_icons = {
    theme.nerdfont_terminal,
    theme.nerdfont_browser,
    theme.nerdfont_book,
    theme.nerdfont_work,
    theme.nerdfont_files,
    theme.nerdfont_movie,
    theme.nerdfont_email,
    theme.nerdfont_terminal,
    theme.nerdfont_terminal
}
-- Icon theme
theme.icon_theme = config.icon_theme
-- Icon size
awesome.set_preferred_icon_size(theme.preferred_icon_size)
-- }}}

-- Titlebar buttons {{{
theme.titlebar_font = theme.fontname .. " 12"
theme.titlebar_height = dpi(32)

local function button(color)
    local height = theme.titlebar_height
    local width = theme.titlebar_height
    local shape = gears.shape.circle
    return gears.surface.load_from_shape (width, height, shape, color)
end

local button_colors = {
    close = theme.red,
    maximized = theme.green,
    minimize = theme.yellow,
    ontop = theme.blue,
    sticky = theme.purple,
    floating = theme.cyan
}

-- naming: titlebar_<name>_button_(focos|normal)_(active|inactive)[_(hover|press)]
for b, c in pairs(button_colors) do
    for _, f in ipairs({"focus", "normal"}) do
        for _, a in ipairs({"_active", "_inactive"}) do
            for _, h in ipairs({"", "_hover", "_press"}) do
                a = (b == "close" or b == "minimize") and "" or a
                local button_name = string.format("titlebar_%s_button_%s%s%s", b, f, a, h)
                if theme[button_name] == nil then
                    if h == "_hover" then
                        theme[button_name] = button(c .. "FF")
                    elseif h == "_press" then
                        theme[button_name] = button(c .. "E8")
                    elseif f == "normal" then
                        theme[button_name] = button(theme.bg_focus)
                    elseif a == "_inactive" then
                        theme[button_name] = button(theme.bg_focus)
                    else
                        theme[button_name] = button(c .. "D0")
                    end
                end
            end
        end
    end
end
-- }}}

-- Notifications {{{
naughty.config.padding = dpi(8)
naughty.config.spacing = dpi(8)
naughty.config.defaults.margin       = dpi(16)
naughty.config.defaults.timeout      = 10
naughty.config.defaults.border_width = 0
naughty.config.defaults.font         = theme.fontname .. " Bold 12"
naughty.config.defaults.icon_size    = 48
naughty.config.defaults.shape        = gears.shape.rounded_rect
naughty.config.defaults.opacity      = 0.8
naughty.config.defaults.bg           = theme.grey
-- }}}

return theme

-- vim:foldmethod=marker:foldlevel=0
