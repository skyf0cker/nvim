return {
	"rcarriga/nvim-notify",
	lazy = true,
	config = function()
		require("notify").setup({
			level = vim.log.levels.INFO,
			max_width = 50,
			stages = "slide",
			timeout = 800,
			render = "minimal",
		})

		vim.keymap.set("n", "<leader>dn", require("notify").dismiss, {
			desc = "[D]ismiss [N]otification",
			silent = true,
		})
	end,
}
