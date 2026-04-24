---@type vim.lsp.Config
return {
    cmd = {
        "wolfram",
        "kernel",
        "-noinit",
        "-noprompt",
        "-nopaclet",
        "-noicon",
        "-nostartuppaclets",
        "-run",
        'Needs["LSPServer`"];LSPServer`StartServer[]',
    },
    filetypes = { "mma" },
    root_markers = { '.git' },
    init_options = {
        -- Needs explicitly enable the semantic tokens support.
        -- Otherwise, there would be errors during initialization.
        -- https://github.com/WolframResearch/LSPServer/blob/cecb4b310270d39fb7b
        -- a05564e5d5ae89d27802d/LSPServer/Kernel/LSPServer.wl#L926
        semanticTokens = true,
        -- Displaying implicit tokens, and it is experimental.
        -- Recommended settings from:
        -- https://github.com/WolframResearch/LSPServer/blob/cecb4b310270d39fb7b
        -- a05564e5d5ae89d27802d/docs/notes.md
        implicitTokens = { "*", ",", ";;", "?" },
    }
}
