local lsp_status = function ()
    local messages, count = {}, 0
    local levels = { E = 'ERROR', W = 'WARN', I = 'INFO', H = 'HINT' }
    for key, severity in pairs(levels) do
        severity = vim.diagnostic.severity[severity]
        count = #vim.diagnostic.get(0, { severity = severity })
        if count > 0 then
            table.insert(messages, key .. ':' .. count)
        end
    end
    local msgstr = table.concat(messages, ' ')
    return string.len(msgstr) == 0 and 'OK' or msgstr
end

local git_branch = function ()
    -- look for .git/HEAD, might not work in all cases
    local path, fp, master
    local current_file = vim.fn.expand('%:p')
    local real_path = vim.fn.resolve(current_file)
    for seg in string.gmatch(real_path, '[^/]*') do
        path = table.concat({path or '', seg}, '/')
        fp = io.open(path .. '.git/HEAD')
        if fp ~= nil then
            master = fp:read()
            fp:close()
        end
    end
    if master == nil then return master end

    master = string.gsub(master, '.*/', '')
    -- commit hash
    if string.match(master, '%x+') == master then
        master = string.sub(master, 0, 7)
    end
    return master
end

local mode_string = function ()
    local mode_str = {
        ['c'] = 'COMMAND',
        ['i'] = 'INSERT',
        ['n'] = 'NORMAL',
        ['R'] = 'REPLACE',
        ['s'] = 'SELECT',
        ['t'] = 'TERMINAL',
        ['v'] = 'VISUAL',
        ['V'] = 'V-LINE',
        [''] = 'S-BLOCK',
        [''] = 'V-BLOCK',
    }
    local mode = vim.fn.mode()
    return mode_str[mode] or mode
end

vim.api.nvim_set_hl(0, 'User1', { ctermbg = 0 })
vim.api.nvim_set_hl(0, 'User2', { ctermbg = 8 })
vim.api.nvim_set_hl(0, 'User3', { ctermbg = 6, ctermfg = 0 })

local statusline = function ()
    local segments = {}
    -- vim modes
    table.insert(segments, '%3*')
    table.insert(segments, mode_string())
    -- git branch
    local branch = git_branch()
    if branch ~= nil then
        table.insert(segments, '%2*')
        table.insert(segments, branch)
    end
    -- file name and other indicators
    table.insert(segments, '%1*')
    table.insert(segments, '%t %m %w %r %h')
    -- file format, encoding and type
    table.insert(segments, '%=')
    table.insert(segments, '%{&ff}%( | %{&fenc}%)%( | %{&ft}%)')
    -- cursor location
    table.insert(segments, '%2*')
    table.insert(segments, '%p%% | %l:%v')
    -- lsp status
    local lsp = lsp_status()
    if lsp ~= nil then
        table.insert(segments, '%3*')
        table.insert(segments, lsp)
    end
    table.insert(segments, '%*')
    return table.concat(segments, ' ')
end

vim.o.stl = statusline()
local stl_group = vim.api.nvim_create_augroup('Statusline', { clear = true })
vim.api.nvim_create_autocmd(
    { 'WinEnter', 'BufEnter', 'DiagnosticChanged' },
    { group = stl_group, callback = function () vim.o.stl = statusline() end }
)
