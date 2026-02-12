-- Mason Configuration
require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "nil_ls",
        "ts_ls",
    },
})

-- Setup LSP capabilities for cmp
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

-- LSP Configuration
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

        vim.keymap.set('n', '<space>df', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
        vim.keymap.set('n', '<space>dl', '<cmd>Telescope diagnostics<cr>', opts)
        vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
        vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
    end
})

-- Configure LSP servers using vim.lsp.config (v2.x API)
-- The new mason-lspconfig v2.x automatically enables servers via automatic_enable
vim.lsp.config('*', {
    capabilities = lsp_capabilities,
})

-- Enable LSP servers installed by mason
-- rust_analyzer is excluded because rustaceanvim manages its own client
local installed_servers = require("mason-lspconfig").get_installed_servers()
for _, server in ipairs(installed_servers) do
    if server ~= 'rust_analyzer' then
        vim.lsp.enable(server)
    end
end

vim.diagnostic.config({
    virtual_text = true
})
