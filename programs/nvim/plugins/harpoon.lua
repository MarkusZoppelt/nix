-- Harpoon Configuration
vim.keymap.set('n', '<space>m', function() require('harpoon.mark').add_file() end)
vim.keymap.set('n', '<space>h', function() require('harpoon.ui').toggle_quick_menu() end)
vim.keymap.set('n', '<space>1', function() require('harpoon.ui').nav_file(1) end)
vim.keymap.set('n', '<space>2', function() require('harpoon.ui').nav_file(2) end)
vim.keymap.set('n', '<space>3', function() require('harpoon.ui').nav_file(3) end)
vim.keymap.set('n', '<space>4', function() require('harpoon.ui').nav_file(4) end)
