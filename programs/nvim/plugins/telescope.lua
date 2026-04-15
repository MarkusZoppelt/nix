local builtin = require("telescope.builtin")
vim.keymap.set("n", "ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "fd", builtin.diagnostics, { desc = "Diagnostics" })
vim.keymap.set("n", "fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "fh", builtin.help_tags, { desc = "Help tags" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "TelescopePrompt",
	callback = function()
		vim.bo.autocomplete = false
	end,
})
