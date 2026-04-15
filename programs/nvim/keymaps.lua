vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("x", '<leader>p"', '"_dP', { desc = "Paste without overwriting register" })
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to system clipboard" })

vim.keymap.set("n", "<leader>lg", function()
	vim.cmd("terminal lazygit")
	vim.cmd("startinsert")
	vim.api.nvim_create_autocmd("TermClose", {
		buffer = 0,
		once = true,
		callback = function()
			vim.api.nvim_buf_delete(0, { force = true })
		end,
	})
end, { desc = "LazyGit" })
