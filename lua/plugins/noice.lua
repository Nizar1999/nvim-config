return {
	"folke/noice.nvim",
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
	opts = {
		-- add any options here
		-- lsp = {
		--   signature = {
		--     enable = false,
		--   },
		-- },
	},
	event = "VeryLazy",
	config = function()
		require("noice").setup({
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					-- override the default lsp markdown formatter with Noice
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					-- override the lsp markdown formatter with Noice
					["vim.lsp.util.stylize_markdown"] = true,
					-- override cmp documentation with Noice (needs the other options to work)
					["cmp.entry.get_documentation"] = true,
				},
				hover = { enabled = false }, -- <-- HERE!
				signature = { enabled = false }, -- <-- HERE!
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = false, -- use a classic bottom cmdline for search
				command_palette = false, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
		})
		require("noice.lsp").hover()
	end,
}
