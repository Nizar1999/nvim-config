return {
	"kana/vim-altr",
	lazy = false,
	config = function()
		vim.cmd([[call altr#define('%.vert', '%.frag')]])
	end,
}
