-- luacheck: globals mp
-- default keybinding: b
-- add the following to your input.conf to change the default keybinding:
-- keyname script_binding auto_load_subs
local utils = require 'mp.utils'

local function load_sub_fn()
    local path = mp.get_property("path")
    local srt_path = string.gsub(path, "%.%w+$", ".srt")
    local cmd_path = os.getenv("HOME") .. "/.local/bin/subliminal"
    local t = { args = { cmd_path , "download", "-s", "-f", "-l", "en", "-r", "metadata", path } }

    mp.osd_message("Searching subtitle")
    local res = utils.subprocess(t)
    if res.error == nil and mp.commandv("sub_add", srt_path) then
        mp.msg.warn("Subtitle download succeeded")
        mp.osd_message("Subtitle '" .. srt_path .. "' download succeeded")
    else
        mp.msg.warn("Subtitle download failed: ")
        mp.osd_message("Subtitle download failed")
    end
end

mp.add_key_binding("b", "auto_load_subs", load_sub_fn)
