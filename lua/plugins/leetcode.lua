return {
	"kawre/leetcode.nvim",
	build = ":TSUpdate html",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim", -- required by telescope
		"MunifTanjim/nui.nvim",

		-- optional
		"nvim-treesitter/nvim-treesitter",
		"rcarriga/nvim-notify",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("leetcode").setup({
			lang = "golang",
			cn = {
				enabled = true,
			},
		})

		local leetcode_enhanced = require("custom.leetcode")
		leetcode_enhanced.setup()
	end,
	cmd = { "Leet", "LeetToday" },
}
