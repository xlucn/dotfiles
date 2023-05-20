local convert = {
    background = { 'background', 'cursor_foreground' },
    foreground = { 'foreground' },
    cursorColor = { 'cursor' },
}
for i = 0, 15 do
    convert['color' .. i] = { i }
end

local colors = { }

local xrdb_query = nil -- io.popen('xrdb -query')
if xrdb_query == nil then
    local xresources = io.open(os.getenv('HOME')..'/.config/X11/Xresources')
    if xresources ~= nil then
        xrdb_query = xresources
    else
        return {}
    end
end

for line in xrdb_query:lines() do
    -- match '*[.]foo: #000000'
    local name, color = line:match("%*%.?(.+):%s*(#[0-9a-fA-F]+)")
    if convert[name] ~= nil then
        for _, var in ipairs(convert[name]) do
            colors['color_' .. var] = color
        end
    end
end
-- remember to close the handle, garbage collection might be forever
xrdb_query:close()
return colors
