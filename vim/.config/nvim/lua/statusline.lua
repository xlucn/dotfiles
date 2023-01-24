local lsp_hl = {
    ['E'] = 'StatuslineError',
    ['W'] = 'StatuslineWarning',
    ['I'] = 'StatuslineInfo',
    ['H'] = 'StatuslineHint',
}

local lsp_status = function()
    local messages, count = {}, 0
    local lsp = { string = 'OK', hl = 'StatuslineOuter' }
    local levels = { H = 'HINT', I = 'INFO', W = 'WARN', E = 'ERROR' }

    for _, key in ipairs({ "H", "I", "W", "E" }) do
        count = #vim.diagnostic.get(0, {
            severity = vim.diagnostic.severity[levels[key]]
        })
        if count > 0 then
            table.insert(messages, 1, key .. ':' .. count)
            lsp.hl = lsp_hl[key]
        end
    end
    if #messages > 0 then
        lsp.string = table.concat(messages, ' ')
    end
    return lsp
end

local git_branch = function()
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
    if master == nil then return "" end

    master = string.gsub(master, '.*/', '')
    -- commit hash
    if string.match(master, '%x+') == master then
        master = string.sub(master, 0, 7)
    end
    return master
end

local mode_str = {
    ['c'] = { string = 'COMMAND', hl = 'StatuslineCommand' },
    ['i'] = { string = 'INSERT', hl = 'StatuslineInsert' },
    ['n'] = { string = 'NORMAL', hl = 'StatuslineNormal' },
    ['R'] = { string = 'REPLACE', hl = 'StatuslineReplace' },
    ['s'] = { string = 'SELECT', hl = 'StatuslineVisual' },
    ['t'] = { string = 'TERMINAL', hl = 'StatuslineTerminal' },
    ['v'] = { string = 'VISUAL', hl = 'StatuslineVisual' },
    ['V'] = { string = 'V-LINE', hl = 'StatuslineVisual' },
    [''] = { string = 'S-BLOCK', hl = 'StatuslineVisual' },
    [''] = { string = 'V-BLOCK', hl = 'StatuslineVisual' },
}

local mode_string_hl = function()
    local mode = vim.api.nvim_get_mode().mode
    mode = string.sub(mode, 0, 1)
    return mode_str[mode] or { string = mode, hl = 'StatuslineNormal' }
end

local highlighted = function(hl_string)
    if string.len(hl_string.string) == 0 then return "" end
    return string.format("%%#%s# %s %%*", hl_string.hl, hl_string.string)
end

local statusline = function()
    local mode = mode_string_hl()
    local git = git_branch()
    local file = '%t %m %w %r %h %= %{&ff}%( | %{&fenc}%)%( | %{&ft}%)'
    local pos = "%p%% | %l:%v"
    local lsp = lsp_status()

    local segments = {
        highlighted(mode),
        highlighted({ hl = 'StatuslineMiddle', string = git }),
        highlighted({ hl = 'StatuslineInner',  string = file }),
        highlighted({ hl = 'StatuslineMiddle', string = pos }),
        highlighted(lsp),
    }

    return table.concat(segments)
end

vim.api.nvim_set_hl(0, 'StatuslineInner', { ctermbg = 0 })
vim.api.nvim_set_hl(0, 'StatuslineMiddle', { ctermbg = 8 })
vim.api.nvim_set_hl(0, 'StatuslineOuter', { ctermbg = 6, ctermfg = 0 })

vim.api.nvim_set_hl(0, 'StatuslineNormal', { ctermfg = 0, ctermbg = 6 })
vim.api.nvim_set_hl(0, 'StatuslineInsert', { ctermfg = 0, ctermbg = 4 })
vim.api.nvim_set_hl(0, 'StatuslineVisual', { ctermfg = 0, ctermbg = 3 })
vim.api.nvim_set_hl(0, 'StatuslineReplace', { ctermfg = 0, ctermbg = 1 })
vim.api.nvim_set_hl(0, 'StatuslineCommand', { ctermfg = 0, ctermbg = 2 })
vim.api.nvim_set_hl(0, 'StatuslineTerminal', { ctermfg = 0, ctermbg = 5 })

vim.api.nvim_set_hl(0, 'StatuslineError', { ctermfg = 0, ctermbg = 1 })
vim.api.nvim_set_hl(0, 'StatuslineWarning', { ctermfg = 0, ctermbg = 3 })
vim.api.nvim_set_hl(0, 'StatuslineInfo', { ctermfg = 0, ctermbg = 4 })
vim.api.nvim_set_hl(0, 'StatuslineHint', { ctermfg = 0, ctermbg = 6 })

local stl_group = vim.api.nvim_create_augroup('Statusline', { clear = true })
vim.api.nvim_create_autocmd(
    { 'WinEnter', 'BufEnter', 'DiagnosticChanged', 'ModeChanged' },
    { group = stl_group, callback = function() vim.o.stl = statusline() end }
)
