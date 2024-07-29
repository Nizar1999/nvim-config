dofile(vim.g.base46_cache .. "lsp")
require "nvchad.lsp"

local M = {}
local utils = require "core.utils"

-- export on_attach & capabilities for custom lspconfigs
M.on_attach = function(client, bufnr)
	utils.load_mappings("lspconfig", { buffer = bufnr })

	if client.server_capabilities.signatureHelpProvider then
		require("nvchad.signature").setup(client)
	end
end

-- disable semantic tokens
M.on_init = function(client, _)
	if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
		client.server_capabilities.semanticTokensProvider = nil
	end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

require("mason").setup()
require("mason-lspconfig").setup()

require("lspconfig").lua_ls.setup {
	on_init = M.on_init,
	on_attach = M.on_attach,
	capabilities = M.capabilities,

	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand "$VIMRUNTIME/lua"] = true,
					[vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
					[vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
					[vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
				},
				maxPreload = 100000,
				preloadFileSize = 10000,
			},
		},
	},
}

require("lspconfig").clangd.setup {
	on_attach = function(client, bufnr)
		client.server_capabilities.signatureHelpProvider = false
		M.on_attach(client, bufnr)
	end,
	capabilities = M.capabilities,
	cmd = {
		"clangd",
		"--offset-encoding=utf-16",
	},
}

local util = require "lspconfig.util"
local port = os.getenv "GDScript_Port" or "6005"
local cmd = { "nc", "localhost", port }

if vim.fn.has "nvim-0.8" == 1 then
	cmd = vim.lsp.rpc.connect("127.0.0.1", port)
end

require("lspconfig").gdscript.setup {}
require("lspconfig").cmake.setup {
	settings = {
		filetypes = {
			"cmake",
			"CMakeLists.txt",
		},
	},
}

require("lspconfig").glsl_analyzer.setup {
	on_attach = function(client, bufnr)
		client.server_capabilities.signatureHelpProvider = false
		M.on_attach(client, bufnr)
	end,
}

return M
