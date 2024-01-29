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

		require("lspconfig").gopls.setup({
			capabilities = capabilities,
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					hints = {
						rangeVariableTypes = true,
						parameterNames = true,
						functionTypeParameters = true,
					},
					staticcheck = true,
					completeUnimported = true,
				},
			},
		})

		require("lspconfig").tsserver.setup({
			capabilities = capabilities,
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayVariableTypeHintsWhenTypeMatchesName = false,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
				javascript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayVariableTypeHintsWhenTypeMatchesName = false,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
			},
		})

		require("lspconfig").lua_ls.setup({
			settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim" },
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					-- Do not send telemetry data containing a randomized but unique identifier
					telemetry = {
						enable = false,
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})

		require("lspconfig").pyright.setup({
			capabilities = capabilities,
		})

		require("lspconfig").bashls.setup({
			capabilities = capabilities,
		})

		require("lspconfig").html.setup({
			capabilities = capabilities,
		})

		require("lspconfig").vuels.setup({
			capabilities = capabilities,
		})

		require("lspconfig").sqlls.setup({
			capabilities = capabilities,
		})

		require("lspconfig").jdtls.setup({
			cmd = { "jdtls" },
			root_dir = function(fname)
				return require("lspconfig").util.root_pattern("pom.xml", "gradle.build", ".git")(fname)
					or vim.fn.getcwd()
			end,
			capabilities = capabilities,
		})

		vim.cmd([[autocmd BufWritePost *.go lua vim.lsp.buf.format({timeout_ms = 1000})]])
		vim.cmd([[autocmd BufWritePost *.lua lua vim.lsp.buf.format({timeout_ms = 1000})]])
		vim.cmd([[autocmd BufWritePost *.json lua vim.lsp.buf.format({timeout_ms = 1000})]])
		vim.cmd([[autocmd BufWritePost *.html lua vim.lsp.buf.format({timeout_ms = 1000})]])
		vim.cmd([[autocmd BufWritePost *.sql lua vim.lsp.buf.format({timeout_ms = 1000})]])
		vim.cmd([[autocmd BufWritePost *.py lua vim.lsp.buf.format({timeout_ms = 1000})]])

		require("lspconfig").clangd.setup({
			capabilities = capabilities,
		})

		require("lspconfig").terraformls.setup({
			capabilities = capabilities,
			root_dir = function(fname)
				return require("lspconfig").util.root_pattern(".terraform")(fname) or vim.fn.getcwd()
			end,
		})

		require("lspconfig").rust_analyzer.setup({})

		require("lspconfig").tailwindcss.setup({})

		require("lspconfig").cssls.setup({
			capabilities = capabilities,
		})

		require("lspconfig").solidity.setup({})

		require("sg").setup({})
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
