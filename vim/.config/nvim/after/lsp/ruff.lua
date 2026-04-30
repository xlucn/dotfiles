---@type vim.lsp.Config
return {
    init_options = {
        settings = {
            lint = {
                select = {
                    "ALL",
                },
                ignore = {
                    "ERA", -- eradicate, for commented-out code
                    "ANN", -- flake8-annotations, type hints
                    "FIX", -- flake8-fixme, todos
                    "T20", -- flake8-print, no prints
                    "Q", -- flake8-quotes, single or double
                    "TD", -- flake8-todos, todos
                    "PTH", -- flake8-use-pathlib, os -> pathlib
                    "D413", -- pydocstyle, last blank line
                    "PLR", -- Pylint refactors
                },
                pydocstyle = {
                    convention = "numpy",
                },
            },
        },
    },
}
