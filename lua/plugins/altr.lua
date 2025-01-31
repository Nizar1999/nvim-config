return {
	"kana/vim-altr",
	lazy = false,
	config = function()
		vim.cmd([[call altr#define('%.vert', '%.frag')]])
		vim.cmd([[call altr#define('%/include/%.h', '%/src/%.cpp')]])
	end,
}
