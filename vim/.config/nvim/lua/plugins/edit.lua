return {
    {
        'kylechui/nvim-surround',
        config = true,
        keys = {
            'ys', 'ds', 'cs', { 'S', mode = 'v' },
        }
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },
}
