vim.lsp.config("*", { workspace_required = true })

vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.work", "go.mod", ".git" },
})

vim.lsp.config("nil_ls", {
	cmd = { "nil" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", ".git" },
})

vim.lsp.config("ts_ls", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
	init_options = { hostInfo = "neovim" },
})

vim.lsp.config("rust_analyzer", {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json" },
	settings = {
		["rust-analyzer"] = {
			files = { excludeDirs = { ".direnv", ".git" } },
		},
	},
	-- Read at startup from initializationOptions, not workspace/configuration.
	before_init = function(params, config)
		params.initializationOptions = (config.settings or {})["rust-analyzer"]
	end,
})

vim.lsp.enable({ "gopls", "nil_ls", "ts_ls", "rust_analyzer" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then
			return
		end
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
		end
		if client.name ~= "rust_analyzer" then -- noisy on every binding
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
		end
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
		end
		map("n", "grr", "<cmd>Telescope lsp_references<cr>", "LSP references")
		map("n", "<space>df", vim.diagnostic.open_float, "Diagnostic float")
		map("n", "<space>dl", "<cmd>Telescope diagnostics<cr>", "Diagnostics")
		map({ "n", "x" }, "<F3>", function()
			vim.lsp.buf.format({ async = true })
		end, "Format")
	end,
})

-- Docs preview ignores 'winborder'.
vim.api.nvim_create_autocmd("CompleteChanged", {
	callback = function()
		local win = vim.fn.complete_info({ "selected" }).preview_winid
		if win and vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_set_config(win, { border = "rounded" })
		end
	end,
})

vim.diagnostic.config({
	severity_sort = true,
	virtual_text = true,
	float = { border = "rounded", source = true },
})
