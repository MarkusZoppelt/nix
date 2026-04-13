vim.api.nvim_create_autocmd("FileType", {
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf, vim.treesitter.language.get_lang(ev.match) or ev.match)
	end,
})
