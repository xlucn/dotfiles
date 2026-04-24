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
}
