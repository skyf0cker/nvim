return {
	"sourcegraph/sg.nvim",
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	keys = {
		{
			"<leader>ss",
			function()
				require("sg.extensions.telescope").fuzzy_search_results()
			end,
			desc = "[S]earch [S]ourcegraph",
		},
	},
}
