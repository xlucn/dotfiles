-- Libraries {{{
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
--local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Xrandr https://awesomewm.org/recipes/xrandr/
local xrandr = require("xrandr")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
local lain = require("lain")
local dpi = require("beautiful.xresources").apply_dpi
local markup = lain.util.markup
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init(gears.filesystem.get_themes_dir() .. "zenburn/theme.lua")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

seperator = wibox.widget {
    widget = wibox.widget.separator,
    orientation = "vertical",
    forced_width = 64,
    color = beautiful.bg_normal
}

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "vim"
local function terminal_cmd(cmd)
    if terminal == "termite" then
        return terminal .. " -e \"" .. cmd .. "\""
    else
        return terminal .. " -e " .. cmd
    end
end
local function editor_cmd(file)
    return terminal_cmd(editor .. " " .. file)
end

-- rofi (launcher tool) commands
rofi_basic = "rofi -modi drun,window,run"
rofi_drun = rofi_basic .. " -show drun"
rofi_run = rofi_basic .. " -show run"
rofi_window = rofi_basic .. " -show window"
rofi_sidetab = rofi_basic .. " -theme sidetab -show drun"

-- maim (screenshot tool) commands
maim_basic = "maim"
-- target
maim_selection = " -s"
maim_current = " -i $(xdotool getactivewindow)"
-- location
maim_savefile = " ~/Pictures/Screenshot_$(date +%F_%H-%M-%S).png"
maim_clipboard = " | xclip -selection clipboard -t image/png"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
altkey = "Mod1"
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.fair,
    --awful.layout.suit.corner.nw,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating,
}

-- Tag names
tag1 = " " .. beautiful.nerdfont_terminal  .. " "
tag2 = " " .. beautiful.nerdfont_browser   .. " "
tag3 = " " .. beautiful.nerdfont_book      .. " "
tag4 = " " .. beautiful.nerdfont_briefcase .. " "
tag5 = " " .. beautiful.nerdfont_files     .. " "
tag6 = " " .. beautiful.nerdfont_movie     .. " "
tag7 = " " .. beautiful.nerdfont_email     .. " "
tag8 = " " .. beautiful.nerdfont_git       .. " "
tag9 = " " .. beautiful.nerdfont_terminal  .. " "

-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- format time
local function format_time(seconds)
    return string.format("%2d:%02d", seconds // 60, seconds % 60)
end
-- }}}

-- {{{ Menu

-- Create a launcher widget and a main menu
local myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", "xdg-open /usr/share/doc/awesome/doc/index.html"},
   { "edit config", terminal_cmd(editor_cmd(awesome.conffile)) },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

local menu_utils = require("menubar.utils")
local menu_gen = require("menubar.menu_gen")

-- some configurations
menu_utils.terminal = terminal
menu_gen.all_menu_dirs = {
    '/usr/share/applications/',
    '/usr/local/share/applications/',
    os.getenv("HOME") .. '/.local/share/applications'
}

-- icon for applications without one
default_icon = menu_utils.lookup_icon("application-default-icon")
-- icons for terminal applications
terminal_icon = menu_utils.lookup_icon("terminal")

local result = {}
local mymainmenu      = awful.menu()
mymainmenu:add({ "awesome", myawesomemenu, beautiful.awesome_icon, })
mymainmenu:add({ "open terminal", terminal, terminal_icon })

-- Modified from https://github.com/lcpz/awesome-freedesktop/blob/master/menu.lua
menu_gen.generate(function(entries)
    -- Add categories
    for k, v in pairs(menu_gen.all_categories) do
        table.insert(result, { k, {}, v.icon })
    end

    -- Add applications
    for k, v in pairs(entries) do
        -- Use fallback icon
        v.icon = v.icon or default_icon
        for _, cat in pairs(result) do
            if cat[1] == v.category then
                table.insert(cat[2], { v.name, v.cmdline, v.icon })
                break
            end
        end
    end

    -- Cleanup things a bit
    for _, v in pairs(result) do
        --Sort entries alphabetically (by name)
        table.sort(v[2], function (a, b) return string.byte(a[1]) < string.byte(b[1]) end)
        -- Replace category name with nice name
        v[1] = menu_gen.all_categories[v[1]].name
    end

    -- Sort categories alphabetically also
    table.sort(result, function(a, b) return string.byte(a[1]) < string.byte(b[1]) end)

    for _, v in pairs(result) do
        -- Only add non-empty categories
        if #v[2] > 0 then
            mymainmenu:add(v)
        end
    end
end)

local mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                           menu = mymainmenu })
-- }}}

-- {{{ Widgets
-- MPD widget {{{
local mpd_tooltip = awful.tooltip {}
mpd_tooltip.mode = "outside"
mpd_tooltip.preferred_alignments = {"middle"}
local mpd_arc = wibox.widget {
    bg = beautiful.bg_focus,
    colors = { beautiful.widget_music },
    thickness = 2,
    max_value = 1,
    forced_width = 24,
    forced_height = 24,
    start_angle = math.pi * 3 / 2,
    widget = wibox.container.arcchart
}
local mpd_stop = wibox.widget.textbox(
    markup.fontfg(beautiful.widgets_nerdfont,
                  beautiful.widget_music,
                  beautiful.nerdfont_music_stop)
)
local mpd_prev = wibox.widget.textbox(
    markup.fontfg(beautiful.widgets_nerdfont,
                  beautiful.widget_music,
                  beautiful.nerdfont_music_prev)
)
local mpd_next = wibox.widget.textbox(
    markup.fontfg(beautiful.widgets_nerdfont,
                  beautiful.widget_music,
                  beautiful.nerdfont_music_next)
)
local mpd_repeat = wibox.widget.textbox(
    markup.fontfg(beautiful.widgets_nerdfont,
                  beautiful.widget_music,
                  beautiful.nerdfont_music_repeat_on)
)
local mpd_upd = lain.widget.mpd({
    timeout = 5,
    notify = "off",
    settings = function()
        local current_summary = string.format(
            "File:\t%s\nArtist:\t%s\nAlbum:\t(%s) - %s\nTitle:\t%s",
            mpd_now.file,
            mpd_now.artist,
            mpd_now.album,
            mpd_now.date,
            mpd_now.title
        )
        mpd_notification_preset = {
            title   = "Now playing",
            timeout = 6,
            text    = current_summary
        }
        mpd_tooltip:set_text(current_summary)
        local repeat_mode, state
        -- state
        if mpd_now.state == "play" then
            state = beautiful.nerdfont_music_pause
        elseif mpd_now.state == "pause" then
            state = beautiful.nerdfont_music_play
        else
            state = beautiful.nerdfont_music_stop
        end
        widget:set_markup(markup.fontfg(beautiful.widgets_nerdfont,
                                        beautiful.widget_music,
                                        state))
        -- time arc
        if mpd_now.state == "play" or mpd_now.state == "pause" then
            mpd_arc.value = mpd_now.elapsed / mpd_now.time
        else
            mpd_arc.value = 0
        end
        -- repeat mode
        if mpd_now.single_mode == true then
            repeat_mode = beautiful.nerdfont_music_repeat_one
        else
            repeat_mode = beautiful.nerdfont_music_repeat_on
        end
        mpd_repeat.markup = markup.fontfg(beautiful.widgets_nerdfont,
                                          beautiful.widget_music,
                                          repeat_mode)
    end
})
local mpd = wibox.widget {
    wibox.widget {
        mpd_stop,
        margins = 8,
        right = 0,
        layout = wibox.container.margin
    },
    wibox.widget {
        mpd_prev,
        margins = 8,
        layout = wibox.container.margin
    },
    {
        wibox.widget {
            mpd_upd.widget,
            margins = 8,
            layout = wibox.container.margin
        },
        mpd_arc,
        layout = wibox.layout.stack
    },
    wibox.widget {
        mpd_next,
        margins = 8,
        layout = wibox.container.margin
    },
    wibox.widget {
        mpd_repeat,
        margins = 8,
        left = 0,
        layout = wibox.container.margin
    },
    layout = wibox.layout.fixed.horizontal
}
mpd_tooltip:add_to_object(mpd)
mpd_arc:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        awful.spawn.with_shell("mpc toggle")
        mpd_upd.update()
    end),
    awful.button({}, 3, function()
        awful.spawn(terminal_cmd("ncmpcpp"))
    end),
    awful.button({}, 4, function()
        awful.spawn.with_shell("mpc seek +10")
        mpd_upd.update()
    end),
    awful.button({}, 5, function()
        awful.spawn.with_shell("mpc seek -10")
        mpd_upd.update()
    end)
))
mpd_stop:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        awful.spawn.with_shell("mpc stop")
        mpd_upd.update()
    end)
))
mpd_prev:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        awful.spawn.with_shell("mpc prev")
        mpd_upd.update()
    end)
))
mpd_next:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        awful.spawn.with_shell("mpc next")
        mpd_upd.update()
    end)
))
mpd_repeat:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        awful.spawn.with_shell("mpc single")
        mpd_upd.update()
    end)
))
mpd_upd.update()
-- }}}

-- alsa widget {{{
local volume_arc = wibox.widget {
    bg = beautiful.bg_focus,
    colors = { beautiful.widget_alsa },
    thickness = 2,
    max_value = 1,
    forced_width = 24,
    forced_height = 24,
    start_angle = math.pi * 3 / 2,
    widget = wibox.container.arcchart
}
volume_arc.tooltip = awful.tooltip({ objects = { volume_arc } })
volume_arc.tooltip.mode = "outside"
volume_arc.tooltip.preferred_alignments = {"middle"}
local volume = lain.widget.alsa({
    settings = function ()
        local state
        if volume_now.status == "off" then
            state = beautiful.nerdfont_volume_mute
        else
            state = beautiful.nerdfont_volume_high
        end
        widget:set_markup(markup.fontfg(beautiful.widgets_nerdfont,
                                        beautiful.widget_alsa,
                                        state))
        volume_arc.tooltip:set_text(volume_now.level .. "%")
        volume_arc.value = volume_now.level / 100
    end
})

local myvolume = {
    wibox.widget {
        volume,
        margins = 8,
        layout = wibox.container.margin
    },
    volume_arc,
    layout = wibox.layout.stack
}

-- audio functions
tuimixer_command = "alsamixer"
audio_mixer = terminal_cmd(tuimixer_command)
volume_toggle = function()
    os.execute(string.format("%s set %s toggle",
                             volume.cmd,
                             volume.togglechannel or volume.channel))
    volume.update()
end
volume_up = function()
    os.execute(string.format("%s set %s 2%%+", volume.cmd, volume.channel))
    volume.update()
end
volume_down = function()
    os.execute(string.format("%s set %s 2%%-", volume.cmd, volume.channel))
    volume.update()
end

-- button bindings
volume_arc:buttons(awful.util.table.join(
    awful.button({}, 1, volume_toggle),     -- left click
    awful.button({}, 3, function()          -- right click
        awful.spawn(audio_mixer)
    end),
    awful.button({}, 4, volume_down),       -- scroll down
    awful.button({}, 5, volume_up)          -- scroll up
))
-- }}}

-- battery widget {{{
local bat_arc = wibox.widget {
    bg = beautiful.bg_focus,
    colors = { beautiful.widget_bat_normal },
    thickness = 2,
    max_value = 1,
    forced_width = 24,
    forced_height = 24,
    start_angle = math.pi * 3 / 2,
    widget = wibox.container.arcchart
}
bat_arc.tooltip = awful.tooltip({ objects = { bat_arc } })
bat_arc.tooltip.mode = "outside"
bat_arc.tooltip.preferred_alignments = {"middle"}
local lain_bat = lain.widget.bat({
    full_notify = "off",
    notify = "on",
    settings = function()
        local state, color
        color = beautiful.widget_bat_normal
        local perc = tonumber(bat_now.perc)
        bat_arc.tooltip:set_text(perc .. "%")
        bat_arc.value = perc / 100
        if bat_now.ac_status == 1 then
            state = beautiful.nerdfont_bat_full_charging
        elseif bat_now.status == "N/A" then
            state = beautiful.nerdfont_bat_unknown
        else
            if perc > 80 then
                state = beautiful.nerdfont_bat_full
            elseif perc > 60 then
                state = beautiful.nerdfont_bat_high
            elseif perc > 40 then
                state = beautiful.nerdfont_bat_mid
                color = beautiful.widget_bat_mid
            elseif perc > 15 then
                state = beautiful.nerdfont_bat_low
                color = beautiful.widget_bat_low
            else
                state = beautiful.nerdfont_bat_empty
                color = beautiful.widget_bat_empty
            end
        end
        widget:set_markup(
            markup.fontfg(beautiful.widgets_nerdfont, color, state)
        )
    end
})
local mybattery = {
    layout = wibox.layout.stack,
    wibox.widget {
        lain_bat,
        margins = 8,
        layout = wibox.container.margin
    },
    bat_arc,
}
-- }}}

-- Network widget {{{
local net_status = wibox.widget.textbox()
-- format network speed
local function format_netspeed(raw_speed)
    -- use 1000 here to keep under 3-digits
    if raw_speed < 1000 then
        speed = raw_speed
        speed_unit = "KB/s"
    elseif raw_speed < 1000 * 1024 then
        speed = raw_speed / 1024
        speed_unit = "MB/s"
    else
        speed = raw_speed / 1024 / 1024
        speed_unit = "GB/s"
    end

    if speed < 10 then
        speed_str = string.format("%3.1f", speed)
    else
        speed_str = string.format("%3.0f", speed)
    end

    return speed_str, speed_unit
end
-- command to show active wifi SSID
-- nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d\' -f2
local mynet = lain.widget.net({
    wifi_state = "on",
    eth_state = "on",
    notify = "off",
    settings = function()
        -- get wlan and ethernet interface name
        awful.spawn.easy_async_with_shell(
            "ip a | grep -E '^[1-9].*' | awk -F':[[:space:]]+' '{ print $2 }'",
            function (stdout, _, _, _)
                for name in string.gmatch(stdout, "(%w+)") do
                    if string.sub(name, 1, 1) == "e" then
                        ethernet_name = name
                    elseif string.sub(name, 1, 1) == "w" then
                        wlan_name = name
                    end
                end
                --naughty.notify({ text = ethernet_name .. ' ' .. wlan_name })
            end)

        -- set ethernet status
        local eth = net_now.devices[ethernet_name]
        if eth and eth.ethernet then
            eth_icon = markup.fontfg(beautiful.widgets_nerdfont,
                                     beautiful.fg_normal,
                                     beautiful.nerdfont_ethernet)
        else
            eth_icon = markup.fontfg(beautiful.widgets_nerdfont,
                                     beautiful.bg_focus,
                                     beautiful.nerdfont_ethernet)
        end

        -- set wlan status
        local wifi = net_now.devices[wlan_name]
        if wifi and wifi.wifi then
            wlan_icon = markup.fontfg(beautiful.widgets_nerdfont,
                                     beautiful.fg_normal,
                                     beautiful.nerdfont_wifi_on)
        else
            wlan_icon = markup.fontfg(beautiful.widgets_nerdfont,
                                     beautiful.bg_focus,
                                     beautiful.nerdfont_wifi_on)
        end

        -- set widget content
        net_status.markup = " " .. eth_icon .. " " .. wlan_icon

        -- send and receive speed
        local sent_str, sent_unit = format_netspeed(tonumber(net_now.sent))
        local received_str, received_unit = format_netspeed(tonumber(net_now.received))
        widget:set_markup(
            markup.fg.color(beautiful.blue, sent_str .. " " .. sent_unit)
            .. " " ..
            markup.fg.color(beautiful.red, received_str .. " " .. received_unit)
        )
    end
}).widget
mynet.visible = false  -- default to invisible
net_status:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        mynet.visible = not mynet.visible
    end),     -- left click
    awful.button({}, 3, function()          -- right click
        awful.spawn(terminal_cmd("nmtui-connect"))
    end)
))
-- }}}

-- CPU {{{
local cpu_arc = wibox.widget {
    bg = beautiful.bg_focus,
    colors = { beautiful.widget_cpu },
    thickness = 2,
    max_value = 1,
    forced_width = 24,
    forced_height = 24,
    start_angle = math.pi * 3 / 2,
    widget = wibox.container.arcchart
}
cpu_arc.tooltip = awful.tooltip({ objects = { cpu_arc } })
cpu_arc.tooltip.mode = "outside"
cpu_arc.tooltip.preferred_alignments = {"middle"}
local laincpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.fontfg(beautiful.widgets_nerdfont,
                                        beautiful.widget_cpu,
                                        beautiful.nerdfont_cpu))
        cpu_arc.tooltip:set_text(cpu_now.usage .. "%")
        cpu_arc.value = cpu_now.usage / 100
    end
})
local mycpu = wibox.widget {
    wibox.widget {
        layout = wibox.container.margin,
        margins = 8,
        laincpu.widget
    },
    cpu_arc,
    layout = wibox.layout.stack
}
mycpu:buttons(awful.util.table.join(
    laincpu.widget:buttons(),
    awful.button({}, 3, function()
        awful.spawn(terminal_cmd("htop -s PERCENT_CPU"))
    end)
))
-- }}}

-- Memory {{{
local mem_arc = wibox.widget {
    bg = beautiful.bg_focus,
    colors = { beautiful.widget_ram },
    thickness = 2,
    max_value = 1,
    forced_width = 24,
    forced_height = 24,
    start_angle = math.pi * 3 / 2,
    widget = wibox.container.arcchart
}
mem_arc.tooltip = awful.tooltip({ objects = { mem_arc } })
mem_arc.tooltip.mode = "outside"
mem_arc.tooltip.preferred_alignments = {"middle"}

local lainmem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg(beautiful.widgets_nerdfont,
                                        beautiful.widget_ram,
                                        beautiful.nerdfont_memory))
        mem_arc.tooltip:set_text(string.format("%.2f GB", mem_now.used / 1000.0))
        mem_arc.value = mem_now.perc / 100
    end
})
local myram = wibox.widget {
    wibox.widget{
        lainmem.widget,
        margins = 8,
        layout = wibox.container.margin
    },
    mem_arc,
    layout = wibox.layout.stack
}
myram:buttons(awful.util.table.join(
    awful.button({}, 3, function()
        awful.spawn(terminal_cmd("htop -s PERCENT_MEM"))
    end)
))
-- }}}

-- Brightness widget {{{
-- progressbar
local light_arc = wibox.widget {
    bg = beautiful.bg_focus,
    colors = { beautiful.widget_light },
    thickness = 2,
    max_value = 1,
    forced_width = 24,
    forced_height = 24,
    start_angle = math.pi * 3 / 2,
    widget = wibox.container.arcchart
}
light_arc.tooltip = awful.tooltip({ objects = { light_arc } })
light_arc.tooltip.mode = "outside"
light_arc.tooltip.preferred_alignments = {"middle"}
local backlight = gears.timer {
    timeout   = 60,
    autostart = true,
    callback  = function()
        awful.spawn.easy_async("light -G",
            function(stdout)
                local perc = tonumber(stdout:match("(%d+).%d"))
                light_arc.tooltip:set_text(perc .. "%")
                light_arc.value = perc / 100
            end
        )
    end
}
local backlight_stack = wibox.widget {
    wibox.widget {
        wibox.widget{
            markup = markup.fontfg(beautiful.widgets_nerdfont,
                                   beautiful.widget_light,
                                   beautiful.nerdfont_brightness_high),
            widget = wibox.widget.textbox
        },
        margins = 6,
        layout = wibox.container.margin
    },
    light_arc,
    layout = wibox.layout.stack
}
backlight:emit_signal("timeout")
-- light commands
brightness_down = function ()
    awful.spawn("light -U 10")
    backlight:emit_signal("timeout")
end
brightness_up = function ()
    awful.spawn("light -A 10")
    backlight:emit_signal("timeout")
end
-- bindings
backlight_stack:buttons(awful.util.table.join(
    awful.button({}, 4, brightness_down),
    awful.button({}, 5, brightness_up)
))

-- }}}

-- {{{ mail
local mymail = "oliver_lew@outlook.com"
local myserver =  "imap-mail.outlook.com"
local myimap = lain.widget.imap({
    notify = "off",
    server = myserver,
    mail = mymail,
    password = "pass show mail/" .. mymail,
    settings = function()
        local msg = imap_now["UNSEEN"] .. "/" .. imap_now["MESSAGES"]
        if imap_now["MESSAGES"] > 0 then
            icon_color = beautiful.widget_mail_online
        else
            icon_color = beautiful.widget_mail_offline
        end
        widget:set_markup(
            markup.fontfg(beautiful.widgets_nerdfont, icon_color, "") ..
            " " .. msg
        )
    end
})
myimap.widget:buttons(awful.util.table.join(
    awful.button({}, 3, function()
        awful.spawn(terminal_cmd("neomutt"))
    end)
))
myimap.update()
-- }}}

--{{{
systray = wibox.widget.systray()
mysystray = wibox.widget {
    systray,
    top = (beautiful.wibox_height - beautiful.systray_height) / 2,
    bottom = (beautiful.wibox_height - beautiful.systray_height) / 2,
    layout = wibox.container.margin
}
--}}}

-- }}}

-- {{{ Wibar

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
                                    if client.focus then
                                        client.focus:move_to_tag(t)
                                    end
                                end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
                                    if client.focus then
                                        client.focus:toggle_tag(t)
                                    end
                                end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
     awful.button({ }, 1, function (c)
                              if c == client.focus then
                                  c.minimized = true
                              else
                                  -- Without this, the following
                                  -- :isvisible() makes no sense
                                  c.minimized = false
                                  if not c:isvisible() and c.first_tag then
                                      c.first_tag:view_only()
                                  end
                                  -- This will also un-minimize
                                  -- the client, if needed
                                  client.focus = c
                                  c:raise()
                              end
                          end),
     awful.button({ }, 3, client_menu_toggle_fn()),
     awful.button({ }, 4, function ()
                              awful.client.focus.byidx(1)
                          end),
     awful.button({ }, 5, function ()
                              awful.client.focus.byidx(-1)
                          end)
)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ tag1, tag2, tag3, tag4, tag5, tag6, tag7, tag8, tag9},
              s, awful.layout.layouts[1])

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                {
                    {
                        id     = 'icon_role',
                        widget = wibox.widget.imagebox,
                    },
                    forced_height = beautiful.wibox_height,
                    forced_width = beautiful.wibox_height + 12,
                    left = 8,
                    right = 8,
                    top = 2,
                    bottom = 2,
                    widget  = wibox.container.margin
                },
                wibox.widget.base.make_widget(),
                id            = 'background_role',
                widget        = wibox.container.background,
            },
            layout = wibox.layout.align.vertical,
            create_callback = function(self, c, index, objects) --luacheck: no unused args
                local icon = self:get_children_by_id('icon_role')[1]

                local tooltip = awful.tooltip({
                  objects = { self },
                  timer_function = function() return c.name end,
                })
                tooltip.mode = "outside"
                tooltip.preferred_alignments = {"middle"}
            end,
        },
    }

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        height = beautiful.wibox_height
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            seperator,
            s.mytasklist,
        },
        -- Middle widget
        nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = 8,
            myimap.widget,
            mynet,
            mpd,
            mycpu,
            ram_widget,
            myram,
            myvolume,
            volume_upd,
            backlight_stack,
            mybattery,
            net_status,
            wibox.widget.textclock(),
            mysystray,
            s.mylayoutbox,
        },
    }

end)
-- }}}

-- {{{ Mouse bindings
mylauncher:buttons(awful.util.table.join(
    awful.button({ }, 3, function() os.execute(rofi_drun) end),
    awful.button({ }, 1, function () mymainmenu:toggle() end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey }, "b", function ()
        mouse.screen.mywibox.visible = not mouse.screen.mywibox.visible
    end),
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, ",",      awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, ".",      awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j", function () awful.client.focus.byidx( 1) end,
              {description = "focus next by index", group = "client"}),
    awful.key({ modkey,           }, "k", function () awful.client.focus.byidx(-1) end,
              {description = "focus previous by index", group = "client"}),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ altkey,           }, "Tab",
              function ()
                  awful.client.focus.history.previous()
                  if client.focus then
                      client.focus:raise()
                  end
              end,
              {description = "go back", group = "client"}),

    awful.key({ modkey,           }, "z", function() end,
              {description = "zen mode", group = "awesome"}),
    -- On the fly useless gaps change
    awful.key({ modkey, "Control" }, "=", function () lain.util.useless_gaps_resize(8) end,
              {description = "increase gap", group = "awesome"}),
    awful.key({ modkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-8) end,
              {description = "decrease gap", group = "awesome"}),

    -- Standard program
    awful.key({ modkey,           }, "Return",  function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Shift"   }, "Return",  function ()
                                                    awful.spawn(terminal, {
                                                        ontop = true,
                                                        floating = true,
                                                        placement = awful.placement.centered,
                                                    })
                                                end,
              {description = "open a centered floating terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- screen shot with maim
    awful.key({                    }, "Print",
              function ()
                  awful.spawn.with_shell(maim_basic                   .. maim_savefile)
              end,
              {description = "screenshot to file",                group = "screenshot"}),
    awful.key({            "Shift" }, "Print",
              function ()
                  awful.spawn.with_shell(maim_basic .. maim_selection .. maim_savefile)
              end,
              {description = "screenshot selection to file",      group = "screenshot"}),
    awful.key({ "Control"          }, "Print",
              function ()
                  awful.spawn.with_shell(maim_basic                   .. maim_clipboard)
              end,
              {description = "screenshot to clipboard",           group = "screenshot"}),
    awful.key({ "Control", "Shift" }, "Print",
              function ()
                  awful.spawn.with_shell(maim_basic .. maim_selection .. maim_clipboard)
              end,
              {description = "screenshot selection to clipboard", group = "screenshot"}),

    -- Prompt
    awful.key({ modkey,           }, "d", function () awful.spawn(rofi_drun) end,
              {description = "show rofi in drun modi", group = "launcher"}),
    awful.key({ modkey,           }, "r", function () awful.spawn(rofi_run) end,
              {description = "run command in rofi", group = "launcher"}),
    awful.key({ modkey,           }, "Tab", function () awful.spawn(rofi_window) end,
              {description = "switch window", group = "client"}),
    awful.key({ modkey,           }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    --awful.key({ modkey }, "p", function() menubar.show() end,
              --{description = "show the menubar", group = "launcher"})
    -- Xrandr
    awful.key({ modkey }, "p", function() xrandr.xrandr() end,
              {description = "swap arrangements of monitors", group = "screen"}),
    awful.key({ }, "XF86Display", function() xrandr.xrandr() end,
              {description = "swap arrangements of monitors", group = "screen"}),

    -- XF86 keys
    awful.key({}, "XF86AudioMute", volume_toggle,
              {description = "toggle mute", group = "Media"}),
    awful.key({}, "XF86AudioRaiseVolume", volume_up,
              {description = "volume up", group = "Media"}),
    awful.key({}, "XF86AudioLowerVolume", volume_down,
              {description = "volume down", group = "Media"}),
    awful.key({ modkey }, "\\", volume_toggle,
              {description = "toggle mute", group = "Media"}),
    awful.key({ modkey }, "]", volume_up,
              {description = "volume up", group = "Media"}),
    awful.key({ modkey }, "[", volume_down,
              {description = "volume down", group = "Media"}),
    awful.key({}, "XF86MonBrightnessDown", brightness_down,
              {description = "brightness down", group = "Media"}),
    awful.key({}, "XF86MonBrightnessUp", brightness_up,
              {description = "brightness up", group = "Media"}),
    awful.key({ modkey }, "-", brightness_down,
              {description = "brightness down", group = "Media"}),
    awful.key({ modkey }, "=", brightness_up,
              {description = "brightness up", group = "Media"}),

    -- Application launching
    awful.key({ modkey }, "f", function () awful.spawn(terminal_cmd("ranger")) end,
              {description = "launch file manager", group = "launcher"}),
    awful.key({ modkey }, "e", function () awful.spawn(terminal_cmd("neomutt")) end,
              {description = "launch email client", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey, "Shift"   }, "f",
              function (c)
                  c.fullscreen = not c.fullscreen
                  c:raise()
              end,
              {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "q",
              function (c)
                  c:kill()
              end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",
              awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return",
              function (c)
                  c:swap(awful.client.getmaster())
              end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",
              function (c)
                  c:move_to_screen()
              end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",
              function (c)
                  c.ontop = not c.ontop
              end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
              function (c)
                  -- The client currently has the input focus, so it cannot be
                  -- minimized, since minimized clients can't have the focus.
                  c.minimized = true
              end ,
              {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
              function (c)
                  c.maximized = not c.maximized
                  c:raise()
              end ,
              {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
              function (c)
                  c.maximized_vertical = not c.maximized_vertical
                  c:raise()
              end ,
              {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
              function (c)
                  c.maximized_horizontal = not c.maximized_horizontal
                  c:raise()
              end ,
              {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     size_hints_honor = false,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Add titlebars to normal clients and dialogs
    { rule_any = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true } },

    -- borderless
    {
        rule = { class = "Nemo", instance = "file_progress" },
        properties = { ontop = true }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",                  -- Firefox addon DownThemAll.
          "copyq",                -- Includes session name in class.
          "Popup",
        },

        name = {
          "Event Tester",           -- xev.
          "Select a Template",      -- LibreOffice
          "Screen Layout Editor",   -- arandr
          "File Operation Progress" -- thunar file operation
        },
        role = {
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
          "page-info",    -- Firefox's image info
          "About",        -- Firefox's about page
          "GtkFileChooserDialog"
        },
        class = {
            "Galculator",
        }
      }, properties = { floating = true,
                        ontop = true,
                        placement = awful.placement.centered}},

    -- Fullscreen and screen management for pdfpc
    { rule = { class = "Pdfpc" },
        properties = { fullscreen = true },
        -- This callback will *magically* put presentation to the secondary
        -- screen and leave the presenter console on the current screen.
        callback = function(c) c:move_to_screen() end },

    -- Set Firefox to always map on the tag 2.
    {
        rule = {
            class = "Firefox",
            role = "browser",
            instance = "Navigator"
        },
        properties = {
            tag = tag2,
            titlebars_enabled = false,
            maximized = true
        }
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    -- set fallback icon
    -- https://www.reddit.com/r/awesomewm/comments/b5rmeo/how_to_add_fallback_icon_to_the_tasklist/
    local t = {}
    t["URxvt"] = "/usr/share/icons/Papirus/64x64/apps/terminal.svg"
    -- fallback of fallback icon
    t["Others"] = "/usr/share/icons/Papirus/64x64/apps/application-default-icon.svg"

    if c.icon == nil then
        local icon = t[c.class]
        if not icon then
            icon = t["Others"]
        end
        icon = gears.surface(icon)
        c.icon = icon and icon._native or nil
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = 12}) : setup {
        { -- Left
            --awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            --{ -- Title
                --align  = "center",
                --widget = awful.titlebar.widget.titlewidget(c)
            --},
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.minimizebutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Log {{{
local logfile = io.open("/tmp/awesomelog", "a")
local t = timer({ timeout = 2 })
t:connect_signal("timeout", function()
  --collectgarbage("collect")
  --logfile:write(os.date(), "\nLua memory usage:", collectgarbage("count"), "\n")
  logfile:write("Objects alive:\n")
  for name, obj in pairs{ button = button, client = client, drawable = drawable, drawin = drawin, key = key, screen = screen, tag = tag } do
    logfile:write(name, ": ", obj.instances(), "\n")
  end
  logfile:flush()
end)
t:start()
t:emit_signal("timeout")
-- }}}

-- vim:foldmethod=marker:foldlevel=0
