-- LSP configs
local server_config = {
    bashls = { },
    clangd = { },
    fortls = { },
    marksman = { },
    pylsp = { settings = { pylsp = {
        rope = { ropeFolder = os.getenv("HOME").."/.cache/rope" },
        ruff = { enabled = true, formatEnabled = true, preview = true },
    }}},
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
    vimls = { },
    wolfram_lsp = { },
}

return {
    {
        'neovim/nvim-lspconfig',
        event = { "BufReadPre", "BufNewFile" },  -- from LazyVim
        -- event = "BufReadPre",  -- from LazyVim
        -- cmd = { "LspInfo", "LspStart" },
        config = function()
            local lsp = require('lspconfig')
            local configs = require("lspconfig.configs")
            configs.wolfram_lsp = {
                default_config = {
                    cmd = {
                        "wolfram", "kernel",
                        "-noinit", "-noprompt", "-nopaclet",
                        "-noicon", "-nostartuppaclets",
                        "-run", 'Needs["LSPServer`"];LSPServer`StartServer[]',
                    },
                    filetypes = { "mma" },
                    root_dir = lsp.util.path.dirname,
                },
            }
            for server, config in pairs(server_config) do
                lsp[server].setup(config)
            end
        end,
    },
}
