-- luacheck: globals mouse
-- libraries {{{
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
-- my local config file
local config = require("config")
local modkey = config.modkey
-- }}}

-- helper function {{{
local function fontfg(fn, color, text)
    return string.format("<span font='%s' foreground='%s'>%s</span>", fn, color, text)
end

local function font(fn, text)
    return string.format("<span font='%s'>%s</span>", fn, text)
end
-- }}}

-- clickable {{{
local function clickable(widget)
    local bg = beautiful.fg_normal
    local click = wibox.container.background(widget)
    click:connect_signal('mouse::enter',    function(w) w.bg = bg .. '20' end)
    click:connect_signal('mouse::leave',    function(w) w.bg = bg .. '00' end)
    click:connect_signal('button::press',   function(w) w.bg = bg .. '40' end)
    click:connect_signal('button::release', function(w) w.bg = bg .. '20' end)
    return click
end
-- }}}

-- font/image buttons {{{
local function icon_button(icon, args)
    args = args or {}
    local use_font = args.use_font or not config.use_image_icon

    local function check_icon(i)
        return type(i) == "table" and i or ( use_font and { i, nil } or { nil, i } )
        -- return i or {}
    end

    icon = check_icon(icon)
    -- print(use_font, icon and tostring(icon[1]) .. tostring(icon[2]))

    local button = wibox.widget {
        use_font and {
            {
                id = "text_role",
                align = "center",
                valign = "center",
                markup = fontfg(config.icon_font .. " " .. (args.font_size or "20"),
                                icon.color or beautiful.fg,
                                icon[1] or ""),
                widget = wibox.widget.textbox,
            },
            right = icon.font_margin or 0,
            buttons = args.buttons,
            forced_width = beautiful.bar_size,
            forced_height = beautiful.bar_size,
            widget = wibox.container.margin
        } or {
            {
                id = "image_role",
                image = icon[2],
                widget = wibox.widget.imagebox,
            },
            margins = beautiful.button_imagemargin + (icon.image_margin or 0),
            buttons = args.buttons,
            forced_width = beautiful.bar_size,
            forced_height = beautiful.bar_size,
            widget = wibox.container.margin,
        },
        widget = clickable
    }

    function button:set_icon(newicon, newargs)
        -- print(use_font, newicon and tostring(newicon[1]) .. tostring(newicon[2]))
        newargs = newargs or {}
        newicon = check_icon(newicon)
        if use_font then
            local textbox = self:get_children_by_id("text_role")[1]
            textbox:set_markup(fontfg(config.icon_font .. " " .. (newargs.font_size or "20"),
                                      newicon.color or beautiful.fg_normal,
                                      newicon[1] or ""))
            self.right = newicon.font_margin or 0
        else
            local imagebox = self:get_children_by_id("image_role")[1]
            imagebox:set_image(newicon[2])
            self.margins = beautiful.button_imagemargin + (newicon.image_margin or 0)
        end
    end

    return button
end
-- }}}

-- OSD {{{
local test_popup = awful.popup {
    widget = {
        {
            icon_button(),
            id = 'icon_button',
            forced_height = config.bar_size * 6,
            forced_width = config.bar_size * 6,
            margins = config.bar_size,
            widget = wibox.container.margin
        },
        {
            id = 'progressbar',
            forced_height = config.bar_size,
            forced_width = config.bar_size * 6,
            widget = wibox.widget.progressbar
        },
        layout = wibox.layout.fixed.vertical,
    },
    placement   = awful.placement.centered,
    shape       = gears.shape.rounded_rect,
    visible     = false,
    ontop       = true,
}
test_popup:buttons(gears.table.join(
    awful.button({}, 1, function(t) t.visible = false end)
))
local test_timer = gears.timer {
    timeout = 2,
    autostart = true,
    single_shot = true,
    callback = function()
        test_popup.visible = false
    end
}
local function osd_show(icon, value)
    test_popup.widget:get_children_by_id("progressbar")[1].value = value
    test_popup.widget:get_children_by_id("icon_button")[1].children[1]:set_icon(icon, { font_size = 160 })
    test_popup.visible = true
    test_timer:again()
end
-- }}}

-- alsa {{{
local function alsa()
    local color_unmuted = beautiful.fg_normal
    local color_muted = beautiful.grey
    local text = wibox.widget.textbox()
    local icon = icon_button()
    local slider =  wibox.widget.slider()
    local stat_icon

    local function volume_update(t)
        if slider.handle_color == color_muted then
            stat_icon = beautiful.icon_volume_mute
        elseif slider.value > 50 then
            stat_icon = beautiful.icon_volume_high
        elseif slider.value > 20 then
            stat_icon = beautiful.icon_volume_mid
        else
            stat_icon = beautiful.icon_volume_low
        end
        icon:set_icon(stat_icon)
        text:set_text(string.format("%3.0f%%", slider.value))
        -- NOTE: these two must be seperated otherwise the time lag between the two signal
        -- calls and awful spawn calls therein can cause some troubles.
        if t == "level" then
            awful.spawn(string.format("amixer -q set %s %f%%",
                                      config.alsa_channel,
                                      slider.value), false)
        elseif t == "stat" then
            awful.spawn(string.format("amixer -q set %s %s",
                                      config.alsa_channel,
                                      slider.handle_color == color_muted and "mute" or "unmute"), false)
        end
    end
    local volume_upd = gears.timer({
        timeout = 5,
        autostart = true,
        callback = function ()
            awful.spawn.easy_async_with_shell("vol -s; vol",
                function(stdout)
                    local stat, vol = string.match(stdout, "(%d)\n(%d+)")
                    slider.value = tonumber(vol)
                    slider.handle_color = stat ~= "0" and
                                                 color_unmuted or
                                                 color_muted
                end
            )
        end
    })
    volume_upd:emit_signal("timeout")

    -- interacting with the slider only, then change the system volume in signals
    local function volume_toggle()
        slider.handle_color = slider.handle_color == color_muted and
                              color_unmuted or color_muted
        osd_show(stat_icon, slider.value / slider.maximum)
    end
    local function volume_up()
        slider.value = slider.value + 2
        osd_show(stat_icon, slider.value / slider.maximum)
    end
    local function volume_down()
        slider.value = slider.value - 2
        osd_show(stat_icon, slider.value / slider.maximum)
    end
    slider:connect_signal('property::value', function() volume_update("level") end)
    slider:connect_signal('property::handle_color', function() volume_update("stat") end)

    -- button bindings
    icon:buttons({
        awful.button({}, 1, volume_toggle),
        awful.button({}, 3, function()          -- right click
            awful.spawn(config.terminal_run("alsamixer"))
        end),
        awful.button({}, 4, volume_up),         -- scroll up
        awful.button({}, 5, volume_down)        -- scroll down
    })
    local stack_icon = wibox.widget {
        icon,
        icon_button(beautiful.icon_volume_stack),
        layout = wibox.layout.stack
    }

    local alsa_widget = wibox.widget {
        config.use_image_icon and icon or stack_icon,
        text,
        clickable(slider),
        forced_height = beautiful.bar_size,
        layout = wibox.layout.fixed.horizontal
    }
    alsa_widget.indicator = config.use_image_icon and icon or stack_icon
    alsa_widget:buttons({
        awful.button({}, 4, volume_up),         -- scroll up
        awful.button({}, 5, volume_down)        -- scroll down
    })
    awful.keyboard.append_global_keybindings({
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
    })
    return alsa_widget
end
-- }}}

-- brightness {{{
local function light()
    -- Note: using percentage format in `light` command will cause problematic feedbacks.
    -- That is, when the accuracy of the controller is not exactly 1%, you will not be
    -- setting the value to exact x% by simply `light -S x`.
    -- The loss is due to the precision when switching between percentage and raw format.
    local light_text = wibox.widget.textbox()
    local light_slider = wibox.widget.slider()
    local light_icon = icon_button(beautiful.icon_brightness)

    -- modify the slider's maximum value to the estimated maximum raw value
    awful.spawn.easy_async_with_shell("light -G; light -Gr; light -Pr",
        function(stdout)
            local perc, raw, min = string.match(stdout, "(%d*%.?%d+)\n(%d+)\n(%d+)")
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
    local function brightness_change(d)
        light_slider.value = light_slider.value + d
        osd_show(beautiful.icon_brightness,
                 light_slider.value / light_slider.maximum)
    end
    local function brightness_down() brightness_change(-10) end
    local function brightness_up() brightness_change(10) end

    local function brightness_set()
        awful.spawn(string.format("light -Sr %f", light_slider.value), false)
        light_text:set_text(string.format("%3.0f%%", 100 * light_slider.value / light_slider.maximum))
    end

    gears.timer {
        timeout   = 5,
        autostart = true,
        call_now  = true,
        callback  = function()
            awful.spawn.easy_async_with_shell("light -Gr",
                function(stdout)
                    light_slider.value = tonumber(stdout)
                end
            )
        end
    }

    light_slider:connect_signal('property::value', brightness_set)

    -- bindings
    awful.keyboard.append_global_keybindings({
        awful.key({}, "XF86MonBrightnessDown", brightness_down,
                  {description = "brightness down", group = "Media"}),
        awful.key({}, "XF86MonBrightnessUp", brightness_up,
                  {description = "brightness up", group = "Media"}),
        awful.key({ modkey }, "-", brightness_down,
                  {description = "brightness down", group = "Media"}),
        awful.key({ modkey }, "=", brightness_up,
                  {description = "brightness up", group = "Media"}),
    })

    local light_widget = wibox.widget{
        light_icon,
        light_text,
        clickable(light_slider),
        forced_height = beautiful.bar_size,
        layout = wibox.layout.fixed.horizontal,
    }
    light_widget:buttons(awful.util.table.join(
        awful.button({}, 5, brightness_down),
        awful.button({}, 4, brightness_up)
    ))
    light_widget.indicator = light_icon
    light_widget.indicator:buttons(awful.util.table.join(
        awful.button({}, 5, brightness_down),
        awful.button({}, 4, brightness_up)
    ))

    return light_widget
end
-- }}}

-- battery {{{
local function battery()
    local bat_icon = icon_button()
    local bat_text = wibox.widget.textbox()
    local bat_bar = wibox.widget.progressbar()
    gears.timer({
        timeout = 3,
        autostart = true,
        call_now  = true,
        callback = function()
            awful.spawn.easy_async_with_shell("battery; ac",
                function(stdout)
                    local level, state = string.match(stdout, "(%d+)\n(%d)")
                    local stat_icon
                    level = tonumber(level)
                    if state == "1" then
                        stat_icon = beautiful.icon_battery_charging[(level + 4) // 10 + 1]
                    else
                        stat_icon = beautiful.icon_battery[(level + 4) // 10 + 1]
                    end
                    bat_text:set_text(tostring(level) .. "%")
                    bat_icon:set_icon(stat_icon)
                    bat_bar.value = level / 100.0
                end
            )
        end
    })
    local bat_widget = wibox.widget {
        bat_icon,
        bat_text,
        bat_bar,
        forced_height = beautiful.bar_size,
        layout = wibox.layout.fixed.horizontal
    }
    bat_widget.indicator = bat_icon
    return bat_widget
end
-- }}}

-- cpu {{{
local function cpu()
    local cpu_icon = icon_button()
    local cpu_text = wibox.widget.textbox()
    local cpu_bar = wibox.widget.progressbar()

    gears.timer {
        timeout   = 3,
        call_now  = true,
        autostart = true,
        callback  = function()
            awful.spawn.easy_async_with_shell("cpu",
                function(stdout)
                    cpu_icon:set_icon(beautiful.icon_cpu)
                    cpu_text:set_text(string.format("%3.0f%%", tonumber(stdout)))
                    cpu_bar.value = tonumber(stdout) / 100
                end
            )
        end
    }

    cpu_icon:buttons(awful.util.table.join(
        awful.button({}, 3, function()
            awful.spawn(config.terminal_run("htop -s PERCENT_CPU"))
        end)
    ))

    local cpu_widget = wibox.widget {
        cpu_icon,
        cpu_text,
        cpu_bar,
        forced_height = beautiful.bar_size,
        layout = wibox.layout.fixed.horizontal
    }

    return cpu_widget
end
-- }}}

-- memory {{{
local function memory()
    local mem_icon = icon_button()
    local mem_text = wibox.widget.textbox()
    local mem_bar = wibox.widget.progressbar()
    local mem_upd = gears.timer {
        timeout   = 3,
        autostart = true,
        callback  = function()
            awful.spawn.easy_async_with_shell("mem -u; mem -Bu; mem -Bt",
                function(stdout)
                    local _, ub, tb = string.match(stdout, "([^\n]+)\n(%d+)\n(%d+)")
                    mem_icon:set_icon(beautiful.icon_memory)
                    mem_text:set_text(string.format("%3.0f%%", tonumber(ub) / tonumber(tb) * 100))
                    mem_bar.value = tonumber(ub) / tonumber(tb)
                end
            )
        end
    }
    mem_upd:emit_signal("timeout")
    mem_icon:buttons(awful.util.table.join(
        awful.button({}, 3, function()
            awful.spawn(config.terminal_run("htop -s PERCENT_MEM"))
        end)
    ))
    local mem_widget = wibox.widget {
        mem_icon,
        mem_text,
        mem_bar,
        forced_height = beautiful.bar_size,
        layout = wibox.layout.fixed.horizontal
    }
    return mem_widget
end
-- }}}

-- {{{ mail
local function imap_each(email)
    local imap_icon = icon_button()
    local imap_count = wibox.widget.textbox()

    local imap_upd = gears.timer {
        timeout   = 120,
        autostart = true,
        callback  = function()
            awful.spawn.easy_async(string.format("imap %s", email),
                function(stdout)
                    local count = string.match(stdout, "(%d+)")
                    if count == nil then
                        imap_icon:set_icon(beautiful.icon_email_sync)
                    elseif count == "0" then
                        imap_icon:set_icon(beautiful.icon_email_read)
                    else
                        imap_icon:set_icon(beautiful.icon_email_unread)
                    end
                    imap_count:set_text(count or "")
                end
            )
        end
    }

    imap_upd:emit_signal("timeout")
    imap_icon:buttons(awful.util.table.join(
        awful.button({}, 3, function()
            awful.spawn(config.terminal_run(
                string.format("%s -e \"source ~/.config/%s/%s.muttrc\"",
                              config.mutt, config.mutt, email)
            ))
        end)
    ))
    return {
        imap_icon,
        imap_count,
        layout = wibox.layout.fixed.horizontal
    }
end
local function imap()
    local imap_widget = {}
    imap_widget.indicator= wibox.widget{
        spacing = 16,
        layout = wibox.layout.fixed.horizontal
    }
    for _, email in pairs(config.imap_emails) do
        imap_widget.indicator:add(imap_each(email))
    end
    return imap_widget
end
-- }}}

-- network {{{
local function network()
    local net_icon = icon_button()
    local net_speed = wibox.widget.textbox()
    -- format network speed
    local function format_netspeed(raw_speed)
        -- use 1000 here to keep under 3-digits
        local speed, speed_unit, speed_str

        if raw_speed < 1000 * 1000 then
            speed = raw_speed / 1000
            speed_unit = "KB/s"
        else
            speed = raw_speed / 1000 / 1000
            speed_unit = "MB/s"
        end

        if speed < 10 then
            speed_str = string.format("%3.1f", speed)
        else
            speed_str = string.format("%3.0f", speed)
        end

        return speed_str .. ' ' .. speed_unit
    end

    local net_upd = gears.timer {
        timeout   = 3,
        autostart = true,
        callback  = function()
            awful.spawn.easy_async_with_shell(
                "network -e; network -w; network -es; network -ws; network -wc; network -ec",
                function(stdout)
                    local e, w, ed, eu, wd, wu, _, ws, _ = string.match(stdout,
                        "(%d+)\n(%d+)\n(%d+)\n(%d+)\n(%d+)\n(%d+)\n(%S+)\n(%d+)\n(%S+)")
                    ws = tonumber(ws)
                    local upspeed = tonumber(eu) + tonumber(wu)
                    local downspeed = tonumber(ed) + tonumber(wd)
                    local signal_level = ws > 80  and 5 or ws > 55 and 4 or ws > 30 and 3 or ws > 5 and 2 or 1
                    if w == "1" then
                        net_icon:set_icon(beautiful.icon_wireless_level[signal_level])
                    elseif e == "1" then
                        net_icon:set_icon(beautiful.icon_wired)
                    else
                        net_icon:set_icon(beautiful.icon_wired_off)
                    end
                    net_speed:set_text(
                        string.format("祝 %s\n %s", format_netspeed(upspeed), format_netspeed(downspeed))
                    )
                end
            )
        end
    }
    net_upd:emit_signal("timeout")

    net_icon:buttons(awful.util.table.join(
        awful.button({}, 1, function() awful.spawn(config.terminal_run("nmtui-connect")) end)
    ))
    local network_widget = wibox.widget {
        net_icon,
        net_speed,
        forced_height = beautiful.bar_size,
        layout = wibox.layout.fixed.horizontal,
    }
    network_widget.indicator = net_icon
    return network_widget
end
-- }}}

-- mpd {{{
local function mpd()
    local function fmt_time(seconds)
        if seconds == nil then
            return "-"
        end
        local s = seconds // 1 % 60
        local m = seconds // 60 % 60
        local h = seconds // 3600
        if h > 0 then
            return string.format("%d:%02d:%02d", h, m, s)
        else
            return string.format("%d:%02d", m, s)
        end
    end
    local mpd_info = wibox.widget.textbox()
    local mpd_slider = wibox.widget.slider()
    local mpd_icon = icon_button(beautiful.icon_music)
    local mpd_stop = icon_button(beautiful.icon_music_state["stop"])
    local mpd_play = icon_button(beautiful.icon_music_state["pause"])
    local mpd_prev = icon_button(beautiful.icon_music_prev)
    local mpd_next = icon_button(beautiful.icon_music_next)
    local mpd_repeat = icon_button(beautiful.icon_music_repeat[true])
    local mpd_random = icon_button(beautiful.icon_music_random[true])
    local mpd_time = wibox.widget.textbox()
    local mpd_seek = function()
        awful.spawn(string.format("mpc -q seek %f%%", mpd_slider.value), false)
    end
    local mpd_now = {}
    local mpd_upd = gears.timer({
        timeout = 1,
        autostart = true,
        call_now  = true,
        callback = function()
            awful.spawn.easy_async_with_shell(
                "printf \"status\\ncurrentsong\\nclose\\n\" | curl telnet://" .. config.mpd_host,
                function(stdout, _)
                    -- mpd_now (possible) available keys:
                    -- See file:///usr/share/doc/mpd/html/protocol.html#tags
                    --  or file:///usr/share/doc/mpd/html/protocol.html#querying-mpd-s-status
                    mpd_now = {}
                    -- Put whatever key-value pair mpd gives into the table
                    for k, v in string.gmatch(stdout, "(%w+):%s*([^\n]+)") do
                        mpd_now[k:lower()] = v
                    end
                    mpd_info:set_text(awful.util.escape(string.format(
                        "(%s) %s/%s %s\nFile:\t%s\nArtist:\t%s\nAlbum:\t(%s)\nDate:\t%s\nTitle:\t%s",
                        mpd_now.pos,
                        mpd_now.id,
                        mpd_now.playlistlength,
                        mpd_now.elapsed and "" or "(File might be misssing)",
                        mpd_now.file,
                        mpd_now.artist,
                        mpd_now.album,
                        mpd_now.date,
                        mpd_now.title
                    )))
                    -- state
                    mpd_play:set_icon(beautiful.icon_music_state[mpd_now.state or "pause"])
                    -- time slider
                    mpd_slider:disconnect_signal("property::value", mpd_seek)
                    if mpd_now.state == "play" or mpd_now.state == "pause" then
                        mpd_slider.value = mpd_now.elapsed * 100 / mpd_now.time
                    else
                        mpd_slider.value = 0
                    end
                    mpd_slider:connect_signal("property::value", mpd_seek)
                    -- time text
                    mpd_time.text = fmt_time(mpd_now.elapsed) .. "/" .. fmt_time(mpd_now.duration)
                    -- repeat mode
                    local repeat_icon, random_icon
                    repeat_icon = beautiful.icon_music_repeat[mpd_now.single == "0"]
                    mpd_repeat:set_icon(repeat_icon)
                    random_icon = beautiful.icon_music_random[mpd_now.random ~= "0"]
                    mpd_random:set_icon(random_icon)
                end
            )
        end
    })
    mpd_slider:connect_signal("property::value", mpd_seek)
    local function mpc_spawn_update(cmd)
        return function()
            awful.spawn.easy_async_with_shell(cmd, function() mpd_upd:emit_signal("timeout") end)
        end
    end
    local mpc_prev = mpc_spawn_update("mpc -q prev || mpc -q play " .. ((mpd_now.pos or  1) + 1 - 1))
    local mpc_next = mpc_spawn_update("mpc -q next || mpc -q play " .. ((mpd_now.pos or -1) + 1 + 1))
    local mpc_toggle = mpc_spawn_update("mpc -q toggle || systemctl --user start mpd")
    local mpc_stop = mpc_spawn_update("systemctl --user stop mpd")
    local mpc_forward = mpc_spawn_update("mpc -q seek +10")
    local mpc_backward = mpc_spawn_update("mpc -q seek -10")
    local mpc_single = mpc_spawn_update("mpc -q single")
    local mpc_random = mpc_spawn_update("mpc -q random")
    local mpd_launch_client = function() awful.spawn(config.terminal_run("ncmpcpp")) end

    mpd_icon  :buttons({awful.button({}, 1, mpd_launch_client)})
    mpd_stop  :buttons({awful.button({}, 1, mpc_stop)})
    mpd_prev  :buttons({awful.button({}, 1, mpc_prev)})
    mpd_play  :buttons({awful.button({}, 1, mpc_toggle)})
    mpd_next  :buttons({awful.button({}, 1, mpc_next)})
    mpd_repeat:buttons({awful.button({}, 1, mpc_single)})
    mpd_random:buttons({awful.button({}, 1, mpc_random)})
    mpd_slider:buttons({awful.button({}, 4, mpc_forward),
                        awful.button({}, 5, mpc_backward)})

    awful.keyboard.append_global_keybindings({
        awful.key({ modkey, "Shift" }, "-", mpc_prev,
                  {description = "mpd: previous song", group = "Media"}),
        awful.key({ modkey, "Shift" }, "=", mpc_next,
                  {description = "mpd: next song", group = "Media"}),
        awful.key({ modkey, "Shift" }, "[", mpc_backward,
                  {description = "mpd: seed backward", group = "Media"}),
        awful.key({ modkey, "Shift" }, "]", mpc_forward,
                  {description = "mpd: seed forward", group = "Media"}),
        awful.key({ modkey, "Shift" }, "\\", mpc_toggle,
                  {description = "mpd: toggle pause/play", group = "Media"})
    })
    local mpd_widget = wibox.widget {
        {
            mpd_icon,
            clickable(mpd_slider),
            forced_height = beautiful.bar_size,
            layout = wibox.layout.fixed.horizontal
        },
        {
            mpd_stop,
            mpd_prev,
            mpd_play,
            mpd_next,
            mpd_random,
            mpd_repeat,
            mpd_time,
            forced_height = beautiful.bar_size,
            layout = wibox.layout.fixed.horizontal
        },
        mpd_info,
        spacing = 16,
        layout = wibox.layout.fixed.vertical,
    }
    return mpd_widget
end
-- }}}

-- textclock {{{
local function datetime()
    local clock = wibox.widget {
        {
            align = "center",
            format = font(beautiful.fontname .. " 11", "%b\n%d\n%a\n\n") ..
                     font(beautiful.fontname .. " Bold 14", "%H\n%M"),
            widget = wibox.widget.textclock
        },
        margins = { top = 16, bottom = 16 },
        widget = wibox.container.margin
    }
    local grid_width = 7 * beautiful.bar_size
    local grid_height = 7 * beautiful.bar_size
    local month_offset
    local year_offset
    local calendar_title = wibox.widget {
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }
    local calendar_grid = wibox.widget {
        forced_num_rows = 7,
        forced_num_cols = 7,
        expand = true,
        homogeneous = true,
        orientation = "horizontal",
        forced_height = grid_height,
        forced_width = grid_width,
        layout = wibox.layout.grid
    }
    for _ = 1, 7 do  -- week number + weeks * 6
        for _ = 1, 7 do  -- 7 days a week
            calendar_grid:add(wibox.widget {
                {
                    align = "center",
                    valign = "center",
                    widget = wibox.widget.textbox
                },
                widget = wibox.container.background
            })
        end
    end
    local function calendar_update(e)
        if e == "+m" then month_offset = month_offset + 1
        elseif e == "-m" then month_offset = month_offset - 1
        elseif e == "+y" then year_offset = year_offset + 1
        elseif e == "-y" then year_offset = year_offset - 1
        else year_offset, month_offset = 0, 0
        end
        awful.spawn.easy_async_with_shell(
            string.format("date +\"%%d\";" ..  -- today
                          -- Day of week for the first day of the month, required for right align
                          "date -d \"1 $(date -d \"%d month %d year\" +\"%%B %%Y\")\" +\"%%w\";" ..
                          "date -d \"%d month %d year\" +\"%%m %%Y\" | xargs cal",
                          month_offset, year_offset, month_offset, year_offset),
            function(stdout)
                local row, col, today, firstday, tile = 1
                for s in string.gmatch(stdout, "([^\n]+)") do
                    if row == 1 then
                        today = s
                    elseif row == 2 then
                        firstday = tonumber(s + 1)
                    elseif row == 3 then      -- month year
                        calendar_title:set_text(s:match("^%s*(.-)%s*$"))
                    else
                        -- TODO: use find to improve the procedure here
                        -- ( hint: find items one by one within two for loops )
                        col = 1
                        -- right align the first week, set empty before the first day
                        if row - 3 == 2 then
                            while col < firstday do
                                tile = calendar_grid:get_widgets_at(2, col)[1]
                                tile.children[1]:set_text("")
                                tile.bg = "#00000000"
                                col = col + 1
                            end
                        end
                        for d in string.gmatch(s, "(%S+)") do
                            tile = calendar_grid:get_widgets_at(row - 3, col)[1]
                            tile.children[1]:set_text(d)
                            if d == today and year_offset == 0 and month_offset == 0 then
                                tile.bg = beautiful.bg_focus .. "80"
                            else
                                tile.bg = "#00000000"
                            end
                            col = col + 1
                        end
                        -- set empty after the last day
                        while col <= 7 do
                            tile = calendar_grid:get_widgets_at(row - 3, col)[1]
                            tile.children[1]:set_text("")
                            tile.bg = "#00000000"
                            col = col + 1
                        end
                    end
                    row = row + 1
                end
            end
        )
    end
    local function cal_button(icon, e)
        return icon_button(icon, {
            buttons = { awful.button( {}, 1, function() calendar_update(e) end) }
        })
    end
    local calendar_popup = wibox ({
        widget = {
            {
                {
                    cal_button(beautiful.icon_cal_prev_year, "-y"),
                    cal_button(beautiful.icon_cal_prev_month, "-m"),
                    layout = wibox.layout.fixed.horizontal
                },
                clickable(calendar_title),
                {
                    cal_button(beautiful.icon_cal_next_month, "+m"),
                    cal_button(beautiful.icon_cal_next_year, "+y"),
                    layout = wibox.layout.fixed.horizontal
                },
                layout = wibox.layout.align.horizontal
            },
            calendar_grid,
            layout = wibox.layout.fixed.vertical,
        },
        bg = beautiful.bg_normal .. "80",
        visible = false,
        ontop = true,
        width = calendar_grid.forced_width,
        height = calendar_grid.forced_height + beautiful.bar_size
    })

    clock:buttons(gears.table.join(
        awful.button( {}, 1, function()
            calendar_popup.x = mouse.screen.leftbar.x + beautiful.bar_size
            calendar_popup.y = mouse.screen.geometry.height - calendar_popup.height
            calendar_popup.visible = not calendar_popup.visible
            calendar_update()
        end)
    ))
    calendar_title.buttons = { awful.button( {}, 1, function() calendar_update() end ) }
    calendar_grid:buttons(gears.table.join(
        awful.button( {}, 4, function() calendar_update("-m") end),
        awful.button( {}, 5, function() calendar_update("+m") end)
    ))
    return clickable(clock)
end
-- }}}

-- systray {{{
local function systray()
    local tray = wibox.widget {
        horizontal = false,
        visible = false,
        base_size = beautiful.systray_icon_size,
        widget = wibox.widget.systray,
    }
    local hide_button = icon_button(beautiful.icon_tray[tray.visible])
    hide_button:buttons (gears.table.join(
        awful.button({}, 1, function()
            tray.visible = not tray.visible
            hide_button:set_icon(beautiful.icon_tray[tray.visible])
        end)
    ))
    return wibox.widget {
        {
            tray,
            margins = (beautiful.bar_size - beautiful.systray_icon_size) / 2,
            layout = wibox.container.margin
        },
        hide_button,
        layout = wibox.layout.fixed.vertical
    }
end
--}}}

-- layoutbox {{{
local function layoutbox(s)
    local box = icon_button()
    function box:update()
        local layout_name = awful.layout.getname(awful.layout.get(s))
        self:set_icon(beautiful["layout_" .. layout_name])
    end
    box:update()

    awful.tag.attached_connect_signal(s, "property::selected", function () box:update() end)
    awful.tag.attached_connect_signal(s, "property::layout", function () box:update() end)

    box:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function ()
                                 if s.selected_tag.gap > 8 then
                                     awful.tag.incgap(-8)
                                 end
                             end),
        awful.button({ }, 5, function () awful.tag.incgap( 8) end)
    ))
    return box
end
-- }}}

-- launcher {{{
local function launcher(s)
    local button = wibox.widget {
        icon_button(beautiful.menuicon),
        bg = beautiful.blue,
        widget = wibox.container.background,
    }
    button:buttons(awful.util.table.join(
        awful.button({ }, 1, function() awful.spawn(config.launcher_rofi_cmd(s)) end)
    ))
    return button
end
-- }}}

-- new term button {{{
local function newterm_button()
    local button = icon_button(beautiful.newterm)
    button:buttons({ awful.button({}, 1, function() awful.spawn(config.terminal) end) })
    return button
end
-- }}}

-- topbar {{{
local battery_widget = battery()
local cpu_widget = cpu()
local light_widget = light()
local alsa_widget = alsa()
local mem_widget = memory()
local imap_widget = imap()
local net_widget = network()
local mpd_widget = mpd()
local function topbar(s)
    local bar = wibox {
        screen = s,
        x = s.geometry.x + beautiful.bar_size,
        y = s.geometry.y,
        width = s.geometry.width - beautiful.bar_size,
        height = beautiful.bar_size,
        bg = beautiful.bg_normal .. "80",
        visible = true,
        ontop = true,
        type = "dock",
    }
    bar:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            s.mytasklist,
            newterm_button(),
            -- forced_width = 1200,
        },
        nil,
        {
            layout = wibox.layout.fixed.horizontal,
            alsa_widget.indicator,
            light_widget.indicator,
            imap_widget.indicator,
            net_widget.indicator,
            battery_widget.indicator,
            layoutbox(s),
        },
    }
    bar:struts({ top = beautiful.bar_size })
    return bar
end
-- }}}

-- leftbar {{{
local function leftbar(s)
    local bar = wibox {
        screen = s,
        x = s.geometry.x,
        y = s.geometry.y,
        width = beautiful.bar_size,
        height = s.geometry.height,
        bg = beautiful.bg_normal .. "80",
        visible = true,
        ontop = true,
        type = "dock",
    }
    bar:buttons(awful.util.table.join(
        awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
        awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
    ))
    bar:setup {
        {
            launcher(s),
            s.mytaglist,
            layout = wibox.layout.fixed.vertical,
        },
        nil,
        {
            systray(),
            datetime(),
            s.leftpanel.toggle_button,
            layout = wibox.layout.fixed.vertical,
        },
        layout = wibox.layout.align.vertical
    }
    bar:struts({ left = beautiful.bar_size })
    return bar
end
-- }}}

-- leftpanel {{{
local function leftpanel(s)
    local panel = wibox {
        screen = s,
        x = s.geometry.x,
        y = s.geometry.y,
        width = dpi(config.panel_size),
        height = s.geometry.height,
        bg = beautiful.bg_normal .. "80",
        visible = false,
        ontop = true,
        type = "dock",
    }
    panel:setup {
        {
            battery_widget,
            cpu_widget,
            mem_widget,
            alsa_widget,
            light_widget,
            net_widget,
            mpd_widget,
            spacing = 16,
            layout = wibox.layout.fixed.vertical,
        },
        nil,
        {
            icon_button(beautiful.closebutton, {buttons = {
                awful.button({}, 1, function() panel:toggle() end)
            }}),
            icon_button("1", { use_font = true }),
            icon_button(),
            icon_button(),
            icon_button(),
            icon_button(),
            icon_button(),
            icon_button(),
            layout = wibox.layout.flex.horizontal,
        },
        layout = wibox.layout.align.vertical
    }

    local toggle_button = icon_button(beautiful.sidebar_open)

    function panel:toggle()
        self.visible = not self.visible
        if self.visible then
            toggle_button:set_icon(beautiful.sidebar_close)
            s.leftbar.x = s.geometry.x + self.width
            -- a little trick to put leftbar's shadow above leftpanel
            s.leftbar.visible = false
            s.leftbar.visible = true
        else
            toggle_button:set_icon(beautiful.sidebar_open)
            s.leftbar.x = s.geometry.x
        end
    end

    toggle_button:buttons(awful.util.table.join(
        awful.button({}, 1, function() panel:toggle() end)
    ))
    panel.toggle_button = toggle_button
    return panel
end
-- }}}

-- return {{{
return {
    clickable = clickable,
    icon_button = icon_button,
    leftpanel = leftpanel,
    leftbar = leftbar,
    topbar = topbar,
}
-- }}}

-- vim:foldmethod=marker:foldlevel=0
