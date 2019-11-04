-- luacheck: globals widget cpu_now mem_now mpd_now volume_now bat_now net_now
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
local terminal = "urxvtc"
local function terminal_cmd(cmd)
    return terminal .. " -e " .. cmd
end
-- }}}

-- font, colors, characters {{{
-- font
local widgets_nerdfont          = "Hack Nerd Font 12"
-- colors
local widget_music          = theme.purple
local widget_light          = theme.yellow
local widget_ram            = theme.blue
local widget_cpu            = theme.blue
local widget_alsa           = theme.yellow
local widget_bat_normal     = theme.green
local widget_bat_mid        = theme.yellow
local widget_bat_low        = theme.red
local widget_mail_online    = theme.green
local widget_mail_offline   = theme.fg_normal
local widget_net_up         = theme.blue
local widget_net_down       = theme.red
-- font characters
local nerdfont_music                  = ""
local nerdfont_music_play             = "契" --  
local nerdfont_music_pause            = "" -- 
local nerdfont_music_stop             = "栗" -- 
local nerdfont_music_next             = "" --  
local nerdfont_music_prev             = "" --  
local nerdfont_music_shuffle_on       = "列" -- 咽
local nerdfont_music_shuffle_off      = "劣"
local nerdfont_music_repeat_on        = "凌"
local nerdfont_music_repeat_off       = "稜"
local nerdfont_music_repeat_one       = "綾"
local nerdfont_upspeed                = "祝"
local nerdfont_downspeed              = ""
local nerdfont_brightness             = ""
local nerdfont_brightness_high        = ""
local nerdfont_bat_unknown            = ""
local nerdfont_batteries              = { "", "", "", "", "", "", "", "", "", "", "" }
local nerdfont_bat_full_charging      = ""
local nerdfont_volume_mute            = "婢" -- ﱝ
local nerdfont_volume_low             = "奄" -- 
local nerdfont_volume_mid             = "奔" -- 
local nerdfont_volume_high            = "墳" -- 
local nerdfont_memory                 = ""
local nerdfont_cpu                    = "異" --  
local nerdfont_wifi_on                = "直"
local nerdfont_ethernet               = ""
local nerdfont_calendar               = ""
local nerdfont_email                  = "" -- 
-- }}}

-- volume {{{
local volume_slider = wibox.widget {
    forced_width        = 64,
    widget              = wibox.widget.slider,
    visible             = false,
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
local function volume_toggle()
    os.execute(string.format("%s set %s toggle",
                             volume.cmd,
                             volume.togglechannel or volume.channel))
    volume.update()
end

-- interacting first with the slider, and changing the system volume by
-- setting signals
local function volume_up()
    volume_slider.value = volume_slider.value + 2
end
local function volume_down()
    volume_slider.value = volume_slider.value - 2
end
local function volume_set()
    awful.spawn(string.format("%s set %s %f%%",
                             volume.cmd,
                             volume.channel,
                             volume_slider.value))
    volume_text:set_text(string.format("%3.0f%%", volume_slider.value))
end
volume_slider:connect_signal('property::value', volume_set)

-- button bindings
volume.widget:buttons(awful.util.table.join(
    awful.button({}, 1, volume_toggle),     -- left click
    awful.button({}, 2, function()
        volume_slider.visible = not volume_slider.visible
    end)
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
-- Note: using percentage format in `light` command will cause problematic feedbacks.
-- That is, when the accuracy of the controller is not exactly 1%, you will not be
-- setting the value to almost ANY x% by simply `light -S x`.
-- The loss is due to the precision when switching between percentage and raw format.
local light_text = wibox.widget.textbox()
local light_slider = wibox.widget {
    forced_width        = 64,
    widget              = wibox.widget.slider,
    visible             = false,
}
-- modify the slider's maximum value to the estimated maximum raw value
awful.spawn.easy_async_with_shell("light -G; light -Gr; light -Pr",
    function(stdout)
        -- This returns a iterator
        local a = string.gmatch(stdout, "%d*%.?%d+")
        local perc = a()
        local raw = a()
        local min = a()
        -- calculate the maximum raw level (0.5 is for rounding the result)
        if tonumber(raw) > 0 then
            light_slider.maximum = math.floor(raw * 100 / perc + 0.5)
        end
        light_slider.minimum = tonumber(min)
        light_slider.value = tonumber(raw)
        light_text:set_text(string.format("%3.0f%%", perc))
    end
)
-- light commands
local function brightness_down()
    light_slider.value = light_slider.value - 10
end
local function brightness_up()
    light_slider.value = light_slider.value + 10
end
local function brightness_set()
    awful.spawn(string.format("light -Sr %f", light_slider.value))
    light_text:set_text(string.format("%3.0f%%", 100 * light_slider.value / light_slider.maximum))
end

local backlight = gears.timer {
    timeout   = 5,
    autostart = true,
    callback  = function()
        awful.spawn.easy_async_with_shell("light -Gr",
            function(stdout)
                light_slider.value = tonumber(stdout)
                light_text:set_text(
                    string.format(
                        "%3.0f%%", 100 * light_slider.value / light_slider.maximum
                    )
                )
            end
        )
    end
}

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
    awful.button({}, 2, function()
        light_slider.visible = not light_slider.visible
    end),
    awful.button({}, 5, brightness_down),
    awful.button({}, 4, brightness_up)
))

-- }}}

-- battery {{{
local bat = lain.widget.bat({
    full_notify = "off",
    notify = "off",
    settings = function()
        local state, color
        local perc = tonumber(bat_now.perc)
        if bat_now.ac_status == 1 then
            state = nerdfont_bat_full_charging
        elseif bat_now.status == "N/A" then
            state = nerdfont_bat_unknown
        else
            state = nerdfont_batteries[(perc + 4) // 10 + 1]
        end
        if perc > 30 then
            color = widget_bat_normal
        elseif perc > 15 then
            color = widget_bat_mid
        else
            color = widget_bat_low
        end
        widget:set_markup(
            markup.fontfg(widgets_nerdfont, color, state) .. " " ..  perc .. "%"
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
--local mail = "2869761396@qq.com"

local imap = wibox.widget.textbox()

local imap_upd = gears.timer {
    timeout   = 60,
    autostart = true,
    callback  = function()
        awful.spawn.easy_async(string.format("imap -m %s", mail),
            function(stdout)
                local color
                if stdout == nil or stdout == "" then
                    color = widget_mail_offline
                else
                    color = widget_mail_online
                end
                imap:set_markup(markup.fontfg(widgets_nerdfont, color, nerdfont_email)
                                .. " " .. stdout)
            end
        )
    end
}

imap_upd:emit_signal("timeout")
imap:buttons(awful.util.table.join(
    awful.button({}, 3, function()
        awful.spawn(terminal_cmd("abduco -A neomutt neomutt"))
    end)
))
-- }}}

-- network {{{
local net_status = wibox.widget.textbox()
-- format network speed
local function format_netspeed(raw_speed)
    -- use 1000 here to keep under 3-digits
    local speed, speed_unit, speed_str

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
local lain_net = lain.widget.net({
    wifi_state = "on",
    eth_state = "on",
    notify = "off",
    settings = function()
        local eth_icon, wlan_icon
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
    lain_net.widget,
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
local function fmt_time(seconds)
    if seconds == "N/A" then
        return "-"
    end
    local minites = seconds // 60
    local s = seconds % 60
    local m = minites % 60
    local h = minites // 60
    if h > 0 then
        return string.format("%d:%02d:%02d", h, m, s)
    else
        return string.format("%d:%02d", m, s)
    end
end
local mpd_tooltip = awful.tooltip {}
mpd_tooltip.mode = "outside"
mpd_tooltip.preferred_alignments = {"middle"}
local mpd_slider = wibox.widget {
    forced_width        = 128,
    widget              = wibox.widget.slider,
}
local mpd_icon = wibox.widget.textbox(
    markup.fontfg(widgets_nerdfont, widget_music, nerdfont_music)
)
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
local function mpd_seek()
    awful.spawn(string.format("mpc seek %f%%", mpd_slider.value))
end
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
        mpd_time.text = fmt_time(mpd_now.elapsed) .. "/" .. fmt_time(mpd_now.time)
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
    mpd_icon,
    mpd_prev,
    mpd_play,
    mpd_next,
    mpd_repeat,
    mpd_slider,
    mpd_time,
    spacing = 8,
    layout = wibox.layout.fixed.horizontal
}
mpd_tooltip:add_to_object(mpd)
mpd_icon:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        mpd_slider.visible = not mpd_slider.visible
        mpd_time.visible = not mpd_time.visible
    end)
))
mpd_prev:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        awful.spawn.with_shell("mpc prev")
        mpd_upd.update()
    end)
))
mpd_play:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        awful.spawn.with_shell("mpc && mpc toggle || systemctl --user start mpd")
        mpd_upd.update()
    end),
    awful.button({}, 2, function()
        awful.spawn.with_shell("systemctl --user stop mpd")
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

-- return {{{
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
        widget = imap,
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
-- }}}

-- vim:foldmethod=marker:foldlevel=0
