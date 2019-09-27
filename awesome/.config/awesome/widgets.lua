-- libraries {{{
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local lain = require("lain")
local markup = lain.util.markup
local beautiful = require("beautiful")
-- local module
local theme = require("theme")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")
-- }}}

-- helper function {{{
terminal = "urxvtc"
local function terminal_cmd(cmd)
    return terminal .. " -e " .. cmd
end
-- }}}

-- font, colors, characters {{{
-- font
widgets_nerdfont          = "Hack Nerd Font 12"
-- colors
widget_music          = theme.purple
widget_light          = theme.yellow
widget_ram            = theme.blue
widget_ram_high       = theme.birght_red
widget_cpu            = theme.blue
widget_cpu_high       = theme.red
widget_alsa           = theme.yellow
widget_bat_normal     = theme.green
widget_bat_mid        = theme.green
widget_bat_low        = theme.yellow
widget_bat_empty      = theme.red
widget_mail_online    = theme.green
widget_mail_offline   = theme.fg_normal
widget_net_up         = theme.blue
widget_net_down       = theme.red
-- font characters
nerdfont_music                  = ""
nerdfont_music_off              = ""
nerdfont_music_play             = "契" --  
nerdfont_music_pause            = "" -- 
nerdfont_music_stop             = "栗" -- 
nerdfont_music_next             = "" --  
nerdfont_music_prev             = "" --  
nerdfont_music_shuffle_on       = "列" -- 咽
nerdfont_music_shuffle_off      = "劣"
nerdfont_music_repeat_on        = "凌"
nerdfont_music_repeat_off       = "稜"
nerdfont_music_repeat_one       = "綾"
nerdfont_upspeed                = "祝"
nerdfont_downspeed              = ""
nerdfont_brightness             = ""
nerdfont_brightness_low         = ""
nerdfont_brightness_mid         = ""
nerdfont_brightness_high        = ""
nerdfont_bat_unknown            = ""
nerdfont_bat_empty              = ""
nerdfont_bat_low                = ""
nerdfont_bat_mid                = ""
nerdfont_bat_high               = ""
nerdfont_bat_full               = ""
nerdfont_batteries              = { "", "", "", "", "", "", "", "", "", "", "" }
nerdfont_bat_5                  = ""
nerdfont_bat_15                 = ""
nerdfont_bat_25                 = ""
nerdfont_bat_35                 = ""
nerdfont_bat_45                 = ""
nerdfont_bat_55                 = ""
nerdfont_bat_65                 = ""
nerdfont_bat_75                 = ""
nerdfont_bat_85                 = ""
nerdfont_bat_95                 = ""
nerdfont_bat_100                = ""
nerdfont_bat_full_charging      = ""
nerdfont_volume_mute            = "婢" -- ﱝ
nerdfont_volume_low             = "奄" -- 
nerdfont_volume_mid             = "奔" -- 
nerdfont_volume_high            = "墳" -- 
nerdfont_memory                 = ""
nerdfont_cpu                    = "異" --  
nerdfont_wifi_on                = "直"
nerdfont_wifi_off               = "睊"
nerdfont_ethernet               = ""
nerdfont_calendar               = ""
nerdfont_email                  = ""
-- }}}

-- volume {{{
local volume_slider = wibox.widget {
    forced_width        = 64,
    widget              = wibox.widget.slider,
}

local volume_text = wibox.widget{ widget = wibox.widget.textbox }

local volume = lain.widget.alsa({
    timeout = 2,
    settings = function ()
        local state
        if volume_now.status == "off" then
            state = nerdfont_volume_mute
        else
            state = nerdfont_volume_high
        end
        widget:set_markup(markup.fontfg(widgets_nerdfont,
                                        widget_alsa,
                                        state))
        volume_slider.value = tonumber(volume_now.level)
    end
})

-- audio functions
function volume_toggle()
    os.execute(string.format("%s set %s toggle",
                             volume.cmd,
                             volume.togglechannel or volume.channel))
    volume.update()
end

-- interacting first with the slider, and changing the system volume by
-- setting signals
function volume_up()
    volume_slider.value = volume_slider.value + 2
end
function volume_down()
    volume_slider.value = volume_slider.value - 2
end
function volume_set()
    awful.spawn(string.format("%s set %s %f%%",
                             volume.cmd,
                             volume.channel,
                             volume_slider.value))
    volume_text:set_text(string.format("%3.0f%%", volume_slider.value))
end
volume_slider:connect_signal('property::value', volume_set)

-- button bindings
volume.widget:buttons(awful.util.table.join(
    awful.button({}, 1, volume_toggle)      -- left click
))

local alsa = wibox.widget {
    volume,
    volume_slider,
    volume_text,
    spacing = 8,
    layout = wibox.layout.fixed.horizontal
}
alsa:buttons(awful.util.table.join(
    awful.button({}, 3, function()          -- right click
        awful.spawn(terminal_cmd("alsamixer"))
    end),
    awful.button({}, 4, volume_up),         -- scroll up
    awful.button({}, 5, volume_down)        -- scroll down
))
-- }}}

-- brightness {{{
local light_text = wibox.widget{ widget = wibox.widget.textbox }
local light_slider = wibox.widget {
    forced_width        = 64,
    widget              = wibox.widget.slider,
}

local backlight = gears.timer {
    timeout   = 5,
    autostart = true,
    callback  = function()
        awful.spawn.easy_async("light -G",
            function(stdout)
                light_slider.value = tonumber(stdout:match("(%d+).%d"))
            end
        )
    end
}

-- light commands
brightness_down = function ()
    light_slider.value = light_slider.value - 10
end
brightness_up = function ()
    light_slider.value = light_slider.value + 10
end
function brightness_set()
    awful.spawn(string.format("light -S %f%%", light_slider.value))
    light_text:set_text(string.format("%3.0f%%", light_slider.value))
end
light_slider:connect_signal('property::value', brightness_set)

local light_icon = wibox.widget {
    markup = markup.fontfg(widgets_nerdfont,
                           widget_light,
                           nerdfont_brightness_high),
    widget = wibox.widget.textbox
}

local light = wibox.widget {
    light_icon,
    light_slider,
    light_text,
    spacing = 8,
    layout = wibox.layout.fixed.horizontal
}

backlight:emit_signal("timeout")
-- bindings
light:buttons(awful.util.table.join(
    awful.button({}, 5, brightness_down),
    awful.button({}, 4, brightness_up)
))

-- }}}

-- battery {{{
local bat = lain.widget.bat({
    full_notify = "off",
    notify = "on",
    settings = function()
        local state, color
        local perc = tonumber(bat_now.perc)
        if bat_now.ac_status == 1 then
            state = nerdfont_bat_full_charging
        elseif bat_now.status == "N/A" then
            state = nerdfont_bat_unknown
        else
            if perc > 80 then
                state = nerdfont_bat_full
                color = widget_bat_normal
            elseif perc > 60 then
                state = nerdfont_bat_high
                color = widget_bat_normal
            elseif perc > 40 then
                state = nerdfont_bat_mid
                color = widget_bat_mid
            elseif perc > 15 then
                state = nerdfont_bat_low
                color = widget_bat_low
            else
                state = nerdfont_bat_empty
                color = widget_bat_empty
            end
        end
        widget:set_markup(
            markup.fontfg(widgets_nerdfont, color, state) .. " " ..
            perc .. "%"
        )
    end
})
-- }}}

-- cpu {{{
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.fontfg(widgets_nerdfont,
                                        widget_cpu,
                                        nerdfont_cpu) .. " " ..
                          string.format("%2.0f%%", cpu_now.usage))
    end
})
cpu.widget:buttons(awful.util.table.join(
    awful.button({}, 3, function()
        awful.spawn(terminal_cmd("htop -s PERCENT_CPU"))
    end)
))
-- }}}

-- memory {{{
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg(widgets_nerdfont,
                                        widget_ram,
                                        nerdfont_memory) .. " " ..
                          string.format("%4.2f GB", mem_now.used / 1000.0))
    end
})
mem.widget:buttons(awful.util.table.join(
    awful.button({}, 3, function()
        awful.spawn(terminal_cmd("htop -s PERCENT_MEM"))
    end)
))
-- }}}

-- {{{ mail
local mail = "oliver_lew@outlook.com"
local server =  "imap-mail.outlook.com"
local imap = lain.widget.imap({
    notify = "off",
    server = server,
    mail = mail,
    password = "pass show mail/" .. mail,
    settings = function()
        local msg = imap_now["UNSEEN"]
        if imap_now["MESSAGES"] > 0 then
            icon_color = beautiful.widget_mail_online
        else
            icon_color = beautiful.widget_mail_offline
        end
        widget:set_markup(
            markup.fontfg(beautiful.widgets_nerdfont,
                          icon_color,
                          beautiful.nerdfont_email) ..
            " " .. msg
        )
    end
})
imap.widget:buttons(awful.util.table.join(
    awful.button({}, 3, function()
        awful.spawn(terminal_cmd("neomutt"))
    end)
))
-- }}}

-- network {{{
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
local net = lain.widget.net({
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
            eth_icon = markup.fontfg(widgets_nerdfont,
                                     beautiful.fg_normal,
                                     nerdfont_ethernet)
        else
            eth_icon = markup.fontfg(widgets_nerdfont,
                                     beautiful.fg_normal .. '40',
                                     nerdfont_ethernet)
        end

        -- set wlan status
        local wifi = net_now.devices[wlan_name]
        if wifi and wifi.wifi then
            wlan_icon = markup.fontfg(widgets_nerdfont,
                                     beautiful.fg_normal,
                                     nerdfont_wifi_on)
        else
            wlan_icon = markup.fontfg(widgets_nerdfont,
                                     beautiful.fg_normal .. '40',
                                     nerdfont_wifi_on)
        end

        -- set widget content
        net_status.markup = eth_icon .. " " .. wlan_icon

        -- send and receive speed
        local sent_str, sent_unit = format_netspeed(tonumber(net_now.sent))
        local received_str, received_unit = format_netspeed(tonumber(net_now.received))
        widget:set_markup(
            markup.fg.color(widget_net_up, sent_str .. " " .. sent_unit)
            .. " " ..
            markup.fg.color(widget_net_down, received_str .. " " .. received_unit)
        )
    end
})
local net_speed = wibox.widget {
    layout = wibox.container.margin,
    right = 16,
    net.widget,
}
net_speed.visible = false  -- default to invisible
net_status:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        net_speed.visible = not net_speed.visible
    end),     -- left click
    awful.button({}, 3, function()          -- right click
        awful.spawn(terminal_cmd("nmtui-connect"))
    end)
))
local net = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    net_speed,
    net_status,
}
-- }}}

-- mpd {{{
local mpd_tooltip = awful.tooltip {}
mpd_tooltip.mode = "outside"
mpd_tooltip.preferred_alignments = {"middle"}
local mpd_slider = wibox.widget {
    forced_width        = 128,
    widget              = wibox.widget.slider,
}
local function mpd_seek()
    awful.spawn(string.format("mpc seek %f%%", mpd_slider.value))
end
local mpd_play = wibox.widget.textbox(
    markup.font(widgets_nerdfont, nerdfont_music_play)
)
local mpd_prev = wibox.widget.textbox(
    markup.font(widgets_nerdfont, nerdfont_music_prev)
)
local mpd_next = wibox.widget.textbox(
    markup.font(widgets_nerdfont, nerdfont_music_next)
)
local mpd_repeat = wibox.widget.textbox(
    markup.font(widgets_nerdfont, nerdfont_music_repeat_on)
)
local mpd_time = wibox.widget.textbox()
local mpd_upd = lain.widget.mpd({
    timeout = 5,
    notify = "off",
    settings = function()
        mpd_tooltip:set_text(string.format(
            "File:\t%s\nArtist:\t%s\nAlbum:\t(%s) - %s\nTitle:\t%s",
            mpd_now.file,
            mpd_now.artist,
            mpd_now.album,
            mpd_now.date,
            mpd_now.title
        ))
        local repeat_mode, state
        -- state
        if mpd_now.state == "play" then
            state = nerdfont_music_pause
        elseif mpd_now.state == "pause" then
            state = nerdfont_music_play
        else
            state = nerdfont_music_stop
        end
        mpd_play.markup = markup.font(widgets_nerdfont, state)
        -- time slider
        mpd_slider:disconnect_signal("property::value", mpd_seek)
        if mpd_now.state == "play" or mpd_now.state == "pause" then
            mpd_slider.value = mpd_now.elapsed * 100 / mpd_now.time
        else
            mpd_slider.value = 0
        end
        mpd_slider:connect_signal("property::value", mpd_seek)
        -- time text
        mpd_time.text = mpd_now.elapsed .. "/" .. mpd_now.time
        -- repeat mode
        if mpd_now.single_mode == true then
            repeat_mode = nerdfont_music_repeat_one
        else
            repeat_mode = nerdfont_music_repeat_on
        end
        mpd_repeat.markup = markup.font(widgets_nerdfont, repeat_mode)
    end
})
mpd_slider:connect_signal("property::value", mpd_seek)
local mpd = wibox.widget {
    mpd_prev,
    mpd_play,
    mpd_next,
    mpd_slider,
    mpd_repeat,
    --mpd_time,
    spacing = 8,
    layout = wibox.layout.fixed.horizontal
}
mpd_tooltip:add_to_object(mpd)
mpd_prev:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        awful.spawn.with_shell("mpc prev")
        mpd_upd.update()
    end)
))
mpd_play:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        awful.spawn.with_shell("mpc toggle")
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
mpd:buttons(awful.util.table.join(
    awful.button({}, 4, function()
        awful.spawn.with_shell("mpc seek +10")
        mpd_upd.update()
    end),
    awful.button({}, 5, function()
        awful.spawn.with_shell("mpc seek -10")
        mpd_upd.update()
    end),
    awful.button({}, 3, function()
        awful.spawn(terminal_cmd("ncmpcpp"))
    end)
))
mpd_upd.update()
-- }}}

return {
    alsa = {
        widget = alsa,
        up = volume_up,
        down = volume_down,
        toggle = volume_toggle,
    },
    bat = {
        widget = bat.widget,
    },
    cpu = {
        widget = cpu.widget,
    },
    mem = {
        widget = mem.widget,
    },
    imap = {
        widget = imap.widget,
    },
    net = {
        widget = net,
    },
    light = {
        widget = light,
        up = brightness_up,
        down = brightness_down,
    },
    mpd = {
        widget = mpd,
    },
}

-- vim:foldmethod=marker:foldlevel=0
