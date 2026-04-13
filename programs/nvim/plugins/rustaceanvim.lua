vim.g.rustaceanvim = {
	server = {
		on_attach = function(_, bufnr)
			vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
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
