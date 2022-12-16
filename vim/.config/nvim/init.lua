-- nvim configuration
vim.o.mousemodel = 'extend'
vim.o.cmdheight = 1
vim.o.laststatus = 3
vim.cmd('nnoremap <M-j> <C-W>v')
vim.cmd('nnoremap <M-k> <C-W>W')
vim.cmd('nnoremap <M-J> <C-W>r')
vim.cmd('nnoremap <M-K> <C-W>R')
vim.cmd('nnoremap <M-h> <C-W><')
vim.cmd('nnoremap <M-l> <C-W>>')
vim.cmd('nnoremap <M-H> <C-W>-')
vim.cmd('nnoremap <M-L> <C-W>+')

function NvimLSPStatus()
    local messages, count = '', 0
    local levels = { E = 'ERROR', W = 'WARN', I = 'INFO', H = 'HINT' }
    for key, severity in pairs(levels) do
        severity = vim.diagnostic.severity[severity]
        count = #vim.diagnostic.get(0, { severity = severity })
        if count > 0 then
            messages = messages .. key .. ':' .. count
        end
    end
    return string.len(messages) == 0 and 'OK' or messages
end

function NvimGitBranch()
    -- look for .git/HEAD, might not work in all cases
    local path, fp, master
    local current_file = vim.fn.expand('%:p')
    local real_path = vim.fn.resolve(current_file)
    for seg in string.gmatch(real_path, '[^/]*') do
        path = table.concat({path or '', seg}, '/')
        fp = io.open(path .. '.git/HEAD')
        if fp ~= nil then
            master = fp:read()
            fp:close()
        end
    end
    if master == nil then return '' end

    master = string.gsub(master, '.*/', '')
    -- commit hash
    if string.match(master, '%x+') == master then
        master = string.sub(master, 0, 7)
    end
    return master
end

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(args.buf, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap=true, silent=true, buffer=args.buf }
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', ',li', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', ',lr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', ',lR', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', ',la', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', ',lf', vim.lsp.buf.formatting, bufopts)
    end
})

local dep_bootstrap = function ()
    -- check or install dep plugin manager
    local dep_path = vim.fn.stdpath("data") .. "/site/pack/deps/opt/dep"
    local dep_url = "https://github.com/chiyadev/dep"
    if vim.fn.empty(vim.fn.glob(dep_path)) > 0 then
      vim.fn.system({ "git", "clone", "--depth=1", dep_url, dep_path })
    end
    vim.cmd("packadd dep")
end

local config_leap = function ()
    require('leap').add_default_mappings()
end

local config_nvim_lspconfig = function()
    -- LSP configs
    local lsp = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- servers with simple setup
    local servers = {
        'ccls',
        'pylsp',
        'bashls',
        'marksman',
    }

    for _, server in ipairs(servers) do
        lsp[server].setup({ capabilities = capabilities })
    end

    lsp['sumneko_lua'].setup({
        capabilities = capabilities,
        settings = { Lua = {
            diagnostics = { globals = { 'vim' } }
        } },
    })

    lsp['texlab'].setup({
        capabilities = capabilities,
        settings = { texlab = {
            build = {
                executable = "latexmk",
                args = { "-xelatex",
                         "-interaction=nonstopmode",
                         "-synctex=1",
                         "%f" },
                onSave = true,
            },
            forwardSearch = {
                executable = "zathura",
                args = { "--synctex-forward", "%l:1:%f", "%p" },
            },
            auxDirectory = "./output",
            chktex = {
                onOpenAndSave = false,
            }
        } }
    })
end

local config_nvim_cmp = function()
    local cmp = require('cmp')

    cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
          { name = 'buffer' },
          { name = 'path' },
        })
    })
end

local config_vim_illuminate = function()
    require('illuminate').configure({
        filetypes_denylist = { '', 'mail', 'markdown', 'text' },
    })
end

local config_which_key = function()
    local which_key = require("which-key")
    which_key.register({
        l = { name = "language server" },
    }, {
        prefix = ","
    })
end

local config_nvim_treesitter = function()
    vim.o.foldmethod = 'expr'
    vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.o.foldenable = false

    require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
    })
end

dep_bootstrap()
require('dep')({
    -- basic
    { 'tpope/vim-commentary' },
    { 'tpope/vim-endwise' },
    { 'tpope/vim-repeat' },
    { 'tpope/vim-surround' },
    { 'tpope/vim-dispatch' },
    { 'ap/vim-buftabline' },
    -- lsp related
    { 'neovim/nvim-lspconfig', config_nvim_lspconfig },
    { 'hrsh7th/nvim-cmp', config_nvim_cmp },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-vsnip' },
    { 'hrsh7th/vim-vsnip' },
    { 'hrsh7th/vim-vsnip-integ' },
    { 'honza/vim-snippets' },
    { 'rafamadriz/friendly-snippets' },
    -- others
    { 'majutsushi/tagbar' },
    { 'jpalardy/vim-slime' },
    { 'airblade/vim-gitgutter' },
    { 'RRethy/vim-illuminate', config_vim_illuminate },
    { 'ggandor/leap.nvim', config_leap },
    { 'folke/which-key.nvim', config_which_key },
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-lualine/lualine.nvim' },
    { 'nvim-telescope/telescope.nvim' },
    { 'nvim-treesitter/nvim-treesitter', config_nvim_treesitter },
    sync="never"
})
