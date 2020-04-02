local gears = require("gears")

local config = {}

------------------------------------------------------------
--
-- Something you might want to change
--
------------------------------------------------------------

-- Mod4: Super key or Win key; Mod1: Alt
config.modkey = "Mod4"
config.terminal = "st"
config.terminal_editor = "vim"


-- The font name to use, could specify style but not size
config.fontname = "Hack Bold"


---- Appearences
--
-- The basic size for a lot of other widgets.
-- This value will be applied dpi so don't do it here
config.basic_size = 48
-- Bars width or height
config.bar_size = config.basic_size
-- The width of side panel
config.panel_size = config.basic_size * 8

-- Colorscheme: use colors from gtk theme or Xresources
--      true: use colors from gtk theme
--      false: use colors from xresource
config.use_gtk_theme = false

---- Icons
-- Use font or images, see theme.lua for all icons in bars and panels
--      true: svg icons from system icon theme
--      false: use font characters
config.use_image_icon = true

-- Icon theme if use_image_icon is true
-- Note: beautiful.icon_theme will also be set to this, which affects menu, tasklist icons, etc.
config.icon_theme = "Papirus-Dark"

-- Icon Font if use_image_icon is false
-- Note: The font characters set in theme.lua should match this font,
--     if you want to use another font, you have to change all the icons there
config.icon_font = "Material Design Icons"


---- Widgets configuration
-- Email addresses. I might write the usage in README.md, go check it out :).
config.imap_emails = { "oliver_lew@outlook.com",
                       "2869761396@qq.com" }

-- Email client, mutt or neomutt
config.mutt = "neomutt"

-- MPD host
config.mpd_host = "localhost:6600"

-- ALSA channel
config.alsa_channel = "Master"


---- Screenshot commands
--
-- There will be 4 commands with different regions and destinations:
--      scrot_full .. scrot_save
--      scrot_full .. scrot_clip
--      scrot_rect .. scrot_save
--      scrot_rect .. scrot_clip

-- Command to take full screenshot
config.scrot_full = "scrot"

-- Command to interactively select screenshot region
config.scrot_rect = "sleep 0.2; scrot -s" -- sleep to fix issue for window managers

-- Appended options to save to file
config.scrot_save = " ~/Pictures/Screenshot_%F_%H-%M-%S.png"

-- Appended options to save to clipboard (selection)
config.scrot_clip = " -o /dev/stdout | xclip -selection clipboard -t image/png"



------------------------------------------------------------
--
-- Something you might not have to change
--
------------------------------------------------------------


-- Command to spawn a floating terminal (for st)
-- If the terminal support startup notifications (that is, if you can use
--     'properties' in 'awful.spawn' to make them floating), there is no need to
--     change the command.
-- There is a hack in rules to float any window with class name "floating_terminal"
if config.terminal == "st" then
    config.floating_terminal = "st -c floating_terminal"
else
    config.floating_terminal = config.terminal
end


-- change it if your terminal does not work
-- e.g. termite needs quotes around command
config.terminal_run = function(cmd, floating)
    return (floating and config.floating_terminal or config.terminal) .. " -e " .. cmd
end

config.editor_cmd = function(file)
    return config.terminal_run(config.terminal_editor .. " " .. file)
end


-- Rofi command to open a app launcher
-- This command will involve some widgets not seen here. Right, it's because
-- I don't know where else is better put this function for now :)
config.launcher_rofi_cmd = function(s)
    -- run rofi with the space left by bars and panels
    local topbar_offset = s.topbar and s.topbar.visible and config.bar_size or 0
    local leftbar_offset = s.leftbar and s.leftbar.visible and config.bar_size or 0
    local leftpanel_offset = s.leftpanel and s.leftpanel.visible and config.panel_size or 0
    local width = s.geometry.width - leftbar_offset - leftpanel_offset
    local height = s.geometry.height - topbar_offset
    return "rofi -modi drun -show drun -theme launcher"
        .. " -theme-str \"#window {"
        .. "    location: south east;"
        .. "    width: " .. width .. "px;"
        .. "    height: " .. height .. "px;"
        .. "}\""
end


-- Default client shape
-- The shape always change to rectangle in the following cases:
--      fullscreen
--      maximized
--      firefox main window, you can add/change other browsers in rules.
config.client_shape = gears.shape.rounded_rect


return config
