return {
	"nvimdev/lspsaga.nvim",
	config = function()
		require("lspsaga").setup({
			outline = {
                detail = false,
                auto_preview = false,
			},
		})

		vim.keymap.set({ "n" }, "<leader>ca", ":silent Lspsaga code_action<CR>", {
			desc = "[C]ode [A]ction",
		})
		vim.keymap.set({ "n" }, "<leader>to", ":silent Lspsaga outline<CR>", {
			desc = "[T]oggle [O]utline",
		})
	end,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
}
