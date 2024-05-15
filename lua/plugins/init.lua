-- All plugins have lazy=true by default,to load a plugin on startup just lazy=false
-- List of all default plugins & their definitions
local default_plugins = {

	{
		"habamax/vim-godot",
		event = "BufEnter *.gd",
		config = function()
			vim.cmd [[
			  setlocal tabstop=4
			  setlocal shiftwidth=4
			  setlocal indentexpr=
			]]
		end,
	},

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup {
				-- Configuration here, or leave empty to use defaults
			}
		end,
	},

	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{
		"natecraddock/workspaces.nvim",
		init = function()
			require("core.utils").load_mappings "workspaces"
		end,
		opts = {
			hooks = {
				open = { "Telescope find_files" },
			},
		},
	},

	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
		init = function()
			require("core.utils").load_mappings "trouble"
		end,
	},

	{
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	},

	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = "mfussenegger/nvim-dap",
		config = function()
			local dap = require "dap"
			local dapui = require "dapui"
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		opts = {
			handlers = {},
		},
	},

	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
		},
		opts = function()
			return require "plugins.configs.dap"
		end,
		config = function(_, opts)
			require("core.utils").load_mappings "dap"
		end,
	},

	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		opts = {},
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "VeryLazy",
		opts = function()
			return require "plugins.configs.null-ls"
		end,
	},

	{
		"NvChad/base46",
		branch = "v2.0",
		build = function()
			require("base46").load_all_highlights()
		end,
	},

	{
		"NvChad/ui",
		branch = "v2.0",
		lazy = false,
	},

	{
		"zbirenbaum/nvterm",
		init = function()
			require("core.utils").load_mappings "nvterm"
		end,
		config = function(_, opts)
			require "base46.term"
			require("nvterm").setup(opts)
		end,
	},

	{
		"NvChad/nvim-colorizer.lua",
		event = "User FilePost",
		config = function(_, opts)
			require("colorizer").setup(opts)

			-- execute colorizer as soon as possible
			vim.defer_fn(function()
				require("colorizer").attach_to_buffer(0)
			end, 0)
		end,
	},

	{
		"nvim-tree/nvim-web-devicons",
		opts = function()
			return { override = require "nvchad.icons.devicons" }
		end,
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "devicons")
			require("nvim-web-devicons").setup(opts)
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		version = "2.20.7",
		event = "User FilePost",
		opts = function()
			return require("plugins.configs.others").blankline
		end,
		config = function(_, opts)
			require("core.utils").load_mappings "blankline"
			dofile(vim.g.base46_cache .. "blankline")
			require("indent_blankline").setup(opts)
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate",
		opts = function()
			return require "plugins.configs.treesitter"
		end,
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "syntax")
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	-- git stuff
	{
		"lewis6991/gitsigns.nvim",
		event = "User FilePost",
		opts = function()
			return require("plugins.configs.others").gitsigns
		end,
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "git")
			require("gitsigns").setup(opts)
		end,
	},

	-- lsp stuff
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
		opts = function()
			return require "plugins.configs.mason"
		end,
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "mason")
			require("mason").setup(opts)

			-- custom nvchad cmd to install all mason binaries listed
			vim.api.nvim_create_user_command("MasonInstallAll", function()
				if opts.ensure_installed and #opts.ensure_installed > 0 then
					vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
				end
			end, {})

			vim.g.mason_binaries_list = opts.ensure_installed
		end,
	},

	{
		"neovim/nvim-lspconfig",
		event = "User FilePost",
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
			require "plugins.configs.lspconfig"
		end,
	},

	-- load luasnips + cmp related in insert mode only
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				-- snippet plugin
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				opts = { history = true, updateevents = "TextChanged,TextChangedI" },
				config = function(_, opts)
					require("plugins.configs.others").luasnip(opts)
				end,
			},

			-- autopairing of (){}[] etc
			{
				"windwp/nvim-autopairs",
				opts = {
					fast_wrap = {},
					disable_filetype = { "TelescopePrompt", "vim" },
				},
				config = function(_, opts)
					require("nvim-autopairs").setup(opts)

					-- setup cmp for autopairs
					local cmp_autopairs = require "nvim-autopairs.completion.cmp"
					require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
				end,
			},

			-- cmp sources plugins
			{
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
			},
		},
		opts = function()
			return require "plugins.configs.cmp"
		end,
		config = function(_, opts)
			require("cmp").setup(opts)
		end,
	},

	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gcc", mode = "n",          desc = "Comment toggle current line" },
			{ "gc",  mode = { "n", "o" }, desc = "Comment toggle linewise" },
			{ "gc",  mode = "x",          desc = "Comment toggle linewise (visual)" },
			{ "gbc", mode = "n",          desc = "Comment toggle current block" },
			{ "gb",  mode = { "n", "o" }, desc = "Comment toggle blockwise" },
			{ "gb",  mode = "x",          desc = "Comment toggle blockwise (visual)" },
		},
		init = function()
			require("core.utils").load_mappings "comment"
		end,
		config = function(_, opts)
			require("Comment").setup(opts)
		end,
	},

	-- file managing , picker etc
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		init = function()
			require("core.utils").load_mappings "nvimtree"
		end,
		opts = function()
			return require "plugins.configs.nvimtree"
		end,
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "nvimtree")
			require("nvim-tree").setup(opts)
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = "Telescope",
		init = function()
			require("core.utils").load_mappings "telescope"
		end,
		opts = function()
			return require "plugins.configs.telescope"
		end,
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "telescope")
			local telescope = require "telescope"
			telescope.setup(opts)
			telescope.load_extension "workspaces"

			-- load extensions
			for _, ext in ipairs(opts.extensions_list) do
				telescope.load_extension(ext)
			end
		end,
	},

	-- Only load whichkey after all the gui
	{
		"folke/which-key.nvim",
		keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
		init = function()
			require("core.utils").load_mappings "whichkey"
		end,
		cmd = "WhichKey",
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "whichkey")
			require("which-key").setup(opts)
		end,
	},
	{
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
			require("noice").setup {
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
			}
			require("noice.lsp").hover()
		end,
	},

	{
		"Civitasv/cmake-tools.nvim",
		lazy = false,
		dependencies = { "nvim-lua/plenary.nvim" },
		init = function()
			require("core.utils").load_mappings "cmake"
		end,
		config = function()
			require("cmake-tools").setup {
				-- Configuration here, or leave empty to use defaults
			}
		end,
	},
}

local config = require("core.utils").load_config()

if #config.plugins > 0 then
	table.insert(default_plugins, { import = config.plugins })
end

require("lazy").setup(default_plugins, config.lazy_nvim)
