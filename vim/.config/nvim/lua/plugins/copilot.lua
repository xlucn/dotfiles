return {
    {
        "github/copilot.vim",
        init = function ()
            vim.g.copilot_filetypes = {
                mail = false,
            }
        end,
        event = "VimEnter",
    }
}
