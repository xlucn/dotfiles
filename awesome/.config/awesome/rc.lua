-- luacheck: globals awesome client root timer screen mouse button drawin drawable tag key

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
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- menu
local menu_utils = require("menubar.utils")
local menu_gen = require("menubar.menu_gen")
-- my own widgets
local mywidgets = require("widgets")
local xrandr = require("xrandr")
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
local terminal = "urxvtc"
local filemanager = "nemo"
local browser = "firefox"
local editor = os.getenv("EDITOR") or "vim"
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
local rofi_basic = "rofi -modi drun,window,run"
local rofi_drun = "rofi -theme launcher -show drun"
local rofi_run = rofi_basic .. " -show run"
local rofi_window = rofi_basic .. " -show window"

-- maim (screenshot tool) commands
local maim_basic = "maim"
-- target
local maim_selection = " -s"
-- location
local maim_savefile = " ~/Pictures/Screenshot_$(date +%F_%H-%M-%S).png"
local maim_clipboard = " | xclip -selection clipboard -t image/png"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local altkey = "Mod1"
local modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.floating,
}

-- Tag names
local tag1 = " " .. beautiful.nerdfont_terminal  .. " "
local tag2 = " " .. beautiful.nerdfont_browser   .. " "
local tag3 = " " .. beautiful.nerdfont_book      .. " "
local tag4 = " " .. beautiful.nerdfont_briefcase .. " "
local tag5 = " " .. beautiful.nerdfont_files     .. " "
local tag6 = " " .. beautiful.nerdfont_movie     .. " "
local tag7 = " " .. beautiful.nerdfont_email     .. " "
local tag8 = " " .. beautiful.nerdfont_terminal  .. " "
local tag9 = " " .. beautiful.nerdfont_terminal  .. " "

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
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu

-- some configurations
menu_utils.terminal = terminal
menu_gen.all_menu_dirs = {
    '/usr/share/applications/',
    '/usr/local/share/applications/',
    os.getenv("HOME") .. '/.local/share/applications'
}

local default_icon = menu_utils.lookup_icon("application-default-icon")
local terminal_icon = menu_utils.lookup_icon("terminal")
local browser_icon = menu_utils.lookup_icon("applications-webbrowsers")
local fm_icon = menu_utils.lookup_icon("system-file-manager")
local config_icon = menu_utils.lookup_icon("system-config-services")
local restart_icon = menu_utils.lookup_icon("system-restart")
local shutdown_icon = menu_utils.lookup_icon("system-shutdown")
local shortcut_icon = menu_utils.lookup_icon("system-config-keyboard")
local help_icon = menu_utils.lookup_icon("system-help")

local myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end, shortcut_icon },
   { "manual", "xdg-open /usr/share/doc/awesome/doc/index.html", help_icon},
   { "edit config", terminal_cmd(editor_cmd(awesome.conffile)), config_icon },
   { "restart", awesome.restart, restart_icon },
   { "quit", function() awesome.quit() end, shutdown_icon}
}

local result = {}
local mymainmenu      = awful.menu()
mymainmenu:add({ "awesome", myawesomemenu, beautiful.awesome_icon, })
mymainmenu:add({ "open terminal (" .. terminal .. ")", terminal, terminal_icon })
mymainmenu:add({ "open browser (" .. browser.. ")", browser, browser_icon })
mymainmenu:add({ "open file manager (".. filemanager .. ")", filemanager, fm_icon })

-- Modified from https://github.com/lcpz/awesome-freedesktop/blob/master/menu.lua
menu_gen.generate(function(entries)
    -- Add categories
    for k, v in pairs(menu_gen.all_categories) do
        table.insert(result, { k, {}, v.icon })
    end

    -- Add applications
    for _, v in pairs(entries) do
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

-- systray {{{
local systray = wibox.widget.systray()
local mysystray = wibox.widget {
    systray,
    top = (beautiful.wibox_height - beautiful.systray_height) / 2,
    bottom = (beautiful.wibox_height - beautiful.systray_height) / 2,
    layout = wibox.container.margin
}
--}}}

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
        awful.button({ }, 4, function () awful.tag.incgap(-8) end),
        awful.button({ }, 5, function () awful.tag.incgap(8) end)
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
                    forced_width = beautiful.wibox_height + 28,
                    left = 16,
                    right = 16,
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
            s.mytasklist,
        },
        -- Middle widget
        nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = 16,
            mywidgets.mpd.widget,
            mywidgets.imap.widget,
            mywidgets.alsa.widget,
            mywidgets.light.widget,
            mywidgets.cpu.widget,
            mywidgets.mem.widget,
            wibox.widget.textclock(),
            mywidgets.net.widget,
            mywidgets.bat.widget,
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
local globalkeys = gears.table.join(
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
    awful.key({ modkey, "Control" }, "=", function () awful.tag.incgap(8) end,
              {description = "increase gap", group = "awesome"}),
    awful.key({ modkey, "Control" }, "-", function () awful.tag.incgap(-8) end,
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
    awful.key({ modkey, "Control" }, "l",  function () awful.spawn("dm-tool switch-to-greeter") end,
              {description = "lock screen", group = "awesome"}),
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
    --awful.key({ modkey }, "p", function() xrandr.xrandr() end,
              --{description = "swap arrangements of monitors", group = "screen"}),
    --awful.key({ }, "XF86Display", function() xrandr.xrandr() end,
              --{description = "swap arrangements of monitors", group = "screen"}),
    awful.key({ modkey }, "p", function() awful.spawn("setmonitor") end,
              {description = "swap arrangements of monitors", group = "screen"}),
    awful.key({ }, "XF86Display", function() xrandr.xrandr() end,
              {description = "swap arrangements of monitors", group = "screen"}),

    -- XF86 keys
    awful.key({}, "XF86AudioMute", mywidgets.alsa.toggle,
              {description = "toggle mute", group = "Media"}),
    awful.key({}, "XF86AudioRaiseVolume", mywidgets.alsa.up,
              {description = "volume up", group = "Media"}),
    awful.key({}, "XF86AudioLowerVolume", mywidgets.alsa.down,
              {description = "volume down", group = "Media"}),
    awful.key({ modkey }, "\\", mywidgets.alsa.toggle,
              {description = "toggle mute", group = "Media"}),
    awful.key({ modkey }, "]", mywidgets.alsa.up,
              {description = "volume up", group = "Media"}),
    awful.key({ modkey }, "[", mywidgets.alsa.down,
              {description = "volume down", group = "Media"}),
    awful.key({}, "XF86MonBrightnessDown", mywidgets.light.down,
              {description = "brightness down", group = "Media"}),
    awful.key({}, "XF86MonBrightnessUp", mywidgets.light.up,
              {description = "brightness up", group = "Media"}),
    awful.key({ modkey }, "-", mywidgets.light.down,
              {description = "brightness down", group = "Media"}),
    awful.key({ modkey }, "=", mywidgets.light.up,
              {description = "brightness up", group = "Media"}),

    -- Application launching
    awful.key({ modkey }, "f", function () awful.spawn(terminal_cmd("ranger")) end,
              {description = "launch file manager", group = "launcher"}),
    awful.key({ modkey }, "e", function () awful.spawn(terminal_cmd("abduco -A neomutt neomutt")) end,
              {description = "launch email client", group = "launcher"})
)

local clientkeys = gears.table.join(
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

local clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    { -- All clients will match this rule.
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            size_hints_honor = false,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        },
        -- for debug
        -- callback = function(c)
        --     naughty.notify({text = "instance: " .. c.instance .. "\n" ..
        --                            "class: " .. c.class .. "\n" ..
        --                            "name: " .. c.name .. "\n" ..
        --                            "role: " .. c.role, timeout = 15})
        -- end
    },

    { -- Add titlebars to normal clients and dialogs
        rule_any = {
            type = { "normal", "dialog" }
        },
        properties = {
            titlebars_enabled = true
        }
    },

    { -- borderless
        rule = { class = "Nemo", instance = "file_progress" },
        properties = { ontop = true }
    },

    { -- Floating clients
        rule_any = {
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
        },
        properties = {
            floating = true,
            ontop = true,
            placement = awful.placement.centered
        },
    },

    { -- Fullscreen and screen management for pdfpc
        rule = { class = "Pdfpc" },
        properties = { fullscreen = true },
        -- This callback will *magically* put presentation to the secondary
        -- screen and leave the presenter console on the current screen.
        callback = function(c) c:move_to_screen() end
    },

    { -- Set Firefox to always map on the tag 2.
        rule = {
            --class = "Firefox",
            role = "browser",
            instance = "Navigator"
        },
        properties = {
            tag = tag2,
            titlebars_enabled = false,
        }
    },

    { -- firefox picture-in-picture window
        rule = {
            class = "firefox",
            instance = "Toolkit",
            role = "PictureInPicture",
        },
        properties = {
            sticky = true,
            floating = true,
        },
    }
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
local t = timer({ timeout = 60 })
t:connect_signal("timeout", function()
  collectgarbage()
  logfile:write(os.date(), "\nLua memory usage:", collectgarbage("count"), "\n")
  logfile:write("Objects alive:\n")
  for name, obj in pairs{ button = button,
                          client = client,
                          drawable = drawable,
                          drawin = drawin,
                          key = key,
                          screen = screen,
                          tag = tag } do
    logfile:write(name, ": ", obj.instances(), "\n")
  end
  logfile:flush()
end)
t:start()
t:emit_signal("timeout")
-- }}}

-- vim:foldmethod=marker:foldlevel=0
