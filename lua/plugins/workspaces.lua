return {
  {
    'natecraddock/workspaces.nvim',
    config = function()
      require('workspaces').setup({
        hooks = {
          open = { "Telescope find_files" },  -- Automatically open Telescope when switching to a workspace
        },
        auto_open = true,                    -- Automatically open workspace on start
        auto_save = true,                    -- Automatically save changes to workspaces
        cd_type = "global",                  -- Set working directory globally
        sort = true,                         -- Sort workspaces by name
      })
    end
  }
}

