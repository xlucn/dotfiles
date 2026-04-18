return {
    {
        'nvim-treesitter/nvim-treesitter',
        init = function()
            vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'bash', 'c', 'lua', 'markdown', 'python', 'vim', 'vimdoc' },
                callback = function(ev)
                    require'nvim-treesitter'.install(ev.match)
                    -- Enable treesitter highlighting and disable regex syntax
                    pcall(vim.treesitter.start)
                    -- indentation, provided by nvim-treesitter
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
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
                end, { desc = object })
            end

            local swap = require("nvim-treesitter-textobjects.swap")
            vim.keymap.set("n", "<leader>a", function()
                swap.swap_next("@parameter.inner")
            end, { desc = "Swap next parameter" })
            vim.keymap.set("n", "<leader>A", function()
                swap.swap_previous("@parameter.inner")
            end, { desc = "Swap previous parameter" })

            local move = require("nvim-treesitter-textobjects.move")
            -- Method-related keymaps are built-in already, see [m,]m,[M,]M
            -- You can use the capture groups defined in `textobjects.scm`
            vim.keymap.set({ "n", "x", "o" }, "]]", function()
                move.goto_next_start("@class.outer", "textobjects")
            end, { desc = "Goto start of the next class" })
            vim.keymap.set({ "n", "x", "o" }, "][", function()
                move.goto_next_end("@class.outer", "textobjects")
            end, { desc = "Goto end of the next class" })
            vim.keymap.set({ "n", "x", "o" }, "[[", function()
                move.goto_previous_start("@class.outer", "textobjects")
            end, { desc = "Goto start of the previous class" })
            vim.keymap.set({ "n", "x", "o" }, "[]", function()
                move.goto_previous_end("@class.outer", "textobjects")
            end, { desc = "Goto end of the previous class" })
        end,
        opts = {
            select = {
                enable = true,
                -- Extended textobjects to include preceding or succeeding
                -- whitespace. Succeeding whitespace has priority.
                include_surrounding_whitespace = false,
            },
            swap = { },
            move = { set_jumps = true },
        },
    },
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
}
