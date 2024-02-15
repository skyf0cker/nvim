return {
	"wojciech-kulik/xcodebuild.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-tree.lua", -- if you want the integration with file tree
	},
	config = function()
		require("xcodebuild").setup({})
	end,
}
