---@type vim.lsp.Config
return {
    ---@param client vim.lsp.Client
    on_attach = function (client, _)
        client.server_capabilities.hoverProvider = nil
        client.server_capabilities.diagnosticProvider = nil
    end
}
