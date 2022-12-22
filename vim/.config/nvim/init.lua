-- nvim configuration
vim.o.mousemodel = 'extend'
vim.o.cmdheight = 1
vim.o.laststatus = 3

local mapopts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>gg', vim.cmd.Git, mapopts)
vim.keymap.set('n', '<M-j>', '<C-W>w', mapopts)
vim.keymap.set('n', '<M-k>', '<C-W>W', mapopts)
vim.keymap.set('n', '<M-J>', '<C-W>r', mapopts)
vim.keymap.set('n', '<M-K>', '<C-W>R', mapopts)
vim.keymap.set('n', '<M-h>', '<C-W><', mapopts)
vim.keymap.set('n', '<M-l>', '<C-W>>', mapopts)
vim.keymap.set('n', '<M-H>', '<C-W>-', mapopts)
vim.keymap.set('n', '<M-L>', '<C-W>+', mapopts)

function NvimLSPStatus()
    local messages, count = {}, 0
    local levels = { E = 'ERROR', W = 'WARN', I = 'INFO', H = 'HINT' }
    for key, severity in pairs(levels) do
        severity = vim.diagnostic.severity[severity]
        count = #vim.diagnostic.get(0, { severity = severity })
        if count > 0 then
            table.insert(messages, key .. ':' .. count)
        end
    end
    local msgstr = table.concat(messages, ' ')
    return string.len(msgstr) == 0 and 'OK' or msgstr
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

local function dep_bootstrap()
    -- check or install dep plugin manager
    local dep_path = vim.fn.stdpath("data") .. "/site/pack/deps/opt/dep"
    local dep_url = "https://github.com/chiyadev/dep"
    if vim.fn.empty(vim.fn.glob(dep_path)) > 0 then
      vim.fn.system({ "git", "clone", "--depth=1", dep_url, dep_path })
    end
    vim.cmd("packadd dep")
end

local function config_leap()
    require('leap').add_default_mappings()
end

local function config_nvim_lspconfig()
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

local function config_nvim_cmp()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        sources = {
            { name = 'path' },
            { name = 'luasnip' },
            { name = 'nvim_lsp' },
            { name = 'buffer' },
        }
    })
end

local function config_vim_illuminate()
    require('illuminate').configure({
        filetypes_denylist = { '', 'mail', 'markdown', 'text' },
    })
end

local function config_which_key()
    local which_key = require("which-key")
    which_key.register({
        l = { name = "language server" },
    }, {
        prefix = ","
    })
end

local function config_nvim_treesitter()
    vim.o.foldmethod = 'expr'
    vim.o.foldenable = false
    vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

    require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        textobjects = {
            select = {
                enable = true,

                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,

                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["ap"] = "@parameter.outer",
                    ["ip"] = "@parameter.inner",
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
                -- You can choose the select mode (default is charwise 'v')
                selection_modes = {
                    ['@parameter.outer'] = 'v',
                    ['@function.outer'] = 'V',
                    ['@class.outer'] = 'V',
                },
                -- If you set this to `true` (default is `false`) then any textobject is
                -- extended to include preceding or succeeding whitespace. Succeeding
                -- whitespace has priority in order to act similarly to eg the built-in
                -- `ap`.
                include_surrounding_whitespace = true,
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>a"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>A"] = "@parameter.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]]"] = "@function.outer",
                    ["]c"] = "@class.outer",
                },
                goto_next_end = {
                    ["]["] = "@function.outer",
                    ["]C"] = "@class.outer",
                },
                goto_previous_start = {
                    ["[["] = "@function.outer",
                    ["[c"] = "@class.outer",
                },
                goto_previous_end = {
                    ["[]"] = "@function.outer",
                    ["[C"] = "@class.outer",
                },
            },
            lsp_interop = {
                enable = true,
                border = "none",
                peek_definition_code = {
                    ["<leader>pf"] = "@function.outer",
                    ["<leader>pF"] = "@class.outer",
                },
            },
        }
    })
end

local function config_gitsigns()
    require('gitsigns').setup({
        signs = {
            add = { hl = 'DiffAdd', text = '+' },
            change = { hl = 'DiffChange', text = '~' },
            delete = { hl = 'DiffDelete', text = '_' },
            topdelete = { hl = 'DiffDelete', text = '-' },
            changedelete = { hl = 'DiffDelete', text = '^' },
            untracked = { hl = 'DiffAdd', text = '!' },
        }
    })
end

local function config_luasnip()
    print('load luasnip')
    require('luasnip.loaders.from_vscode').lazy_load()
end

local function config_slime()
    vim.keymap.set({'x', 'n'}, '<leader>s', '<Plug>SlimeSend<CR>', mapopts)
end

local function config_nvim_tree()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.keymap.set('n', 'L', '<CMD>NvimTreeToggle<CR>', mapopts)
    require('nvim-tree').setup({
        hijack_cursor = true,
        view = {
            adaptive_size = true,
        },
        renderer = {
            add_trailing = true,
            symlink_destination = false,
            icons = {
                show = {
                    file = false,
                    folder = false,
                    git = false,
                    folder_arrow = true,
                },
                glyphs = {
                    default = " ",
                    symlink = "@",
                    bookmark = "M",
                    folder = {
                        arrow_closed = "+",
                        arrow_open = ">",
                    },
                },
            }
        },
        diagnostics = {
            enable = true,
            -- icons = {
            --     hint = 'H',
            --     info = 'I',
            --     warning = 'W',
            --     error = 'E',
            -- }
        }
    })
end

dep_bootstrap()
require('dep')({
    -- basic
    { 'tpope/vim-commentary' },
    { 'tpope/vim-endwise' },
    { 'tpope/vim-repeat' },
    { 'tpope/vim-sensible' },
    { 'tpope/vim-surround' },
    { 'tpope/vim-dispatch' },
    { 'tpope/vim-fugitive' },
    { 'ap/vim-buftabline' },
    -- others
    { 'lewis6991/gitsigns.nvim', config_gitsigns },
    { 'nvim-tree/nvim-tree.lua', config_nvim_tree },
    { 'preservim/tagbar' },
    { 'jpalardy/vim-slime', config_slime },
    { 'RRethy/vim-illuminate', config_vim_illuminate },
    { 'ggandor/leap.nvim', config_leap },
    { 'folke/which-key.nvim', config_which_key },
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-lualine/lualine.nvim' },
    { 'nvim-telescope/telescope.nvim' },
    { 'nvim-treesitter/nvim-treesitter', config_nvim_treesitter },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    -- snippet engine and sources
    { 'honza/vim-snippets', deps = 'L3MON4D3/LuaSnip' },
    { 'rafamadriz/friendly-snippets', deps = 'L3MON4D3/LuaSnip' },
    { 'L3MON4D3/LuaSnip', config_luasnip, deps = 'hrsh7th/nvim-cmp' },
    -- completion engine and sources
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/nvim-cmp', config_nvim_cmp },
    -- lsp and integrations
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'neovim/nvim-lspconfig', config_nvim_lspconfig },
    sync="never"
})
