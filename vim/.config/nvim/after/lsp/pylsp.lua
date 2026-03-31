return {
    settings = {
        pylsp = {
            plugins = {
                jedi = {
                    environment = vim.fn.exepath('python'),
                },
            }
        }
    }
}
