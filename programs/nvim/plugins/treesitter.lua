-- Treesitter Configuration
require('nvim-treesitter.configs').setup {
    -- Disable auto_install and parser updates since Nix manages everything
    auto_install = false,
    ensure_installed = {},
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

-- Prevent Treesitter from trying to write to read-only Nix store
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/treesitter")

-- Treesitter Context Configuration
require('treesitter-context').setup { enable = true }
