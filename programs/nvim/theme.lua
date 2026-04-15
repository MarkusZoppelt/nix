require("tokyonight").setup({ style = "night" })
vim.cmd([[colorscheme tokyonight]])

-- Must be set after loading theme
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "NonText", { bg = "NONE", ctermbg = "NONE" })
