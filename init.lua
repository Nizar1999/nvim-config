local opt = vim.opt
local g = vim.g

g.mapleader = " "

-- Term Setup
opt.termguicolors = true

-- Clipboard
opt.clipboard = "unnamedplus"

-- Highlight line cursor is currently on
opt.cursorline = true

-- Line numbers
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true
opt.statuscolumn = "%s %l %r "

-- Always show cursor position
opt.ruler = true

-- Always display status bar
opt.laststatus = 2

-- Enable mouse for scrolling and resizing
opt.mouse = a

-- Set folding to be handled by treesitter
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false

-- Indentation
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4

-- Init lazy and consequent plugins
require("config.lazy")

-- Theme
vim.cmd("colorscheme zenbones")

-- Init AutoCommands
require("config.commands")

-- Init Mappings
require("config.mappings")
