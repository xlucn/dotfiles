local colors = { }
local index, color, name, color_name

for line in io.popen('xrdb -query'):lines() do
    name, color = line:match("%*%.?(.+):.*(#[0-9a-fA-F]+)")
    if name ~= nil then
        index = name:match("color([0-9]+)")

        if index ~= nil then
            color_name = 'color_' .. index
        elseif name == "background" then
            color_name = 'color_background'
            color_name = 'color_cursor_foreground'
        elseif name == "foreground" then
            color_name = 'color_foreground'
        elseif name == "cursorColor" then
            color_name = 'color_cursor'
        end

        if color_name ~= nil then
            colors[color_name] = color
        end
    end
end

return colors
