---@type vim.lsp.Config
return {
    settings = {
        texlab = {
            build = {
                executable = "latexmk",
                args = { "-interaction=nonstopmode", "-synctex=1", "%f" },
                onSave = true,
                auxDirectory = "./output",
                logDirectory = "./output",
                pdfDirectory = ".",
            },
            forwardSearch = {
                executable = "evince-synctex",
                args = { "-f", "%l", "%p", "\"texlab inverse-search -i %f -l %l\"" },
            },
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
        }
    },
}
