return {
	"leetcode_custom",
	name = "leetcode_custom",
	dev = true,
	dependencies = {
		"kawre/leetcode.nvim",
	},
	lazy = true,
	config = function()
		require("custom.plugins.leetcode_custom").setup({})
	end,
	cmd = { "LeetToday", "LeetProblems" },
}
