return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
		parser_config.http = vim.tbl_deep_extend("force", parser_config.http, {
			install_info = {
				url = "~/code/tree-sitter-http", -- local path or git repo
				branch = "next",
			},
		})

		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"go",
				"http",
				"markdown",
				"json",
				"xml",
				"graphql",
			},
			highlight = {
				enable = true,
				disable = function(lang, buf)
					if lang == "http" then
						return true
					end

					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
			},
		})
	end,
	build = ":TSUpdate",
}
