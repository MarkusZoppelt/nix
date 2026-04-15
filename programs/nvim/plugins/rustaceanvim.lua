vim.g.rustaceanvim = {
	server = {
		on_attach = function(_, bufnr)
			vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
			vim.keymap.set("n", "<leader>a", function()
				vim.cmd.RustLsp("codeAction")
			end, { silent = true, buffer = bufnr, desc = "Rust code action" })
			vim.keymap.set("n", "K", function()
				vim.cmd.RustLsp({ "hover", "actions" })
			end, { silent = true, buffer = bufnr, desc = "Rust hover actions" })
			vim.keymap.set("n", "<leader>em", function()
				vim.cmd.RustLsp("expandMacro")
			end, { silent = true, buffer = bufnr, desc = "Rust expand macro" })
		end,
		default_settings = {
			["rust-analyzer"] = {
				files = {
					excludeDirs = { ".direnv", ".git" },
				},
			},
		},
	},
}
