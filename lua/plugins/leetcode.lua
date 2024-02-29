local function setup_keymap()
	vim.keymap.set("n", "<leader>td", ":Leet desc<CR>", {
		noremap = true,
		silent = true,
		buffer = 0,
		desc = "[T]oggle [D]escription",
	})

	vim.keymap.set("n", "<leader>tc", ":Leet console<CR>", {
		noremap = true,
		silent = true,
		buffer = 0,
		desc = "[T]oggle [C]onsole",
	})

	vim.keymap.set("n", "<leader>rt", ":Leet test<CR>", {
		noremap = true,
		silent = true,
		buffer = 0,
		desc = "[R]un [T]est",
	})

	vim.keymap.set("n", "<leader>ss", ":Leet submit<CR>", {
		noremap = true,
		silent = true,
		buffer = 0,
		desc = "[S]ubmit [S]olution",
	})
end

return {
	"kawre/leetcode.nvim",
	build = ":TSUpdate html",
	lazy = true,
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
			hooks = {
				["question_enter"] = function()
					setup_keymap()
				end,
			},
		})
	end,
	cmd = { "Leet" },
}
