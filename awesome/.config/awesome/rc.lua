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
local freedesktop = require("freedesktop")
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
-- This is used later as the default terminal and editor to run.
terminal = "termite"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- rofi commands
rofi_basic = "rofi -theme gruvbox-dark-soft"
rofi_drun = rofi_basic .. " -modi drun,ssh,window -show drun -show-icons"
rofi_run = rofi_basic .. " -show run"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.floating,
}

-- Tag names
--tag1 = " Browr "
--tag2 = " Term "
--tag3 = " Class "
--tag4 = " Work "
--tag5 = " Note "
--tag6 = " Trnt "
--tag7 = " Media "
--tag8 = " Mail "
--tag9 = " Other "
tag1 = " " .. beautiful.nerdfont_browser   .. " "
tag2 = " " .. beautiful.nerdfont_terminal  .. " "
tag3 = " " .. beautiful.nerdfont_book      .. " "
tag4 = " " .. beautiful.nerdfont_briefcase .. " "
tag5 = " " .. beautiful.nerdfont_note      .. " "
tag6 = " " .. beautiful.nerdfont_download  .. " "
tag7 = " " .. beautiful.nerdfont_movie     .. " "
tag8 = " " .. beautiful.nerdfont_email     .. " "
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
-- format network speed
local function format_netspeed(raw_speed)
    if raw_speed < 1024 then
        speed = raw_speed
        speed_unit = "KB/s"
    elseif raw_speed < 1024 * 1024 then
        speed = raw_speed / 1024
        speed_unit = "MB/s"
    else
        speed = raw_speed / 1024 / 1024
        speed_unit = "GB/s"
    end

    return speed, speed_unit
end
-- format time
local function format_time(seconds)
    return string.format("%2d:%02d", seconds // 60, seconds % 60)
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e \"man awesome\"" },
   { "edit config", terminal .. " -e \"" .. editor .. " " .. awesome.conffile .. "\""},
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

--mymainmenu = awful.menu({ items = {
    --{ "awesome", myawesomemenu, beautiful.awesome_icon },
    --{ "open terminal", terminal }
--}})
mymainmenu = freedesktop.menu.build({
    before = {
        { "awesome", myawesomemenu, beautiful.awesome_icon },
    },
    after = {
        { "open terminal", terminal }
    }
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
--menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- {{{ Widgets
-- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
local mytextclock = wibox.widget.textclock()

-- lain widgets
local separators = lain.util.separators
local markup = lain.util.markup

local larrow = separators.arrow_left()

local mpd = lain.widget.mpd({
    timeout = 5,
    notify = "off",
    settings = function()
        mpd_notification_preset = {
            title   = "Now playing",
            timeout = 6,
            text    = string.format("%s\n%s (%s) - %s\n%s",
                                    mpd_now.file,
                                    mpd_now.artist,
                                    mpd_now.album,
                                    mpd_now.date,
                                    mpd_now.title)
        }
        -- time format
        if mpd_now.state == "play" or mpd_now.state == "pause" then
            elapsed = format_time(mpd_now.elapsed)
            time = format_time(mpd_now.time)
        else
            elapsed = "--:--"
            time = "--:--"
        end
        -- state
        if mpd_now.state == "play" then
            state = beautiful.nerdfont_music_pause -- "="
        elseif mpd_now.state == "pause" then
            state = beautiful.nerdfont_music_play -- ">"
        else
            state = beautiful.nerdfont_music_stop -- "x"
        end
        widget:set_markup(
            markup.font(beautiful.widgets_nerdfont,
                        beautiful.nerdfont_music .. " " ..
                        beautiful.nerdfont_music_prev .. " " ..
                        state .. " " ..
                        beautiful.nerdfont_music_next)
        )
    end
})
mpd.widget:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        awful.spawn.with_shell("mpc toggle")
        mpd.update()
    end),
    awful.button({}, 3, function()
        awful.spawn(terminal .. " -e ncmpcpp")
    end),
    awful.button({}, 4, function()
        awful.spawn.with_shell("mpc seek +10")
        mpd.update()
    end),
    awful.button({}, 5, function()
        awful.spawn.with_shell("mpc seek -10")
        mpd.update()
    end)
))
mpd.update()
local testbar = wibox.widget {
    color            = beautiful.fg_normal,
    background_color = beautiful.bg_normal,
    margins          = beautiful.progressbar_margins,
    paddings         = beautiful.progressbar_paddings,
    ticks            = true,
    ticks_gap        = beautiful.progressbar_ticks_gap,
    ticks_size       = beautiful.progressbar_ticks_size,
    forced_height    = 1,
    forced_width     = beautiful.progressbar_width,
    widget           = wibox.widget.progressbar,
}
volume_bar_height = 10
volume_bar_margin = (beautiful.wibox_height - volume_bar_height) / 2
volume_bar = wibox.container.margin(
    wibox.container.background(
        testbar,
        beautiful.fg_normal,
        gears.shape.rectangle
    ),
    4, 4, volume_bar_margin, volume_bar_margin
)
local volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "on" then
            state = beautiful.nerdfont_volume_high
            volume_level = string.format("%3d%%", volume_now.level)
        else
            state = beautiful.nerdfont_volume_mute
            volume_level = "Mute" .. volume_now.level
        end
        testbar:set_value(volume_now.level / 100)
        widget:set_markup(markup.font(beautiful.widgets_nerdfont, state))
    end
})
volume_bar:buttons(awful.util.table.join(
    awful.button({}, 1, function() -- left click
        os.execute(string.format("%s set %s toggle", volume.cmd, volume.togglechannel or volume.channel))
        volume.update()
    end),
    awful.button({}, 2, function() -- middle click
        os.execute(string.format("%s set %s 100%%", volume.cmd, volume.channel))
        volume.update()
    end),
    awful.button({}, 3, function() -- right click
        awful.spawn(string.format("%s -e alsamixer", terminal))
    end),
    awful.button({}, 4, function() -- scroll up
        os.execute(string.format("%s set %s 2%%+", volume.cmd, volume.channel))
        volume.update()
    end),
    awful.button({}, 5, function() -- scroll down
        os.execute(string.format("%s set %s 2%%-", volume.cmd, volume.channel))
        volume.update()
    end)
))

local mybattery = lain.widget.bat({
    notify = "off",
    settings = function()
        widget:set_markup(
            string.format("%s %3d%%",
                markup.font(beautiful.widgets_nerdfont,
                            beautiful.nerdfont_bat_full),
                bat_now.perc))
    end
})
local mycpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(string.format("Cpu: %2d%%", cpu_now.usage))
    end
})
local mymem = lain.widget.mem({
    settings = function()
        widget:set_markup(
            string.format("%s %2d%%",
                          markup.font(beautiful.widgets_nerdfont,
                                      beautiful.nerdfont_memory),
                          mem_now.perc))
    end
})
local mysysload = lain.widget.sysload({
    settings = function()
        widget:set_markup(string.format("Load: %.2f %.2f %.2f",
                                        load_1, load_5, load_15))
    end
})
local mycal = lain.widget.cal({
    attach_to = { mytextclock },
    notification_preset = {
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal
    }
})
mytextclock:disconnect_signal("mouse::enter", mycal.hover_on)
local mynet = lain.widget.net({
    wifi_state = "on",
    eth_state = "on",
    settings = function()
        sent, sent_unit = format_netspeed(tonumber(net_now.sent))
        received, received_unit = format_netspeed(tonumber(net_now.received))
        widget:set_markup(
            string.format("%s%5.1f %s %s%5.1f %s",
                          markup.font(beautiful.widgets_nerdfont,
                                      beautiful.nerdfont_upspeed),
                          sent, sent_unit,
                          markup.font(beautiful.widgets_nerdfont,
                                      beautiful.nerdfont_downspeed),
                          received, received_unit
            )
        )
    end
})
local seperator = {
    orientation = "vertical",
    color = beautiful.fg_normal,
    thickness = 2,
    widget = wibox.widget.separator,
}

-- awesome-wm-widgets
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
local volumearc_widget = require("awesome-wm-widgets.volumearc-widget.volumearc")
local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")
-- }}}

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
              s,
              awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
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
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

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
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        --nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            {
                spacing = 8,
                layout = wibox.layout.fixed.horizontal,
                mpd.widget,
                mynet.widget,
                cpu_widget,
                --mycpu,
                ram_widget,
                --mymem,
                volumearc_widget,
                --volume,
                --volume_bar,
                --batteryarc_widget,
                --brightness_widget,
                --battery_widget,
                mybattery,
            },

            mytextclock,
            --wibox.container.margin(
                wibox.widget.systray(),
                --4, 4, 4, 4
            --)
            s.mylayoutbox,
        },
    }

end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)--,
    -- Don't switch views when scrolling on wallpaper
    --awful.button({ }, 4, awful.tag.viewnext),
    --awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
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
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- On the fly useless gaps change
    awful.key({ modkey, "Control" }, "=", function () lain.util.useless_gaps_resize(1) end,
              {description = "increase useless gap", group = "awesome"}),
    awful.key({ modkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end,
              {description = "decrease useless gap", group = "awesome"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

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

    -- Prompt
    awful.key({ modkey }, "d", function ()
            os.execute(rofi_drun)
        end,
        {description = "show rofi in drun modi", group = "launcher"}),

    awful.key({ modkey }, "r", function ()
            os.execute(rofi_run)
        end,
        {description = "run command in rofi", group = "launcher"}),

    awful.key({ modkey }, "x",
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

    -- XF86 keys
    awful.key({}, "XF86AudioMute", function() os.execute(volume_toggle) end,
        {description = "toggle mute", group = "media"}),
    awful.key({}, "XF86AudioRaiseVolume", function() os.execute(volume_up) end,
        {description = "volume up", group = "media"}),
    awful.key({}, "XF86AudioLowerVolume", function() os.execute(volume_down) end,
        {description = "volume down", group = "media"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
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
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true,
                        titlebars_enabled = true }},

    -- Add titlebars to normal clients and dialogs, or not
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag 1.
    { rule = { class = "Firefox" },
        properties = { tag = tag1 } },
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

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

---- Enable sloppy focus, so that focus follows mouse.
--client.connect_signal("mouse::enter", function(c)
    --if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        --and awful.client.focus.filter(c) then
        --client.focus = c
    --end
--end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- vim:foldmethod=marker:foldlevel=0
