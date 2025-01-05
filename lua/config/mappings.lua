local map = vim.keymap.set

-- Clear search highlight
map("n", "<leader>nh", ":nohlsearch<CR>", { desc = "Clear search highlighting" })

-- Indenting Selected Text
map("v", "<Tab>", ">gv", { desc = "Indent forward" })
map("v", "<S-Tab>", "<gv", { desc = "Indent backward" })

-- Adding new line without going into insert mode
map("n", "<leader>o", ':<C-u>call append(line("."), repeat([""], v:count1))<CR>', { desc = "New line (after)" })
map("n", "<leader>O", ':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>', { desc = "New line (before)" })

-- Easy begin and end of line traversal
map("n", "H", "_", { desc = "Go to beginning of line" })
map("n", "L", "$", { desc = "Go to end of line" })

-- Perform operation on all text in current buffer
map("n", "<leader>D", "ggdG<cr>", { desc = "Delete All Text" })
map("n", "<leader>Y", "ggyG<cr>", { desc = "Copy All Text" })

-- Shift + Up/Down to move line up/down
map("n", "<S-Up>", "yyddkP", { desc = "Move Line Up" })
map("n", "<S-Down>", "yyddp", { desc = "Move Line Down" })

-- Save with cntrl-S
map("n", "<C-s>", ":w<CR>", { desc = "Save", silent = true })

-- Fast searching highlighted text with Google
-- Requires use of the xdg-open command + wslu if you're on wsl (after installing wslu, run sudo ln -s ../../bin/wslview /usr/local/bin/xdg-open)
SearchGoogle = function()
	local s_start = vim.fn.getpos("'<")
	local s_end = vim.fn.getpos("'>")
	local n_lines = math.abs(s_end[2] - s_start[2]) + 1
	local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
	lines[1] = string.sub(lines[1], s_start[3], -1)
	if n_lines == 1 then
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
	else
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
	end
	local selectedText = table.concat(lines, " ")
	-- Check if there's any selected text
	if selectedText == "" then
		print("No text selected!")
		return
	end

	vim.fn.system({ "xdg-open", "https://google.com/search?q=" .. selectedText })
end

map("v", "<leader>G", ":lua SearchGoogle()<CR>", { silent = true, desc = "Google Selected Text" })

-- Plugin mappings
-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Search help tags" })
map("n", "<leader>fs", "<cmd>Telescope git_status<cr>", { desc = "Git status" })
map("n", "<leader>fc", "<cmd>Telescope git commits<cr>", { desc = "Git commits" })
map("n", "<leader>fb", "<cmd>Telescope file_browser<cr>", { desc = "File Browser" })

-- CMake
map("n", "<leader>bb", "<cmd>CMakeBuild<cr>", { desc = "CMake Build" })
map("n", "<leader>bt", "<cmd>CMakeSelectBuildTarget<cr>", { desc = "CMake Select Target" })

-- NvTerm
map("n", "<A-v>", "<cmd>lua require('nvterm.terminal').toggle('vertical')<cr>", { desc = "Toggle vertical term" })
map("t", "<A-v>", "<cmd>lua require('nvterm.terminal').toggle('vertical')<cr>", { desc = "Toggle vertical term" })
map("n", "<A-i>", "<cmd>lua require('nvterm.terminal').toggle('float')<cr>", { desc = "Toggle floating term" })
map("t", "<A-i>", "<cmd>lua require('nvterm.terminal').toggle('float')<cr>", { desc = "Toggle floating term" })

-- Zen
map("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Toggle Zen Mode" })

-- Gitsigns
map("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage Hunk" })
map("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Undo Stage Hunk" })
map("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview Hunk" })
map("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset Hunk" })
map("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<cr>", { desc = "Reset Buffer" })
map("n", "<leader>hb", "<cmd>Gitsigns blame_line<cr>", { desc = "Blame Line" })
map("n", "]c", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next Hunk" })
map("n", "[c", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Previous Hunk" })

-- Workspaces
map("n", "<leader>wa", "<cmd>WorkspacesAdd<cr>", { desc = "Add Workspace" })
map("n", "<leader>wr", "<cmd>WorkspacesRemove<cr>", { desc = "Remove Workspace" })
map("n", "<leader>wl", "<cmd>WorkspacesList<cr>", { desc = "List Workspaces" })
map("n", "<leader>wo", "<cmd>WorkspacesOpen<cr>", { desc = "Open Workspace" })

-- Comment
map(
	"v",
	"<leader>/",
	"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
	{ desc = "Toggle comment" }
)

-- LSP Diagnostics
map("n", "[d", function()
	vim.diagnostic.goto_prev({ float = { border = "rounded" } })
end, { desc = "Goto prev" })

map("n", "]d", function()
	vim.diagnostic.goto_next({ float = { border = "rounded" } })
end, { desc = "Goto next" })

map("n", "<leader>q", function()
	vim.diagnostic.setloclist()
end, { desc = "Diagnostic setloclist" })

map("n", "<leader>lf", function()
	vim.diagnostic.open_float({ border = "rounded" })
end, { desc = "Floating diagnostic" })

-- LSP Actions
map("n", "<leader>lD", function()
	vim.lsp.buf.declaration()
end, { desc = "LSP declaration" })

map("n", "<leader>ld", function()
	vim.lsp.buf.definition()
end, { desc = "LSP definition" })

map("n", "<leader>li", function()
	vim.lsp.buf.implementation()
end, { desc = "LSP implementation" })

map("n", "<leader>lh", function()
	vim.lsp.buf.hover()
end, { desc = "LSP hover" })

map("n", "<leader>lr", function()
	vim.lsp.buf.references()
end, { desc = "LSP references" })

map("n", "<leader>lt", function()
	vim.lsp.buf.type_definition()
end, { desc = "LSP definition type" })

map("n", "<leader>lr", function()
	vim.lsp.buf.rename()
end, { desc = "LSP rename" })

map("n", "<leader>ca", function()
	vim.lsp.buf.code_action()
end, { desc = "LSP code action" })

map("v", "<leader>ca", function()
	vim.lsp.buf.code_action()
end, { desc = "LSP code action" })

-- map("n", "<leader>ls", function() vim.lsp.buf.signature_help() end, { desc = "LSP signature help" })
