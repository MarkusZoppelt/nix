vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("x", '<leader>p"', '"_dP')
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

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
