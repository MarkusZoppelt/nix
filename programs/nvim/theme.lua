require("tokyonight").setup({ style = "night" })
vim.cmd([[colorscheme tokyonight]])

-- Must be set after loading theme
vim.cmd([[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]])
