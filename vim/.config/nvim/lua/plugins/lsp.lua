-- LSP configs
local server_config = {
    bashls = { },
    clangd = { },
    fortls = { },
    marksman = { },
    pylsp = { settings = { pylsp = {
        ruff = { enabled = true, formatEnabled = true, preview = true },
    }}},
    lua_ls = { settings = { Lua = {
        diagnostics = { globals = { 'vim' } }
    }}},
    texlab = {
        on_attach = function(_, bufnr)
            local function buf_set_keymap(key, cmd)
                vim.api.nvim_buf_set_keymap(bufnr, 'n', key, cmd, {
                    noremap = true, silent = true
                })
            end
            buf_set_keymap('<localleader>ll', '<cmd>TexlabBuild<CR>')
            buf_set_keymap('<localleader>lv', '<cmd>TexlabForward<CR>')
            buf_set_keymap('<localleader>lc', '<cmd>TexlabCleanAuxiliary<CR>')
            buf_set_keymap('<localleader>lC', '<cmd>TexlabCleanArtifacts<CR>')
            buf_set_keymap('<localleader>lr', '<cmd>TexlabChangeEnvironment<CR>')
        end,
        settings = { texlab = {
            build = {
                executable = "latexmk",
                args = { "-synctex=1", "-interaction=nonstopmode", "%f" },
                onSave = true,
                forwardSearchAfter = true,
                auxDirectory = "./output",
                logDirectory = "./output",
                pdfDirectory = ".",
            },
            forwardSearch = {
                executable = "evince-synctex",
                args = { "-f", "%l", "%p", "\"texlab inverse-search -i %f -l %l\"" },
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
        }},
    },
    ts_ls = { },
    vimls = { },
    wolfram_lsp = { },
}

return {
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile" },  -- from LazyVim
    config = function()
        vim.lsp.config.wolfram_lsp = {
            cmd = {
                "wolfram", "kernel",
                "-noinit", "-noprompt", "-nopaclet",
                "-noicon", "-nostartuppaclets",
                "-run", 'Needs["LSPServer`"];LSPServer`StartServer[]',
            },
            filetypes = { "mma" },
            root_markers = { '.git' },
        }

        for server, opts in pairs(server_config) do
            vim.lsp.config(server, opts)
            vim.lsp.enable(server)
        end
    end,
}
