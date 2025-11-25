-- Tokyonight Theme Configuration
require("tokyonight").setup({
    style = "night",
})
vim.cmd([[colorscheme tokyonight]])

-- Transparent background (set this after loading theme)
vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]
