-- luacheck: globals awesome
-- Libraries {{{
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi
-- my local config
local config = require("config")
-- }}}

local theme = {}

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
theme.preferred_icon_size   = dpi(48)
theme.bar_size              = dpi(config.bar_size)
theme.systray_icon_spacing  = dpi(8)
theme.systray_icon_size     = dpi(24)
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
theme.border_width          = dpi(0)
theme.border_normal         = theme.bg_normal
theme.border_focus          = theme.bg_focus
theme.border_marked         = theme.bg_urgent
-- }}}

-- Taglist {{{
theme.taglist_bg_focus = theme.bg_focus
theme.taglist_squares_sel   = gears.surface.load_from_shape (2, theme.bar_size, gears.shape.rectangle, theme.blue)
theme.taglist_squares_unsel = gears.surface.load_from_shape (2, theme.bar_size, gears.shape.rectangle, theme.blue)
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
theme.slider_handle_width = 0
theme.slider_bar_shape = gears.shape.rounded_bar
theme.slider_bar_height = dpi(24)
theme.slider_bar_color = theme.grey
theme.slider_bar_active_color = theme.fg_normal
theme.slider_bar_margins = 12 -- { top = 12, bottom = 12 }
theme.progressbar_bg = theme.grey
theme.progressbar_fg = theme.fg_normal
theme.progressbar_shape = gears.shape.rounded_bar
theme.progressbar_border_width = 0
theme.progressbar_bar_shape = gears.shape.rectangle
theme.progressbar_bar_border_width = 0
theme.progressbar_margins = 12
-- theme.progressbar_paddings
-- }}}

-- Tooltip {{{
theme.tooltip_align = "top_left"
theme.tooltip_shape = gears.shape.rectangle
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
            theme_table[k] = v
            theme_table[k][2] = find_symbolic_icon(v[2])
        end
    end
end
-- }}}

-- Icons {{{
-- Icon theme
theme.icon_theme = config.icon_theme
-- Icon size
awesome.set_preferred_icon_size(theme.preferred_icon_size)
-- The icons are used only by *icon_button* function in widgets.lua
-- The table elements are
--  1: Font character.
--  2: Icon name, default to symbolic icons "icon_name_symbolic.svg".
--  font_margin:
--     Font margin fix, applied to right margin, optional.
--     Specify this if the character is not center aligned.
--     Note: Nerd Font need this fix but "Material Design Icons" does not, I might remove this
--     in favour of the latter font.
--  image_margin:
--     Icon margin fix, applied to all margins on top of button_imagemargin, optional.
--     Specify this if the icon is too large.
--     Note: the mdi font seem great, maybe I will remove svg icons, too?
--  color:
--     change color for font character, svg image does not support this
-- The tables are passed to add_icon_to_theme function only to replace the
--     second element to the corresponding icon path
add_icon_to_theme({
        layout_floating       = { "󰕕", "focus-windows" },
        layout_tile           = { "󰙀", "view-grid" },
        layout_max            = { "󰄮", "zoom-fit-best" },

        menuicon              = { "󰀻", "view-app-grid" }, -- start-here
        sidebar_open          = { "󰄾", "pan-end" },
        sidebar_close         = { "󰄽", "pan-start" },
        closebutton           = { "󰅖", "window-close", image_margin = 4 },
        newterm               = { "󰐕", "list-add", image_margin = 8 },
        icon_tray = { [true]  = { "󰅀", "pan-down" },
                      [false] = { "󰅃", "pan-up" } },

        icon_music            = { "󰎇", "audio-x-generic" },
        icon_music_state      = { -- state is opposite to action(in icon name)
            play              = { "󰏤", "media-playback-pause" },
            pause             = { "󰐊", "media-playback-start" },
            stop              = { "󰓛", "media-playback-stop" } },
        icon_music_next       = { "󰒭", "media-skip-forward" },
        icon_music_prev       = { "󰒮", "media-skip-backward" },
        icon_music_forward    = { "󰶻", "media-seek-forward" },
        icon_music_backward   = { "󰶺", "media-seek-backward" },
        icon_music_random     = {
            [true]            = { "󰒝", "media-playlist-shuffle" },
            [false]           = { "󰒞", "media-playlist-consecutive" } },
        icon_music_repeat     = {
            [true]            = { "󰑖", "media-playlist-repeat" },
            [false]           = { "󰑘", "media-playlist-repeat-one" } },

        icon_volume_mute      = { "󰝟", "audio-volume-muted" },
        icon_volume_low       = { "󰕿", "audio-volume-low", font_margin = 10 },
        icon_volume_mid       = { "󰖀", "audio-volume-medium", font_margin = 6 },
        icon_volume_high      = { "󰕾", "audio-volume-high" },
        icon_volume_stack     = { "󰕾", "audio-volume-high", color = theme.fg .. "40" },

        icon_brightness       = { "󰃟", "display-brightness" },
        icon_memory           = { "󰍛", "media-floppy" },
        icon_cpu              = { "󰑣", "utilities-system-monitor" },
        icon_disk             = { "󰋊", "drive-harddisk" },

        icon_battery          = {{"󰂎", "battery-level-0", color = theme.red },
                                { "󰁺", "battery-level-10", color = theme.red },
                                { "󰁻", "battery-level-20", color = theme.yellow },
                                { "󰁼", "battery-level-30" },
                                { "󰁽", "battery-level-40" },
                                { "󰁾", "battery-level-50" },
                                { "󰁿", "battery-level-60" },
                                { "󰂀", "battery-level-70" },
                                { "󰂁", "battery-level-80" },
                                { "󰂂", "battery-level-90" },
                                { "󰁹", "battery-level-100" }},
        icon_battery_charging = {{"󰢟", "battery-level-0-charging", color = theme.red  },
                                { "󰢜", "battery-level-10-charging", color = theme.red },
                                { "󰂆", "battery-level-20-charging", color = theme.yellow },
                                { "󰂇", "battery-level-30-charging" },
                                { "󰂈", "battery-level-40-charging" },
                                { "󰢝", "battery-level-50-charging" },
                                { "󰂉", "battery-level-60-charging" },
                                { "󰢞", "battery-level-70-charging" },
                                { "󰂊", "battery-level-80-charging" },
                                { "󰂋", "battery-level-90-charging" },
                                { "󰂅", "battery-level-100-charged" }},
        -- icon_battery_charging = { "󰂄", "battery-charging" },
        icon_battery_unknown  = { "󰂑", "battery-missing" },
        icon_upspeed          = { "󰕒", "go-up" },
        icon_downspeed        = { "󰇚", "go-down" },

        icon_wireless_level   = {{"󰤯", "network-wireless-signal-none" },
                                { "󰤟", "network-wireless-signal-weak" },
                                { "󰤢", "network-wireless-signal-ok" },
                                { "󰤥", "network-wireless-signal-good" },
                                { "󰤨", "network-wireless-signal-excellent" }},
        icon_wireless         = { "󰤨", "network-wireless" },
        icon_wireless_off     = { "󰤮", "network-wireless-offline" },
        icon_wired            = { "󰈀", "network-wired" },
        icon_wired_off        = { "󰈀", "network-wired-offline", color = theme.fg .. "40" },

        icon_email_unread     = { "󰇮", "mail-unread" },
        icon_email_read       = { "󰇰", "mail-read" },
        icon_email_sync       = { "󱋈", "mail-read" },

        icon_cal_prev_year    = { "󰄽", "pan-start" },
        icon_cal_next_year    = { "󰄾", "pan-end" },
        icon_cal_prev_month   = { "󰅁", "pan-start" },
        icon_cal_next_month   = { "󰅂", "pan-end" },

        -- possibly for tag icons
        icon_browser          = { "󰈹", "web-browser" },
        icon_terminal         = { "󰲌", "utilities-terminal" },
        icon_book             = { "󰷉", "accessories-text-editor" },
        icon_work             = { "󰂖", "applications-science" },
        icon_files            = { "󰉖", "folder" },
        icon_movie            = { "󰝚", "applications-multimedia" },
        icon_email            = { "󰇰", "mail-unread" },
    },
    theme
)

-- use theme.iconname since they are added to theme table just now
theme.tag_icons = {
    theme.icon_terminal,
    theme.icon_browser,
    theme.icon_book,
    theme.icon_work,
    theme.icon_files,
    theme.icon_movie,
    theme.icon_email,
    theme.icon_terminal,
    theme.icon_terminal
}
-- }}}

-- Titlebar {{{
theme.titlebar_bg           = theme.fg_normal
theme.titlebar_fg           = theme.bg_normal
theme.titlebar_font = theme.fontname .. " 12"
theme.titlebar_height = dpi(32)

local function button(color)
    local height = theme.titlebar_height
    local width = theme.titlebar_height
    local shape = gears.shape.circle
    return gears.surface.load_from_shape (width, height, shape, color)
end

local button_colors = {
    close     = theme.red,
    maximized = theme.green,
    minimize  = theme.yellow,
    ontop     = theme.blue,
    sticky    = theme.purple,
    floating  = theme.cyan
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
                        theme[button_name] = button(c .. "A0")
                    elseif h == "_press" then
                        theme[button_name] = button(c .. "FF")
                    elseif f == "normal" then
                        theme[button_name] = button(theme.titlebar_fg .. "40")
                    elseif a == "_inactive" then
                        theme[button_name] = button(theme.titlebar_fg .. "40")
                    else
                        theme[button_name] = button(c .. "FF")
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
