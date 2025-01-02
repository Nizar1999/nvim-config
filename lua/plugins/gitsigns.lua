return {
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { text = "✚" },           -- Emoji or Nerd Font symbol for added lines
          change = { text = "" },       -- Change symbol (e.g., small diamond)
          delete = { text = "" },       -- Deleted line symbol (trash bin or similar)
          topdelete = { text = "" },    -- Top delete symbol
          changedelete = { text = "" }, -- Change + delete symbol
        },
        current_line_blame = true,        -- Enable inline blame annotations
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',         -- Place blame info at the end of the line
          delay = 500,                   -- Delay in milliseconds before showing blame
        },
      })
    end
  }
}
