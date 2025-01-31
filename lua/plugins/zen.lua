return {
	-- Zen Mode plugin for distraction-free writing
	{
		"folke/zen-mode.nvim",
		config = function()
			require("zen-mode").setup({
				window = {
					width = 0.4, -- Width of the window in zen mode
					options = {
						-- Disabling some UI elements for distraction-free mode
						signcolumn = "no", -- Disable the sign column
					},
				},
				plugins = {
					gitsigns = { enabled = false }, -- Optionally disable Git signs in zen mode
					tmux = { enabled = false }, -- Optionally disable tmux integration
				},
			})
		end,
	},
}
