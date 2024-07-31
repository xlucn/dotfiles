-- LSP configs
local server_config = {
    bashls = { },
    clangd = { },
    fortls = { },
    lsp_wl = { },
    marksman = { },
    pylsp = { settings = { pylsp = {
        rope = { ropeFolder = os.getenv("HOME").."/.cache/rope" },
        ruff = { enabled = true, formatEnabled = true },
    }}},
    -- ruff = { },
    lua_ls = { settings = { Lua = {
        diagnostics = { globals = { 'vim' } }
    }}},
    texlab = { settings = { texlab = {
        build = {
            executable = "latexmk",
            args = { "-synctex=1", "-interaction=nonstopmode", "%f" },
            onSave = true,
            forwardSearchAfter = true,
            auxDirectory = "./output",
            logDirectory = "./output",
            pdfDirectory = "./output",
        },
        forwardSearch = {
            executable = "zathura",
            args = { "--synctex-forward", "%l:1:%f", "%p" },
        },
        chktex = { onOpenAndSave = false, },
        diagnostics = {
            ignoredPatterns = {
                'Unused label',
                'Unused entry',
            },
        },
        experimental = {
            mathEnvironments = { 'align' },
            citationCommands = { 'parencite' },
        },
    }}},
    vimls = { }
}

return {
    {
        'neovim/nvim-lspconfig',
        config = function()
            local lsp = require('lspconfig')
            for server, config in pairs(server_config) do
                lsp[server].setup(config)
            end
        end
    },
}
