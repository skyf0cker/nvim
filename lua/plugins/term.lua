local lazygit = {}

return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({})

		local Terminal = require("toggleterm.terminal").Terminal
		lazygit = Terminal:new({
			cmd = "lazygit",
			dir = "git_dir",
			direction = "float",
			float_opts = {
				border = "single",
			},
			-- function to run on opening the terminal
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
			end,
			-- function to run on closing the terminal
			on_close = function(term)
				vim.cmd("startinsert!")
			end,
		})
	end,
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
		{
			"<leader>gt",
			function()
				lazygit:toggle()
			end,
			mode = { "n" },
			desc = "Lazy[G]it [T]oggle",
			noremap = true,
			silent = true,
		},
	},
	cmd = {
		"TermExec",
	},
}
