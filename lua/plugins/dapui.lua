return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		require("dapui").setup({
			layouts = {
				{
					elements = {
						{
							id = "watches",
							size = 1,
						},
					},
					position = "bottom",
					size = 10,
				},
			},
		})

		vim.keymap.set("n", "<space>f", function()
			require("dapui").float_element()
		end, { silent = true, desc = "[F]loat [D]ebug" })
	end,
	keys = {
		{
			"<leader>du",
			function()
				require("dapui").toggle()
			end,
			desc = "[D]ebug [U]I",
		},
	},
}
