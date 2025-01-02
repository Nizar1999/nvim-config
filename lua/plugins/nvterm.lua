return {
  -- Nvterm plugin for better terminal management in Neovim
  {
    'NvChad/nvterm',
    config = function()
      -- Basic setup for nvterm
      require('nvterm').setup({
        terminals = {
          open_mapping = "<C-t>",  -- Keybinding to open the terminal
          direction = "horizontal",  -- Default terminal direction
        },
      })
    end
  }
}
