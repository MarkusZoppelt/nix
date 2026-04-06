-- Treesitter Configuration
-- nvim-treesitter was rewritten for Neovim 0.12; highlighting is now handled
-- by Neovim's built-in treesitter engine. setup() only configures install_dir.
require('nvim-treesitter').setup {
    install_dir = vim.fn.stdpath('data') .. '/site',
}

-- Treesitter Context Configuration
require('treesitter-context').setup { enable = true }
