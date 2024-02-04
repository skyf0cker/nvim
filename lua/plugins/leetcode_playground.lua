return {
    "leetcode_playground",
    name = "leetcode_playground",
    dev = true,
    dependencies = {
        "kawre/leetcode.nvim",
    },
    lazy = true,
    config = function()
        require("custom.plugins.leetcode_playground").setup({})
    end,
    cmd = { "LeetToday", "LeetProblems" },
}
