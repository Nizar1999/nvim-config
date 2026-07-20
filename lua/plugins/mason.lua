return {
	-- Mason plugin for LSP server management
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ensure_installed = {
					-- Formatters and Linters
					"prettier",
					"clang-format",
					"stylua",
				},
			})
		end,
	},
	-- Mason LSP config to hook up LSP servers
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				automatic_installation = true,
			})
		end,
	},
	-- nvim-lspconfig for LSP configurations
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			vim.lsp.config('clangd', {
				onattach = function(client, bufnr)

					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
				cmd = { "clangd", "--background-index", "--clang-tidy", "--suggest-missing-includes" },
			})
			vim.lsp.enable('clangd')
			-- clangd for C/C++ support
			vim.lsp.config('lua_ls', {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" }, -- Add any global variables for Lua here (e.g., vim)
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true), -- Include Neovim runtime files
						},
					},
				},
			})
			vim.lsp.enable('lua_ls')

		end,
	},
}
