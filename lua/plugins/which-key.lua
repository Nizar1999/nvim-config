return {
	"folke/which-key.nvim",
	dependencies = { "folke/noice.nvim", "hrsh7th/nvim-cmp", "natecraddock/workspaces.nvim", "Civitasv/cmake-tools.nvim"  },
	event = "VeryLazy",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
