local config = {}

------------------------------------------------------------
--
-- Something you might want to change
--
------------------------------------------------------------

config.modkey = "Mod4"
config.terminal = "st"
config.mutt = "neomutt"  -- mutt or neomutt to use for emails
-- The font name to use, could specify style but not size
config.fontname = "Hack Nerd Font Bold"

-- rofi (launcher tool) commands
config.rofi_drun = "rofi -modi drun -show drun -theme launcher"
                -- .. " -theme-str \"#window {"
                -- .. "    location: south east;"
                -- .. "    width: " .. width .. "px;"
                -- .. "    height: " .. height .. "px;"
                -- .. "}\""
config.rofi_run = "rofi -show run"

-- Screenshot commands
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

-- Use font or images for icons, see theme.lua for all icons choices
--    true: use font characters (currently mdi icon fonts from nerdfont)
--    false: svg icons from system icon theme
config.use_font_icon = true
-- Icon theme for
-- 1. beautiful.icon_theme, which affects menu, tasklist icons, etc.
-- 2. widget icons will use this icon theme if config.use_font_icon = false
config.icon_theme = "Papirus-Dark"

-- Widgets configuration
-- MPD host
config.mpd_host = "localhost:6600"
-- ALSA channel
config.alsa_channel = "Master"

------------------------------------------------------------
--
-- Something you might not have to change
--
------------------------------------------------------------

-- change it if your terminal does not work
-- e.g. termite needs quotes around command
config.terminal_cmd = function(cmd)
    return config.terminal .. " -e " .. cmd
end

config.editor_cmd = function(file)
    return config.terminal_cmd(os.getenv("EDITOR") or "vim" .. " " .. file)
end

return config
