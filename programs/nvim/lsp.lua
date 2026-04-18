vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then
			return
		end

		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = false })
		end

		vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })

		local opts = { buffer = event.buf, silent = true }

		vim.keymap.set(
			{ "n", "x" },
			"<F3>",
			"<cmd>lua vim.lsp.buf.format({async = true})<cr>",
			vim.tbl_extend("force", opts, { desc = "Format buffer" })
		)
		vim.keymap.set(
			"n",
			"grr",
			"<cmd>Telescope lsp_references<cr>",
			vim.tbl_extend("force", opts, { desc = "LSP references (Telescope)" })
		)
		vim.keymap.set(
			"n",
			"<space>df",
			"<cmd>lua vim.diagnostic.open_float()<cr>",
			vim.tbl_extend("force", opts, { desc = "Diagnostic float" })
		)
		vim.keymap.set(
			"n",
			"<space>dl",
			"<cmd>Telescope diagnostics<cr>",
			vim.tbl_extend("force", opts, { desc = "Diagnostics list (Telescope)" })
		)
	end,
})

-- Server configs: cmd/filetypes/root_markers come from nvim-lspconfig.
-- rust_analyzer is managed by rustaceanvim.
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = { library = { vim.env.VIMRUNTIME } },
		},
	},
})

vim.lsp.enable({ "gopls", "lua_ls", "nil_ls", "ts_ls" })

-- Add border to the completion documentation popup (not covered by winborder/pumborder)
vim.api.nvim_create_autocmd("CompleteChanged", {
	callback = function()
		local info = vim.fn.complete_info({ "selected" })
		local win = info.preview_winid
		if win and vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_set_config(win, { border = "rounded" })
		end
	end,
})

vim.diagnostic.config({
	severity_sort = true,
	virtual_text = { current_line = false },
	virtual_lines = { current_line = true },
	float = {
		border = "rounded",
		source = true,
	},
})
