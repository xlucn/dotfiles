local gears = require("gears")

local config = {}

------------------------------------------------------------
--
-- Something you might want to change
--
------------------------------------------------------------

config.modkey = "Mod4"
config.terminal = "st"
config.terminal_editor = "vim"


-- The font name to use, could specify style but not size
config.fontname = "Hack Bold"


---- Icons
-- Use font or images for icons, see theme.lua for all icons choices
--    true: use font characters (currently mdi icon fonts from nerdfont)
--    false: svg icons from system icon theme
config.use_font_icon = true

-- Icon theme for
-- 1. beautiful.icon_theme, which affects menu, tasklist icons, etc.
-- 2. widget icons will use this icon theme if config.use_font_icon = false
config.icon_theme = "Papirus-Dark"

-- Icon Font for widgets
-- The font characters set in theme.lua should match this font,
--     if you want to use another font, you have to change all the icons
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


-- change it if your terminal does not work
-- e.g. termite needs quotes around command
config.terminal_run = function(cmd)
    return config.terminal .. " -e " .. cmd
end

config.editor_cmd = function(file)
    return config.terminal_run(config.terminal_editor .. " " .. file)
end


-- Default client shape
-- The shape always change to rectangle in the following cases:
--      fullscreen
--      maximazed
--      firefox main window, you can add/change other browsers in rules.
config.client_shape = gears.shape.rounded_rect


return config
