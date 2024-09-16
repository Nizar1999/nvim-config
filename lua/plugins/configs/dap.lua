local dap = require "dap"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

dap.defaults.fallback.external_terminal = {
	command = "wt",
	args = {},
}

dap.adapters.python = function(cb, config)
	if config.request == "attach" then
		---@diagnostic disable-next-line: undefined-field
		local port = (config.connect or config).port
		---@diagnostic disable-next-line: undefined-field
		local host = (config.connect or config).host or "127.0.0.1"
		cb {
			type = "server",
			port = assert(port, "`connect.port` is required for a python `attach` configuration"),
			host = host,
			options = {
				source_filetype = "python",
			},
		}
	else
		cb {
			type = "executable",
			command = ".virtualenvs\\debugpy\\Scripts\\python",
			args = { "-m", "debugpy.adapter" },
			options = {
				source_filetype = "python",
			},
		}
	end
end

dap.configurations.python = {
	{
		-- The first three options are required by nvim-dap
		type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
		request = "launch",
		name = "Launch file",

		-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

		program = "${file}", -- This configuration will launch the current file if used.
	},
}

dap.configurations.cpp = {
	{
		name = "Launch an executable",
		type = "codelldb",
		request = "launch",
		cwd = "${workspaceFolder}",
		terminal = "console",
		program = function()
			return coroutine.create(function(coro)
				local opts = {}
				pickers
					.new(opts, {
						prompt_title = "Path to executable",
						finder = finders.new_oneshot_job({ "fd", "--hidden", "--no-ignore", "-e", ".exe" }, {}),
						sorter = conf.generic_sorter(opts),
						attach_mappings = function(buffer_number)
							actions.select_default:replace(function()
								actions.close(buffer_number)
								coroutine.resume(coro, action_state.get_selected_entry()[1])
							end)
							return true
						end,
					})
					:find()
			end)
		end,
	},
}

dap.adapters.godot = {
	type = "server",
	host = "127.0.0.1",
	port = 6006,
}

dap.configurations.gdscript = {
	{
		type = "godot",
		request = "launch",
		name = "Launch scene",
		project = "${workspaceFolder}",
	},
}
