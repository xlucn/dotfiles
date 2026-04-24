---@type vim.lsp.Config
return {
    init_options = {
        settings = {
            lint = {
                -- select = { "ALL" },
                -- ignore = {
                --     "T20", -- flake8-print
                --     "ERA", -- eradicate
                --     "Q", -- flake8-quotes
                -- },
                extendSelect = {
                    "F", -- Pyflakes
                    "E", -- pycodestyle error
                    "W", -- pycodestyle warning
                    "C90", -- mccabe
                    "N", -- pep8-naming
                    "D", -- pydocstyle
                    "I", -- isort
                    "U", -- pyupgrade
                    "A", -- flake8-builtins
                    "B", -- flake8-bugbear
                    "SIM", -- flake8-simplify
                    "NPY", -- NumPy-specific rules
                    "PL", -- Pylint
                },
            },
        },
    },
}
