return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            toml = { "tombi" },
            python = { "ruff" },
        },
    },
    keys = {
        {
            "<leader>f",
            function()
                require('conform').format({
                    lsp_format = 'prefer',
                    async = false,
                    timeout_ms = 500,
                })
            end,
            mode = { "n", "v" },
            desc = "Format code",
        }
    },
    init = function()
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end
}
