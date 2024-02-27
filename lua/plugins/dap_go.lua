return {
	"leoluz/nvim-dap-go",
	dependencies = {
		"mfussenegger/nvim-dap",
	},
	config = function()
		require("dap-go").setup({
			dap_configurations = {
				{
					type = "go",
					name = "Attach remote",
					mode = "remote",
					request = "attach",
					-- tell which host and port to connect to
					connect = {
						host = "127.0.0.1",
						port = "8181",
					},
				},
			},
			delve = {
				port = "8181",
			},
		})
	end,
}
