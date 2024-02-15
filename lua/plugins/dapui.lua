return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
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
					position = "left",
					size = 40,
				},
			},
		})
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
