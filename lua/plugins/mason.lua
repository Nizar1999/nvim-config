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

			-- clangd for C/C++ support
			lspconfig.clangd.setup({
				onattach = function(client, bufnr)
					-- Disable clangd's formatting capability
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
				flags = {
					debounce_text_changes = 150,
				},
				-- Optional: Add clangd-specific settings here
				cmd = { "clangd", "--background-index", "--clang-tidy", "--suggest-missing-includes" },
			})

			-- lua_ls for Lua support
			lspconfig.lua_ls.setup({
				flags = {
					debounce_text_changes = 150,
				},
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
		end,
	},
}
