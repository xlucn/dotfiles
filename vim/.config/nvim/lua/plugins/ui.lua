local function config_which_key()
    local which_key = require("which-key")
    which_key.add({
        { ',l', group = "language server" },
    })
end

return {
    {
        'kevinhwang91/nvim-hlslens',
        config = true,
        event = "BufRead"
    },
    {
        'RRethy/vim-illuminate',
        config = function ()
            require('illuminate').configure({
                filetypes_denylist = { '', 'mail', 'markdown', 'text' },
                modes_denylist = { 'v', 'V', '' },
            })
        end,
        event = "UIEnter"
    },
    {
        'j-hui/fidget.nvim',
        config = true,
        event = 'LspAttach'
    },
    {
        'folke/which-key.nvim',
        config = config_which_key,
        keys = { '<leader>', '\'', '`', 'z', 'g', '[', ']' }
        event = "VeryLazy",
    },
    {
        'folke/trouble.nvim',
        config = true,
        cmd = 'TroubleToggle'
    },
}
