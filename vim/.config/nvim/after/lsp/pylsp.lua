---@type vim.lsp.Config
return {
    ---@param client vim.lsp.Client
    on_attach = function (client, _)
        client.server_capabilities.documentHighlightProvider = nil
        client.server_capabilities.diagnosticProvider = nil
    end,
    settings = {
        pylsp = {
            plugins = {
                jedi = {
                    -- fix finding modules in virtualenvs
                    environment = vim.fn.exepath('python'),
                    -- fix numpy imports, default was { 'numpy' }
                    auto_import_modules = {},
                },
            }
        }
    }
}
