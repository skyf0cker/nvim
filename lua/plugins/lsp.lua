local function slice(tbl, start_idx)
	local rest = {}
	local idx = 1

	for key, value in pairs(tbl) do
		if idx >= start_idx then
			rest[key] = value
		end

		idx = idx + 1
	end

	return rest
end

local function get_lang_setup_opts()
	local opts = {}
	local lsp_config_path = vim.fn.stdpath("config") .. "/lua/lsp"
	local files = vim.api.nvim_call_function("globpath", { lsp_config_path, "*.lua" })
	for file in files:gmatch("[^\r\n]+") do
		local module_name = file:match("([^/]-)%.lua$")
		local module = require("lsp." .. module_name)
		opts[module[1]] = slice(module, 2)
	end

	return opts
end

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		{ "williamboman/mason.nvim", config = true },
		{ "williamboman/mason-lspconfig.nvim", config = true },

		-- Useful status updates for LSP
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ "j-hui/fidget.nvim", opts = {} },

		-- Additional lua configuration, makes nvim stuff amazing!
		"folke/neodev.nvim",
	},
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		local langs_opts = get_lang_setup_opts()
		for lang, opts in pairs(langs_opts) do
			require("lspconfig")[lang].setup(vim.tbl_deep_extend("keep", opts, {
				capabilities = capabilities,
			}))
		end

		require("sg").setup({})

		vim.cmd([[autocmd BufWritePost *.go lua vim.lsp.buf.format({timeout_ms = 1000})]])
		vim.cmd([[autocmd BufWritePost *.lua lua vim.lsp.buf.format({timeout_ms = 1000})]])
		vim.cmd([[autocmd BufWritePost *.json lua vim.lsp.buf.format({timeout_ms = 1000})]])
		vim.cmd([[autocmd BufWritePost *.html lua vim.lsp.buf.format({timeout_ms = 1000})]])
		vim.cmd([[autocmd BufWritePost *.sql lua vim.lsp.buf.format({timeout_ms = 1000})]])
		vim.cmd([[autocmd BufWritePost *.py lua vim.lsp.buf.format({timeout_ms = 1000})]])
	end,
	lazy = true,
	keys = {
		{
			"<space>e",
			vim.diagnostic.open_float,
			desc = "Open diagnostic float",
		},
		{
			"K",
			vim.lsp.buf.hover,
			desc = "Hover Document",
		},
		{
			"<c-k>",
			vim.lsp.buf.signature_help,
			desc = "Signature Help",
		},
		{
			"]d",
			vim.diagnostic.goto_next,
			desc = "Goto Next Diagnostic",
		},
		{
			"[d",
			vim.diagnostic.goto_prev,
			desc = "Goto Prev Diagnostic",
		},
		{
			"<space>f",
			function()
				vim.lsp.buf.format({
					async = true,
				})
			end,
			desc = "Goto Prev Diagnostic",
		},
	},
	event = { "BufReadPost", "BufNewFile" },
	cmd = { "LspInfo", "LspInstall", "LspUninstall" },
}
