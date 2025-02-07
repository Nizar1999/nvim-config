local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

return {
	-- null-ls for additional LSP sources (formatting, diagnostics, etc.)
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")

			-- Define your sources (formatting, diagnostics, etc.)
			null_ls.setup({
				sources = {
					-- Formatting sources
					null_ls.builtins.formatting.prettier, -- Prettier for formatting
					null_ls.builtins.formatting.clang_format, -- ClangFormat for C/C++ formatting
					null_ls.builtins.formatting.stylua,

					-- Linter sources

					-- Code actions
					null_ls.builtins.code_actions.gitsigns, -- Gitsigns for Git actions
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						local callback = function()
							vim.lsp.buf.format({
								bufnr = bufnr,
								filter = function(c)
									return c.name == "null-ls"
								end,
							})
						end
						vim.api.nvim_clear_autocmds({
							group = augroup,
							buffer = bufnr,
						})
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = callback,
						})
					end
				end,
			})
		end,
	},
}
