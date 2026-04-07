return {
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter' },
        },
        opts = {
            trim_scope = 'outer',
            multiline_threshold = 1,
        },
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = "main" ,
        init = function ()
            local select = require("nvim-treesitter-textobjects.select")
            for key, object in pairs({
                ["ap"] = "@parameter.outer",
                ["ip"] = "@parameter.inner",
                ["am"] = "@function.outer",
                ["im"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",

            }) do
                vim.keymap.set({ "x", "o" }, key, function()
                    select.select_textobject(object, "textobjects")
                end)
            end

            local swap = require("nvim-treesitter-textobjects.swap")
            vim.keymap.set("n", "<leader>a", function()
                swap.swap_next("@parameter.inner")
            end)
            vim.keymap.set("n", "<leader>A", function()
                swap.swap_previous("@parameter.outer")
            end)

            local move = require("nvim-treesitter-textobjects.move")
            -- You can use the capture groups defined in `textobjects.scm`
            vim.keymap.set({ "n", "x", "o" }, "]]", function()
                move.goto_next_start("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "][", function()
                move.goto_next_end("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[[", function()
                move.goto_previous_start("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[]", function()
                move.goto_previous_end("@class.outer", "textobjects")
            end)
        end,
        opts = {
            select = {
                enable = true,
                -- Extended textobjects to include preceding or succeeding
                -- whitespace. Succeeding whitespace has priority.
                include_surrounding_whitespace = true,
            },
            swap = { },
            move = { set_jumps = true },
        },
    },
    {
        'nvim-treesitter/nvim-treesitter',
        -- main = 'nvim-treesitter.configs',
        branch = "main",
        init = function()
            vim.api.nvim_create_autocmd('FileType', {
                callback = function()
                    -- Enable treesitter highlighting and disable regex syntax
                    pcall(vim.treesitter.start)
                    -- indentation, provided by nvim-treesitter
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
}
