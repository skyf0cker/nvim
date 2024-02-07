return {
	"mfussenegger/nvim-dap",
	lazy = true,
	keys = {
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "[D]ebug [b]reakpoint",
		},
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "[D]ebug [C]ontinue",
		},
		{
			"<leader>dn",
			function()
				require("dap").step_over()
			end,
			desc = "[D]ebug [N]ext",
		},
		{
			"<leader>ds",
			function()
				require("dap").step_into()
			end,
			desc = "[D]ebug [S]tep into",
		},
		{
			"<leader>dr",
			function()
				require("dap").restart()
			end,
			desc = "[D]ebug [r]estart",
		},
	},
}
