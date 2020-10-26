-- luacheck: globals mouse
-- libraries {{{
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
-- my local config file
local config = require("config")
local modkey = config.modkey
-- }}}
-- markup function {{{
local function markup(text, fn, color)
    if color then
        return string.format("<span font='%s' foreground='%s'>%s</span>", fn, color, text)
    else
        return string.format("<span font='%s'>%s</span>", fn, text)
    end
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
-- The method is basically copied from AwesomeWM library files, I have no idea why it works
local icon_button_widget = {}
function icon_button_widget:set_shape(shape)
    self._private.container.shape = shape
end
function icon_button_widget:set_buttons(buttons)
    self._private.container:get_children_by_id("margin_role")[1].buttons = buttons
end
function icon_button_widget:set_image_margin(margin)
    self._private.image_margin = margin
    if not self._private.use_font then
        self._private.container:get_children_by_id("margin_role")[1].margins = margin
    end
end
function icon_button_widget:set_icon(icon, args)
    local function check_icon(i)
        return type(i) == "table" and i or ( self._private.use_font and { i, nil } or { nil, i } )
    end

    args = args or {}
    icon = check_icon(icon)
    if self._private.use_font then
        self._private.container:get_children_by_id("text_role")[1]:set_markup(markup(
            icon[1] or "",
            config.icon_font .. " " .. (args.font_size or "20"),
            icon.color or beautiful.fg_normal
        ))
    else
        self._private.container:get_children_by_id("image_role")[1]:set_image(icon[2])
        if not self._private.image_margin then
            self:set_image_margin(beautiful.button_imagemargin + (icon.image_margin or 0))
        end
    end
end
local function icon_button_build(icon, args)
    args = args or {}
    local use_font = args.use_font or not config.use_image_icon

    local clickable_widget = clickable()
    local button = wibox.widget.base.make_widget(clickable_widget, nil, {enable_properties = true})
    gears.table.crush(button, icon_button_widget, true)
    button._private.container = clickable_widget
    button._private.use_font = use_font

    clickable_widget:setup {
        use_font and {
            id = "text_role",
            align = "center",
            valign = "center",
            widget = wibox.widget.textbox,
        } or {
            id = "image_role",
            widget = wibox.widget.imagebox,
        },
        id = "margin_role",
        forced_width = beautiful.bar_size,
        forced_height = beautiful.bar_size,
        widget = wibox.container.margin,
    }

    button:set_icon(icon, args)

    return button
end
local icon_button = setmetatable(icon_button_widget, {
    __call = function(_, ...) return icon_button_build(...) end
})
-- }}}
-- OSD {{{
local osd_popup = awful.popup {
    widget = {
        {
            icon_button(),
            id = 'icon_button',
            forced_height = beautiful.bar_size * 5,
            forced_width = beautiful.bar_size * 6,
            margins = config.use_image_icon and beautiful.bar_size or 0,
            widget = wibox.container.margin
        },
        {
            id = 'progressbar',
            forced_height = beautiful.bar_size,
            forced_width = beautiful.bar_size * 6,
            widget = wibox.widget.progressbar
        },
        layout = wibox.layout.fixed.vertical,
    },
    placement   = awful.placement.centered,
    shape       = gears.shape.rounded_rect,
    bg          = beautiful.bg_normal .. "80",
    visible     = false,
    ontop       = true,
}
osd_popup:buttons { awful.button({}, 1, function() osd_popup.visible = false end) }
local osd_timer = gears.timer {
    timeout = 2,
    autostart = true,
    single_shot = true,
    callback = function() osd_popup.visible = false end
}
local function osd_show(icon, value)
    osd_popup.widget:get_children_by_id("progressbar")[1].value = value
    osd_popup.widget:get_children_by_id("icon_button")[1].children[1]:set_icon(icon, { font_size = 120 })
    osd_popup.screen = mouse.screen
    osd_popup.visible = true
    osd_timer:again()
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
        -- NOTE: these two must be seperated instead of combined to one command
        -- otherwise the awful spawn call will be executed twice some time after
        -- the two signals (the problem is you don't know in exactly what
        -- sequence) therein can cause some troubles.
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
                    slider.handle_color = stat ~= "0" and color_unmuted or color_muted
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
    icon:buttons {
        awful.button({}, 1, volume_toggle),
        awful.button({}, 3, function()          -- right click
            awful.spawn(config.float_terminal .. " -e alsamixer")
        end),
        awful.button({}, 4, volume_up),         -- scroll up
        awful.button({}, 5, volume_down)        -- scroll down
    }
    local alsa_widget = wibox.widget {
        icon,
        text,
        clickable(slider),
        forced_height = beautiful.bar_size,
        layout = wibox.layout.fixed.horizontal
    }
    alsa_widget.indicator = icon
    alsa_widget:buttons{
        awful.button({}, 4, volume_up),         -- scroll up
        awful.button({}, 5, volume_down)        -- scroll down
    }
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
-- Note: using percentage format in `light` command will cause problems.
-- That is, when the accuracy of the controller is not exactly 1%, you will not
-- be setting the value to exact x% by simply `light -S x`. The loss is due to
-- the cut off when switching between percentage and raw format.
local function light()
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
    light_widget:buttons {
        awful.button({}, 5, brightness_down),
        awful.button({}, 4, brightness_up)
    }
    light_widget.indicator = light_icon
    light_widget.indicator:buttons {
        awful.button({}, 5, brightness_down),
        awful.button({}, 4, brightness_up)
    }

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
                    level = tonumber(level) or 100
                    if state == "1" then
                        stat_icon = beautiful.icon_battery_charging[(level + 4) // 10 + 1]
                    else
                        stat_icon = beautiful.icon_battery[(level + 4) // 10 + 1]
                    end
                    bat_text:set_text(string.format("%3.0f%%", level))
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

    cpu_icon:buttons { awful.button({}, 3, function()
        awful.spawn(config.terminal .. " -e htop -s PERCENT_CPU")
    end) }

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
    mem_icon:buttons { awful.button({}, 3, function()
        awful.spawn(config.terminal .. " -e htop -s PERCENT_MEM")
    end) }
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
local function imap()
    local indicator_status
    local flags_unread = {}
    local imap_widget = wibox.widget{
        layout = wibox.layout.fixed.horizontal
    }
    imap_widget.indicator = icon_button(beautiful.icon_email_read)

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

                        -- update the indicator
                        -- TODO: a cleaner code?
                        flags_unread[email] = count ~= "0"
                        indicator_status = false
                        for _, e in pairs(config.imap_emails) do
                            if flags_unread[e] then
                                indicator_status = true
                            end
                        end
                        imap_widget.indicator:set_icon(indicator_status
                            and beautiful.icon_email_unread
                            or beautiful.icon_email_read)
                    end
                )
            end
        }

        imap_upd:emit_signal("timeout")
        imap_icon:buttons { awful.button({}, 3, function()
            awful.spawn(config.terminal .. " -e " ..
                string.format("%s -e \"source ~/.config/%s/%s.muttrc\"",
                              config.mutt, config.mutt, email)
            )
        end) }
        return {
            imap_icon,
            imap_count,
            layout = wibox.layout.fixed.horizontal
        }
    end

    for _, email in pairs(config.imap_emails) do
        imap_widget:add(imap_each(email))
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
                    local e, w, ed, eu, wd, wu, _, ws, _, _ = string.match(stdout,
                        "(%d+)\n(%d+)\n(%d+)\n(%d+)\n(%d+)\n(%d+)\n([^\n]+)\n(%d+)\n([^\n]+)\n(%d+)")
                    ws = tonumber(ws)
                    local upspeed = tonumber(eu) + tonumber(wu)
                    local downspeed = tonumber(ed) + tonumber(wd)
                    local signal_level = ws > 80 and 5
                                      or ws > 55 and 4
                                      or ws > 30 and 3
                                      or ws > 5  and 2
                                      or 1
                    if w == "1" then
                        net_icon:set_icon(beautiful.icon_wireless_level[signal_level])
                    else
                        net_icon:set_icon(beautiful.icon_wired[e == 1])
                    end
                    net_speed:set_text(
                        string.format("󰕒 %s\n󰇚 %s", format_netspeed(upspeed), format_netspeed(downspeed))
                    )
                end
            )
        end
    }
    net_upd:emit_signal("timeout")

    net_icon:buttons { awful.button({}, 1, function()
        awful.spawn(config.float_terminal .. " -e nmtui-connect")
    end) }
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
                    -- mpd_now available keys:
                    -- See file:///usr/share/doc/mpd/html/protocol.html#tags
                    --  or file:///usr/share/doc/mpd/html/protocol.html#querying-mpd-s-status
                    mpd_now = {}
                    -- Put whatever key-value pair mpd gives into the table
                    for k, v in string.gmatch(stdout, "(%w+):%s*([^\n]+)") do
                        mpd_now[k:lower()] = v
                    end
                    mpd_info:set_text(awful.util.escape(string.format(
                        "(%s) %s/%s %s\nFile:\t%s\nArtist:\t%s\nAlbum:\t(%s)\nDate:\t%s\nTitle:\t%s",
                        mpd_now.pos, mpd_now.id, mpd_now.playlistlength,
                        mpd_now.elapsed and "" or "(File might be misssing)",
                        mpd_now.file, mpd_now.artist, mpd_now.album, mpd_now.date, mpd_now.title
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
    local mpd_launch_client = function() awful.spawn(config.terminal .. " -e ncmpcpp") end

    mpd_icon:buttons   { awful.button({}, 1, mpd_launch_client) }
    mpd_stop:buttons   { awful.button({}, 1, mpc_stop) }
    mpd_prev:buttons   { awful.button({}, 1, mpc_prev) }
    mpd_play:buttons   { awful.button({}, 1, mpc_toggle) }
    mpd_next:buttons   { awful.button({}, 1, mpc_next) }
    mpd_repeat:buttons { awful.button({}, 1, mpc_single) }
    mpd_random:buttons { awful.button({}, 1, mpc_random) }
    mpd_slider:buttons { awful.button({}, 4, mpc_forward),
                         awful.button({}, 5, mpc_backward) }

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
            mpd_stop, mpd_prev, mpd_play, mpd_next, mpd_random, mpd_repeat, mpd_time,
            forced_height = beautiful.bar_size,
            layout = wibox.layout.fixed.horizontal
        },
        mpd_info,
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
            format = markup("%b\n%d\n%a\n\n", beautiful.fontname .. " 11") ..
                     markup("%H\n%M", beautiful.fontname .. " 16"),
            widget = wibox.widget.textclock
        },
        margins = { top = beautiful.bar_size / 3, bottom = beautiful.bar_size / 3 },
        widget = wibox.container.margin
    }
    local month_offset = 0 -- only use month offset
    local row, col, today, firstday, tile
    local calendar_title = wibox.widget {
        align = "center",
        valign = "center",
        font = beautiful.fontname .. " 13",
        widget = wibox.widget.textbox
    }
    local calendar_grid = wibox.widget {
        forced_num_rows = 7,
        forced_num_cols = 7,
        expand = true,
        homogeneous = true,
        orientation = "horizontal",
        forced_height = 7 * beautiful.bar_size, -- weekday names + at most 6 weeks
        forced_width = 7 * beautiful.bar_size, -- 7 days a week
        layout = wibox.layout.grid
    }
    for _ = 1, 7 * 7 do
        calendar_grid:add(wibox.widget {
            {
                align = "center",
                valign = "center",
                font = beautiful.fontname .. " 13",
                widget = wibox.widget.textbox
            },
            bg = "#00000000",
            widget = wibox.container.background
        })
    end
    local function calendar_update(e)
        month_offset = e and (month_offset + e) or 0
        awful.spawn.easy_async_with_shell(
            -- the $(date +%%Y-%%m-1) is for acquiring the correct month in case of invalid dates
            -- (e.g. "march 31" - "1 month" = "march 1", see 'info date')
            string.format(
                "date +\"%%d\";" ..  -- today
                -- Day of week for the first day, required for right align
                "date -d \"$(date +%%Y-%%m-1) %d month\" +\"%%w\";" ..
                -- The calendar of the month
                "date -d \"$(date +%%Y-%%m-1) %d month\" +\"%%m %%Y\" | xargs cal",
                month_offset, month_offset
            ),
            function(stdout)
                row = 1
                for s in string.gmatch(stdout, "([^\n]+)") do
                    if row == 1 then
                        today = tonumber(s)
                    elseif row == 2 then
                        firstday = tonumber(s + 1)
                    elseif row == 3 then
                        calendar_title:set_text(s:match("^%s*(.-)%s*$"))
                    else
                        -- TODO: use find to improve the procedure here (reduce the code duplications)
                        -- ( hint: find items one by one within two for loops )
                        col = 1
                        -- right align the first week, set empty before the first day
                        if row - 3 == 2 then
                            while col < firstday do
                                tile = calendar_grid:get_widgets_at(2, col)[1]
                                tile.children[1]:set_text("")
                                col = col + 1
                            end
                        end
                        for d in string.gmatch(s, "(%S+)") do
                            tile = calendar_grid:get_widgets_at(row - 3, col)[1]
                            tile.children[1]:set_text(d)
                            if tonumber(d) == today and month_offset == 0 then
                                tile.bg = beautiful.bg_focus .. "40"
                            else
                                tile.bg = "#00000000"
                            end
                            col = col + 1
                        end
                        -- set empty after the last day
                        while col <= 7 do
                            tile = calendar_grid:get_widgets_at(row - 3, col)[1]
                            tile.children[1]:set_text("")
                            col = col + 1
                        end
                    end
                    row = row + 1
                end
            end
        )
    end
    local function cal_button(icon, e)
        return wibox.widget{
            icon = icon,
            buttons = { awful.button( {}, 1, function() calendar_update(e) end) },
            widget = icon_button
        }
    end
    local calendar_popup = wibox ({
        widget = {
            {
                {
                    cal_button(beautiful.icon_cal_prev_year, -12),
                    cal_button(beautiful.icon_cal_prev_month, -1),
                    layout = wibox.layout.fixed.horizontal
                },
                clickable(calendar_title),
                {
                    cal_button(beautiful.icon_cal_next_month, 1),
                    cal_button(beautiful.icon_cal_next_year, 12),
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
        type = "dock",
        width = calendar_grid.forced_width,
        height = calendar_grid.forced_height + beautiful.bar_size
    })

    clock:buttons { awful.button( {}, 1, function()
        calendar_popup.x = mouse.screen.leftbar.x + beautiful.bar_size
        calendar_popup.y = mouse.screen.geometry.height - calendar_popup.height
        calendar_popup.visible = not calendar_popup.visible
        calendar_update()
    end) }
    calendar_title:buttons { awful.button( {}, 1, function() calendar_update() end ) }
    calendar_grid:buttons { awful.button( {}, 4, function() calendar_update(1) end),
                            awful.button( {}, 5, function() calendar_update(-1) end) }
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
    hide_button:buttons { awful.button({}, 1, function()
        tray.visible = not tray.visible
        hide_button:set_icon(beautiful.icon_tray[tray.visible])
    end) }
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

    box:buttons {
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.tag.incgap(-beautiful.useless_gap_inc) end),
        awful.button({ }, 5, function () awful.tag.incgap( beautiful.useless_gap_inc) end)
    }
    return box
end
-- }}}
-- launcher {{{
local function launcher()
    local button = icon_button(beautiful.menuicon)
    button:buttons { awful.button({ }, 1, function()
        awful.spawn("rofi -show drun -theme launcher")
    end) }
    return button
end
-- }}}
-- new term button {{{
local function newterm_button()
    local button = icon_button(beautiful.newterm)
    button:buttons { awful.button({}, 1, function()
        awful.spawn(config.terminal)
    end) }
    return button
end
-- }}}
-- notification center {{{
-- Another thought:
-- Scroll discretely (not continuous). Use the slider widget as a scroll bar. Here is a demo:
local function notifhub()
    local notifications = {}
    for i = 1, 9 do
        -- table.insert(notifications, naughty.layout.box {
        --     notification = naughty.notify({text = "test"})
        -- })
        table.insert(notifications, wibox.widget.textbox(
            string.format("No. %d\n\tSomething", i)
        ))
    end
    local slider = wibox.widget{
        maximum = 20,
        minimum = 1,
        forced_height = 24,
        forced_width = 24,
        handle_width = 48,
        handle_color = "#808080",
        bar_height = 24,
        bar_shape = gears.shape.rectangle,
        bar_color = "#202020",
        bar_active_color = "#202020",
        bar_margins = 0,
        widget = wibox.widget.slider,
    }
    local notification_list = wibox.widget {
        layout = wibox.layout.fixed.vertical
    }
    local notification_area = wibox.widget {
        nil,
        notification_list,
        {
            slider,
            direction = "west",
            forced_height = beautiful.bar_size,
            widget = wibox.container.rotate
        },
        layout = wibox.layout.align.horizontal
    }
    notification_area:buttons {
        awful.button( {}, 4, function() slider.value = slider.value - 1 end ),
        awful.button( {}, 5, function() slider.value = slider.value + 1 end ),
    }
    slider:connect_signal('property::value', function()
        local index = slider.value
        notification_list:reset()
        for i = index, index + 9 do
            if notifications[i] then
                notification_list:add(notifications[i])
            end
        end
        local last = notifications[#notification_list.children + index - 1]
    end)
    wibox {
        widget = notification_area,
        x = 300, y = 300,
        width = 360, height = 360,
        bg = "#404040",
        visible = true
    }
    slider.value = 1
    return notification_area
end
-- notifhub()
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
            -- 6 is the number of widgets on the right
            forced_width = bar.width - 6 * beautiful.bar_size,
            s.mytasklist,
            newterm_button(),
        },
        nil,
        {
            alsa_widget.indicator,
            light_widget.indicator,
            imap_widget.indicator,
            net_widget.indicator,
            battery_widget.indicator,
            layoutbox(s),
            layout = wibox.layout.fixed.horizontal,
        },
    }
    bar:struts({ top = beautiful.bar_size })
    function bar:toggle()
        if self.visible then
            self.flag_hidden = true
            self.visible = false
        else
            self.flag_hidden = false
            self.visible = true
        end
    end
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
    bar:buttons {
        awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
        awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
    }
    bar:setup {
        {
            wibox.widget {
                    s.leftpanel.toggle_button,
                bg = beautiful.blue,
                widget = wibox.container.background,
            },
            s.mytaglist,
            layout = wibox.layout.fixed.vertical,
        },
        nil,
        {
            systray(),
            datetime(),
            launcher(s),
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
        width = beautiful.panel_size,
        height = s.geometry.height,
        bg = beautiful.bg_normal .. "80",
        visible = false,
        ontop = true,
        type = "dock",
    }
    panel:setup {
        {
            wibox.widget{
                icon = beautiful.closebutton,
                buttons = { awful.button({}, 1, function() panel:toggle() end) },
                widget = icon_button
            },
            icon_button(),
            icon_button(),
            icon_button(),
            icon_button(),
            icon_button(),
            icon_button(),
            icon_button(),
            layout = wibox.layout.flex.horizontal,
        },
        {
            battery_widget,
            cpu_widget,
            mem_widget,
            alsa_widget,
            light_widget,
            net_widget,
            imap_widget,
            mpd_widget,
            -- spacing = 24,
            layout = wibox.layout.fixed.vertical,
        },
        nil,
        layout = wibox.layout.align.vertical
    }

    local toggle_button = icon_button(beautiful.sidebar_open)

    function panel:toggle()
        self.visible = not self.visible
        if self.visible then
            toggle_button:set_icon(beautiful.sidebar_close)
            s.leftbar.flag_hidden = not s.leftbar.visible
            s.leftbar.x = s.geometry.x + self.width
            -- a little trick to put leftbar's shadow above leftpanel
            s.leftbar.visible = false
            s.leftbar.visible = true
        else
            toggle_button:set_icon(beautiful.sidebar_open)
            s.leftbar.x = s.geometry.x
            if s.leftbar.flag_hidden then
                s.leftbar.visible = false
                s.leftbar.flag_hidden = false
            end
        end
    end

    toggle_button:buttons { awful.button({}, 1, function() panel:toggle() end) }
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
