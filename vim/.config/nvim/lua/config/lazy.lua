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

-- set hightlight of LazyNormal in lua
vim.api.nvim_set_hl(0, "LazyNormal", { ctermbg = 8 })

-- Setup lazy.nvim
require("lazy").setup({
    defaults = {
        lazy = true,
    },
    spec = {
        import = "plugins"
    },
    change_detection = {
        -- automatically check for config file changes and reload the ui
        enabled = true,
        notify = false, -- no notifications when changes are found
    },
})
