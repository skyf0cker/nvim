return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = true,
	lazy = true,
	keys = {
		{
			"<leader>th",
			function()
				return "<cmd> " .. vim.v.count .. "ToggleTerm direction=horizontal <cr>"
			end,
			mode = { "n", "t" },
			expr = true,
			desc = "create terminal horizontally",
		},
		{
			"<leader>tv",
			function()
				return "<cmd> " .. vim.v.count .. "ToggleTerm direction=vertical <cr>"
			end,
			mode = { "n", "t" },
			expr = true,
			desc = "create terminal vertically",
		},
		{
			"<leader>tf",
			function()
				return "<cmd> " .. vim.v.count .. "ToggleTerm direction=float <cr>"
			end,
			mode = { "n", "t" },
			expr = true,
			desc = "create terminal float",
		},
		{
			"<leader>tn",
			[[<C-\><C-n>]],
			mode = { "t" },
			desc = "back to normal mode",
		},
	},
    cmd = {
        'TermExec'
    }
}
