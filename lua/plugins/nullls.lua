return {
	"jose-elias-alvarez/null-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.completion.spell,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.prettier.with({
					extra_args = { "--bracket-same-line", "--html-whitespace-sensitivity=ignore", "--tab-width=4" },
				}),
				null_ls.builtins.formatting.beautysh,
				null_ls.builtins.formatting.tidy,
			},
		})
	end,
	event = { "BufReadPost", "BufNewFile" },
}
