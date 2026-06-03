-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    defaults = {
        lazy = false,
    },
    -- import plugins from lua/plugins/*.lua
    spec = {
        import = "plugins"
    },
    change_detection = {
        enabled = true,
        notify = false,
    },
    rocks = {
        enabled = false
    },
    ui = {
        border = vim.o.winborder,
    }
})
