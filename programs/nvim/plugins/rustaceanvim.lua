vim.g.rustaceanvim = {
    server = {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        default_settings = {
            ['rust-analyzer'] = {
                files = {
                    excludeDirs = {
                        '.direnv',
                        '.git',
                    },
                },
            },
        },
    },
}
