return {
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'stevearc/aerial.nvim',
        },
        init = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            vim.api.nvim_set_hl(0, 'NvimTreeCursorLine', { ctermbg = 8 })
        end,
        keys = {
            { '<leader>T', function()
                require('nvim-tree.api').tree.toggle()
            end, mode = 'n' },
            { '<leader>t', function()
                local aerial = require('aerial')
                local nvimtree = require('nvim-tree.api').tree

                -- If both are open, close them
                if nvimtree.is_visible() or aerial.is_open() then
                    nvimtree.close()
                    aerial.close_all()
                else
                    -- remember the current window and open nvim-tree
                    local source_winid = vim.api.nvim_get_current_win()
                    nvimtree.open()

                    -- open aerial in a scratch buffer below the nvim-tree
                    local scratch_bufnr = vim.api.nvim_create_buf(false, true)
                    vim.cmd("belowright sbuffer " .. scratch_bufnr)
                    local new_winid = vim.api.nvim_get_current_win()
                    aerial.open_in_win(new_winid, source_winid)

                    -- delete the scratch buffer
                    vim.api.nvim_buf_delete(scratch_bufnr, { force = true })
                    nvimtree.focus()
                end
            end, mode = 'n' },
        },
        opts = {
            hijack_cursor = true,
            renderer = {
                icons = { show = { git = false } },
                symlink_destination = false
            },
            diagnostics = { enable = true }
        },
    },
}
