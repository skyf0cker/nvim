return {
	{
		"vhyrro/luarocks.nvim",
		branch = "more-fixes",
		dependencies = {
			"rcarriga/nvim-notify", -- Optional dependency
		},
		opts = {
			rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }, -- Specify LuaRocks packages to install
		},
	},
	{
		"rest-nvim/rest.nvim",
		ft = "http",
		dependencies = { "luarocks.nvim" },
		config = function()
			vim.api.nvim_set_hl(0, "TextInfo", { fg = "#e0def4" })
			vim.api.nvim_set_hl(0, "TextMuted", { fg = "#6e6a86" })

			require("rest-nvim").setup({
				result = {
					split = {
						horizontal = true,
					},
					behavior = {
						formatters = {
							json = "jq",
							html = function(body)
								if vim.fn.executable("tidy") == 0 then
									return body, { found = false, name = "tidy" }
								end
								local fmt_body = vim.fn
									.system({
										"tidy",
										"-i",
										"-q",
										"--tidy-mark",
										"no",
										"--show-body-only",
										"auto",
										"--show-errors",
										"0",
										"--show-warnings",
										"0",
										"-",
									}, body)
									:gsub("\n$", "")

								return fmt_body, { found = true, name = "tidy" }
							end,
						},
					},
				},
			})

			vim.keymap.set("n", "<leader>rr", ":Rest run<CR>", {
				desc = "[R]est [R]un",
			})

			vim.keymap.set("n", "<leader>rl", ":Rest run last<CR>", {
				desc = "[R]est run [L]ast",
			})
		end,
	},
}
