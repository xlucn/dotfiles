local config = {}

---- Icons
-- Use font or images, see theme.lua for all icons used in bars and panels
--      true: svg icons from system icon theme, e.g. /usr/share/icons
--      false: use font characters from fonts installed on system
config.use_image_icon = true

-- Icon theme AwesomeWM-wide
config.icon_theme = "Papirus-Dark"

-- Icon Font. Note: The font characters set in theme.lua should match this font,
config.icon_font = "Material Design Icons"

-- The font name to use, could specify style (e.g. Hack Bold) but not size
config.fontname = "Monospace Bold"

-- Mod4: Super key or Win key; Mod1: Alt
config.modkey = "Mod4"

-- Terminal emulator
config.terminal = "st"
-- Command to spawn floating terminal. Set to nil if it supports startup notifications
config.floating_terminal = "st -c floating_terminal"
-- Text editor in terminal
config.terminal_editor = "vim"

config.editor_cmd = function(file)
    return string.formatconfig.terminal .. " -e " .. config.terminal_editor .. " " .. file
end

---- Appearences
-- The basic size for widgets. The panel size.
-- This value will be applied dpi so don't do it here (TODO: maybe do it here?)
config.basic_size = 48

---- Widgets configuration
-- Email addresses TODO: search folder for email adds
config.imap_emails = {
    "oliver_lew@outlook.com",
    "2869761396@qq.com",
}

-- MPD host
config.mpd_host = "localhost:6600"

-- ALSA channel
config.alsa_channel = "Master"

-- Email client, use neomutt if available otherwise mutt
config.mutt = os.execute("command -v neomutt > /dev/null") and "neomutt" or "mutt"

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

return config
