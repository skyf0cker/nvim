return {
	"echasnovski/mini.hipatterns",
	version = "*",
	config = function()
		vim.api.nvim_set_hl(0, "MiniHiPatternsLogInfo", { fg = "#ffffff", bg = "#73e861", bold = true })
		vim.api.nvim_set_hl(0, "MiniHiPatternsLogError", { fg = "#ffffff", bg = "#ed495f", bold = true })
		vim.api.nvim_set_hl(0, "MiniHiPatternsLogWarn", { fg = "#ffffff", bg = "#f0f25a", bold = true })
		vim.api.nvim_set_hl(0, "MiniHiPatternsLogDebug", { fg = "#ffffff", bg = "#0000ff", bold = true })

		local hipatterns = require("mini.hipatterns")
		hipatterns.setup({
			highlighters = {
				-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
				fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
				hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
				todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
				note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

				info = { pattern = "%f[%w]()INFO()%f[%W]", group = "MiniHipatternsLogInfo" },
				error = { pattern = "%f[%w]()ERROR()%f[%W]", group = "MiniHipatternsLogError" },
				warn = { pattern = "%f[%w]()WARN()%f[%W]", group = "MiniHipatternsLogWarn" },
				debug = { pattern = "%f[%w]()DEBUG()%f[%W]", group = "MiniHipatternsLogDebug" },

				-- Highlight hex color strings (`#rrggbb`) using that color
				hex_color = hipatterns.gen_highlighter.hex_color(),
			},
		})
	end,
}
