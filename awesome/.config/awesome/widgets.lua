-- luacheck: globals mouse
-- libraries {{{
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
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
    click:connect_signal('clickable_reset', function(w) w.bg = bg .. '00' end)
    return click
end
-- }}}

-- font/image buttons {{{
local function icon_button(icon, args)
    args = args or {}
    local use_font = args.use_font or config.use_font_icon

    local function check_icon(i)
        if type(i) == "table" then
            return i
        elseif type(i) == "string" then
            if i:find("^/") then
                use_font = false
                return { nil, i }
            else
                use_font = true
                return { i, nil }
            end
        else
            return { nil, nil }
        end
    end

    icon = check_icon(icon)

    local c, image, button, margin, color
    if use_font then
        c = icon[1]
        margin = icon[3] or 0
        color = icon.color or beautiful.fg
        button = wibox.widget {
            {
                id = "text_role",
                align = "center",
                valign = "center",
                markup = c and fontfg(config.icon_font .. " 20", color, c) or nil,
                widget = wibox.widget.textbox,
            },
            right = margin,
            buttons = args.buttons,
            forced_width = beautiful.wibox_height,
            forced_height = beautiful.wibox_height,
            widget = wibox.container.margin
        }
    else
        image = icon[2]
        margin = icon[4] or 0
        button = wibox.widget {
            {
                id = "image_role",
                image = image,
                widget = wibox.widget.imagebox,
            },
            margins = beautiful.button_imagemargin + margin,
            buttons = args.buttons,
            forced_width = beautiful.wibox_height,
            forced_height = beautiful.wibox_height,
            widget = wibox.container.margin,
        }
    end
    function button:set_icon(newicon)
        newicon = check_icon(newicon)
        if use_font then
            c = newicon[1]
            color = newicon.color or beautiful.fg
            local textbox = self:get_children_by_id("text_role")[1]
            textbox:set_markup(fontfg(config.icon_font .. " 20", color, c))
            self.right = newicon[3] or 0
        else
            image = newicon[2]
            local imagebox = self:get_children_by_id("image_role")[1]
            imagebox:set_image(image)
            self.margins = (newicon[4] or 0) + beautiful.button_imagemargin
        end
    end
    return button
end
-- }}}

-- alsa {{{
local function alsa()
    local volume_color_unmuted = beautiful.fg_normal
    local volume_color_muted = beautiful.grey
    local volume_text = wibox.widget.textbox()
    local volume_icon = icon_button()
    local volume_slider =  wibox.widget.slider()

    local function volume_update(t)
        local stat_icon
        if volume_slider.handle_color == volume_color_muted then
            stat_icon = beautiful.icon_volume_mute
        elseif volume_slider.value > 50 then
            stat_icon = beautiful.icon_volume_high
        elseif volume_slider.value > 20 then
            stat_icon = beautiful.icon_volume_mid
        else
            stat_icon = beautiful.icon_volume_low
        end
        volume_icon:set_icon(stat_icon)
        volume_text:set_text(string.format("%3.0f%%", volume_slider.value))
        -- NOTE: these two must be seperated otherwise the time lag between the two signal
        -- calls and awful spawn calls therein can cause some troubles.
        if t == "level" then
            awful.spawn(string.format("amixer -q set %s %f%%",
                                      config.alsa_channel,
                                      volume_slider.value), false)
        elseif t == "stat" then
            awful.spawn(string.format("amixer -q set %s %s",
                                      config.alsa_channel,
                                      volume_slider.handle_color == volume_color_muted and "mute" or "unmute"), false)
        end
    end
    local volume_upd = gears.timer({
        timeout = 5,
        autostart = true,
        callback = function ()
            awful.spawn.easy_async_with_shell("vol -s; vol",
                function(stdout)
                    local stat, vol = string.match(stdout, "(%d)\n(%d+)")
                    volume_slider.value = tonumber(vol)
                    volume_slider.handle_color = stat ~= "0" and
                                                 volume_color_unmuted or
                                                 volume_color_muted
                end
            )
        end
    })
    volume_upd:emit_signal("timeout")

    -- interacting with the slider only, then change the system volume in signals
    local function volume_toggle()
        volume_slider.handle_color = volume_slider.handle_color == volume_color_muted and
                                     volume_color_unmuted or volume_color_muted
    end
    local function volume_up()
        volume_slider.value = volume_slider.value + 2
    end
    local function volume_down()
        volume_slider.value = volume_slider.value - 2
    end
    volume_slider:connect_signal('property::value', function() volume_update("level") end)
    volume_slider:connect_signal('property::handle_color', function() volume_update("stat") end)

    -- button bindings
    volume_icon:buttons({
        awful.button({}, 1, volume_toggle),
        awful.button({}, 3, function()          -- right click
            awful.spawn(config.terminal_run("alsamixer"))
        end),
    })
    local volume_stack_icon = wibox.widget {
        volume_icon,
        icon_button(beautiful.icon_volume_stack),
        layout = wibox.layout.stack
    }

    local alsa_widget = wibox.widget {
        clickable(config.use_font_icon and volume_stack_icon or volume_icon),
        volume_text,
        clickable(volume_slider),
        forced_height = beautiful.wibox_height,
        layout = wibox.layout.fixed.horizontal
    }
    alsa_widget.indicator =
        clickable(config.use_font_icon and volume_stack_icon or volume_icon)
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
    local function brightness_down()
        light_slider.value = light_slider.value - 10
    end
    local function brightness_up()
        light_slider.value = light_slider.value + 10
    end
    local function brightness_set()
        awful.spawn(string.format("light -Sr %f", light_slider.value), false)
        light_text:set_text(string.format("%3.0f%%", 100 * light_slider.value / light_slider.maximum))
    end

    local backlight = gears.timer {
        timeout   = 5,
        autostart = true,
        callback  = function()
            awful.spawn.easy_async_with_shell("light -Gr",
                function(stdout) light_slider.value = tonumber(stdout) end
            )
        end
    }

    light_slider:connect_signal('property::value', brightness_set)
    backlight:emit_signal("timeout")

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
        clickable(light_icon),
        light_text,
        clickable(light_slider),
        forced_height = beautiful.wibox_height,
        layout = wibox.layout.fixed.horizontal,
    }
    light_widget:buttons(awful.util.table.join(
        awful.button({}, 5, brightness_down),
        awful.button({}, 4, brightness_up)
    ))
    light_widget.indicator = clickable(light_icon)
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
    local bat = gears.timer({
        timeout = 3,
        autostart = true,
        callback = function()
            awful.spawn.easy_async_with_shell("battery; ac",
                function(stdout)
                    local level, state = string.match(stdout, "(%d+)\n(%d)")
                    local  stat_icon
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
    bat:emit_signal("timeout")
    local bat_widget = wibox.widget {
        clickable(bat_icon),
        bat_text,
        bat_bar,
        forced_height = beautiful.wibox_height,
        layout = wibox.layout.fixed.horizontal
    }
    bat_widget.indicator = clickable(bat_icon)
    return bat_widget
end
-- }}}

-- cpu {{{
local function cpu()
    local cpu_icon = icon_button()
    local cpu_text = wibox.widget.textbox()
    local cpu_bar = wibox.widget.progressbar()
    local cpu_upd = gears.timer {
        timeout   = 3,
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
    cpu_upd:emit_signal("timeout")
    local cpu_widget = wibox.widget {
        clickable(cpu_icon),
        cpu_text,
        cpu_bar,
        forced_height = beautiful.wibox_height,
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
        clickable(mem_icon),
        mem_text,
        mem_bar,
        forced_height = beautiful.wibox_height,
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
        clickable(imap_icon),
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
                "network -e; network -w; network -es; network -ws",
                function(stdout)
                    local e, w, ed, eu, wd, wu = string.match(stdout, "(%d+)\n(%d+)\n(%d+)\n(%d+)\n(%d+)\n(%d+)")
                    local upspeed = tonumber(eu) + tonumber(wu)
                    local downspeed = tonumber(ed) + tonumber(wd)
                    if w == "1" then
                        net_icon:set_icon(beautiful.icon_wireless)
                    elseif e == "1" then
                        net_icon:set_icon(beautiful.icon_wired)
                    else
                        net_icon:set_icon(beautiful.icon_wireless_off)
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
        clickable(net_icon),
        net_speed,
        forced_height = beautiful.wibox_height,
        layout = wibox.layout.fixed.horizontal,
    }
    network_widget.indicator = clickable(net_icon)
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
    local mpd_repeat = icon_button(beautiful.icon_music_repeat_on)
    local mpd_random = icon_button(beautiful.icon_music_random_on)
    local mpd_time = wibox.widget.textbox()
    local mpd_seek = function()
        awful.spawn(string.format("mpc -q seek %f%%", mpd_slider.value))
    end
    local mpd_now = {}
    local mpd_upd = gears.timer({
        timeout = 1,
        autostart = true,
        callback = function()
            awful.spawn.easy_async_with_shell(
                "printf \"status\\ncurrentsong\\nclose\\n\" | curl telnet://" .. config.mpd_host,
                function(stdout, _)
                    -- mpd_now (possible) available keys:
                    -- (status result)
                    -- volume repeat random single consume playlist playlistlength
                    -- state song songid elapsed bitrate audio
                    -- (currentsong result)
                    -- file artist albumartist title album track date genre time duration pos id
                    mpd_now = {}
                    -- Put whatever key-value pair mpd gives into the table
                    for k, v in string.gmatch(stdout, "(%w+):%s*([^\n]+)") do
                        mpd_now[k:lower()] = v
                    end
                    mpd_info:set_text(awful.util.escape(string.format(
                        "(%s) %s/%s %s\nFile:\t%s\nArtist:\t%s\nAlbum:\t(%s)\nDate:\t%s\nTitle:\t%s",
                        mpd_now.id,
                        mpd_now.pos,
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
                    repeat_icon = beautiful.icon_music_repeat[mpd_now.single ~= "0" and "off" or "on"]
                    mpd_repeat:set_icon(repeat_icon)
                    random_icon = beautiful.icon_music_random[mpd_now.random == "0" and "off" or "on"]
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
    local mpc_prev = mpc_spawn_update("mpc -q prev || mpc play " .. string.format("%d", (mpd_now.pos or 0) + 1 - 1))
    local mpc_next = mpc_spawn_update("mpc -q next || mpc play " .. string.format("%d", (mpd_now.pos or 0) + 1 + 1))
    local mpc_toggle = mpc_spawn_update("mpc -q toggle || systemctl --user start mpd")
    local mpc_stop = mpc_spawn_update("systemctl --user stop mpd")
    local mpc_forward = mpc_spawn_update("mpc -q seek +10")
    local mpc_backward = mpc_spawn_update("mpc -q seek -10")
    local mpc_single = mpc_spawn_update("mpc -q single")
    local mpc_random = mpc_spawn_update("mpc -q random")
    local mpd_launch_client = function()
        awful.spawn(config.terminal_run("ncmpcpp"))
    end
    mpd_icon  :buttons(awful.util.table.join(awful.button({}, 1, mpd_launch_client)))
    mpd_stop  :buttons(awful.util.table.join(awful.button({}, 1, mpc_stop)))
    mpd_prev  :buttons(awful.util.table.join(awful.button({}, 1, mpc_prev)))
    mpd_play  :buttons(awful.util.table.join(awful.button({}, 1, mpc_toggle)))
    mpd_next  :buttons(awful.util.table.join(awful.button({}, 1, mpc_next)))
    mpd_repeat:buttons(awful.util.table.join(awful.button({}, 1, mpc_single)))
    mpd_random:buttons(awful.util.table.join(awful.button({}, 1, mpc_random)))
    mpd_slider:buttons(awful.util.table.join(awful.button({}, 4, mpc_forward),
                                             awful.button({}, 5, mpc_backward)))
    mpd_upd:emit_signal("timeout")
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
            clickable(mpd_icon),
            clickable(mpd_slider),
            forced_height = beautiful.wibox_height,
            layout = wibox.layout.fixed.horizontal
        },
        {
            clickable(mpd_stop),
            clickable(mpd_prev),
            clickable(mpd_play),
            clickable(mpd_next),
            clickable(mpd_random),
            clickable(mpd_repeat),
            mpd_time,
            forced_height = beautiful.wibox_height,
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
        align = "center",
        format = font(beautiful.fontname .. " 11", "%b\n%d\n%a\n\n") ..
                 font(beautiful.fontname .. " Bold 14", "%H\n%M"),
        widget = wibox.widget.textclock
    }
    local month_offset = 0
    local year_offset = 0
    local calendar_textbox = wibox.widget {
        align = "center",
        valign = "center",
        font = beautiful.fontname .. " 16",
        widget = wibox.widget.textbox
    }
    local function calendar_update(e)
        if e == "0" or e == nil then
            year_offset = 0
            month_offset = 0
        elseif e == "+m" then
            month_offset = month_offset + 1
        elseif e == "-m" then
            month_offset = month_offset - 1
        elseif e == "+y" then
            year_offset = year_offset + 1
        elseif e == "-y" then
            year_offset = year_offset - 1
        end
        awful.spawn.easy_async_with_shell(
            string.format("date -d \"%d month %d year\" +\"%%m %%Y\" | xargs cal",
                          month_offset, year_offset),
            function(stdout) calendar_textbox:set_text(stdout) end
        )
    end
    calendar_update()
    local function cal_button(icon, e)
        return clickable(icon_button(icon, {
            buttons = { awful.button( {}, 1, function() calendar_update(e) end) }
        }))
    end
    local calendar_popup = wibox ({
        widget = {
            {
                {
                    {
                        cal_button(beautiful.icon_cal_prev_year, "-y"),
                        cal_button(beautiful.icon_cal_prev_month, "-m"),
                        layout = wibox.layout.fixed.horizontal
                    },
                    {
                        text = "reset",
                        align = "center",
                        valign = "center",
                        buttons = { awful.button( {}, 1, function() calendar_update() end ) },
                        widget = wibox.widget.textbox
                    },
                    {
                        cal_button(beautiful.icon_cal_next_month, "+m"),
                        cal_button(beautiful.icon_cal_next_year, "+y"),
                        layout = wibox.layout.fixed.horizontal
                    },
                    layout = wibox.layout.align.horizontal
                },
                {
                    {
                        calendar_textbox,
                        margins = 32,
                        layout = wibox.container.margin
                    },
                    bg     = beautiful.bg_focus,
                    -- shape  = gears.shape.rounded_rect,
                    widget = wibox.container.background
                },
                layout = wibox.layout.fixed.vertical,
            },
            -- margins = 16,
            valign = "center",
            halign = "center",
            layout = wibox.container.place
        },
        visible = false,
        ontop = true,
        type = "normal"
    })
    clock:buttons(gears.table.join(
        awful.button( {}, 1, function()
            local cal_width, cal_height = calendar_textbox:get_preferred_size(1)
            calendar_popup.width = cal_width + 96
            calendar_popup.height = cal_height + 96 + beautiful.wibox_height
            calendar_popup.x = mouse.screen.leftbar.x + beautiful.wibox_height
            calendar_popup.y = mouse.screen.geometry.height - calendar_popup.height
            calendar_popup.visible = not calendar_popup.visible
        end)
    ))
    return clock
end
-- }}}

-- systray {{{
local function systray()
    local tray = wibox.widget.systray()
    tray.base_size = beautiful.systray_height
    tray.horizontal = false
    tray.visible = false

    local hide_button = icon_button(beautiful.icon_tray_show)
    hide_button:buttons (gears.table.join(
        awful.button({}, 1, function()
            tray.visible = not tray.visible
            hide_button:set_icon(tray.visible and beautiful.icon_tray_hide
                                              or  beautiful.icon_tray_show)
        end)
    ))
    return wibox.widget {
        {
            tray,
            right  = (beautiful.wibox_height - beautiful.systray_height) / 2,
            left   = (beautiful.wibox_height - beautiful.systray_height) / 2,
            layout = wibox.container.margin
        },
        clickable(hide_button),
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
    return clickable(box)
end
-- }}}

-- launcher {{{
local function launcher_rofi_cmd(s)
    -- run rofi with top and left margins
    local h = beautiful.wibox_height
    local width = s.geometry.width - h - (s.leftbar.x - s.geometry.x)
    local height = s.geometry.height - h - (s.topbar.y - s.geometry.y)
    return "rofi -modi drun -show drun -theme launcher"
                .. " -theme-str \"#window {"
                .. "    location: south east;"
                .. "    width: " .. width .. "px;"
                .. "    height: " .. height .. "px;"
                .. "}\""
end
local function launcher(s)
    local button = wibox.widget {
        icon_button(beautiful.menuicon),
        bg = beautiful.blue,
        widget = wibox.container.background,
    }
    button:buttons(awful.util.table.join(
        awful.button({ }, 1, function() awful.spawn(launcher_rofi_cmd(s)) end),
        awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
        awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
    ))
    return button
end
-- }}}

-- new term button {{{
local function newterm_button()
    local button = icon_button(beautiful.newterm)
    button:buttons({ awful.button({}, 1, function() awful.spawn(config.terminal) end) })
    return clickable(button)
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
        x = s.geometry.x + beautiful.wibox_height,
        y = s.geometry.y,
        width = s.geometry.width - beautiful.wibox_height,
        height = beautiful.wibox_height,
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
    bar:struts({ top = beautiful.wibox_height })
    return bar
end
-- }}}

-- leftbar {{{
local function leftbar(s)
    local bar = wibox {
        screen = s,
        x = s.geometry.x,
        y = s.geometry.y,
        width = beautiful.wibox_height,
        height = s.geometry.height,
        bg = beautiful.bg_normal .. "80",
        visible = true,
        ontop = true,
        type = "dock",
    }
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
            spacing = 16,
            layout = wibox.layout.fixed.vertical,
        },
        layout = wibox.layout.align.vertical
    }
    bar:struts({ left = beautiful.wibox_height })
    return bar
end
-- }}}

-- leftpanel {{{
local function leftpanel(s)
    local panel = wibox {
        screen = s,
        x = s.geometry.x,
        y = s.geometry.y,
        width = beautiful.wibox_height * 8,
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
            wibox.widget {
                icon_button(beautiful.closebutton),
                buttons = awful.util.table.join(
                    awful.button({}, 1, function()
                        panel:toggle()
                    end)
                ),
                widget = clickable,
            },
            clickable(icon_button("1")),
            clickable(icon_button()),
            clickable(icon_button()),
            clickable(icon_button()),
            clickable(icon_button()),
            clickable(icon_button()),
            clickable(icon_button()),
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
    panel.toggle_button = clickable(toggle_button)
    return panel
end
-- }}}

-- return {{{
return {
    launcher_rofi_cmd = launcher_rofi_cmd,
    clickable = clickable,
    icon_button = icon_button,
    leftpanel = leftpanel,
    leftbar = leftbar,
    topbar = topbar,
}
-- }}}

-- vim:foldmethod=marker:foldlevel=0
