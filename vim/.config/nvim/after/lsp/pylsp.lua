return {
    settings = {
        pylsp = {
            plugins = {
                jedi = {
                    -- fix finding modules in virtualenvs
                    environment = vim.fn.exepath('python'),
                    -- fix numpy imports, default was { 'numpy' }
                    auto_import_modules = {},
                },
            }
        }
    }
}
