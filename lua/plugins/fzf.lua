local function list_notification()
	local notifications = require("notify").history()

	local messages = {}
	local ids = {}
	for _, notification in ipairs(notifications) do
		local message = ""
		local level = notification.level
		local id = notification.id

		for _, msg in ipairs(notification.message) do
			message = message .. " " .. msg
		end

		local display = id .. ": " .. level .. message
		ids[display] = id
		table.insert(messages, display)
	end

	require("fzf-lua").fzf_exec(messages, {
		prompt = "notifications",
		actions = {
			["default"] = function(selected)
				local opened_buffer = require("notify").open(ids[selected[1]])

				-- copied from nvim-notify telescope extension
				local lines = vim.opt.lines:get()
				local cols = vim.opt.columns:get()

				local win = vim.api.nvim_open_win(opened_buffer.buffer, true, {
					relative = "editor",
					row = (lines - opened_buffer.height) / 2,
					col = (cols - opened_buffer.width) / 2,
					height = opened_buffer.height,
					width = opened_buffer.width,
					border = "rounded",
					style = "minimal",
				})

				vim.fn.setwinvar(
					win,
					"&winhl",
					"Normal:" .. opened_buffer.highlights.body .. ",FloatBorder:" .. opened_buffer.highlights.border
				)
				vim.fn.setwinvar(win, "&wrap", 0)
			end,
		},
	})
end

return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = true,
	config = function()
		-- calling `setup` is optional for customization
		require("fzf-lua").setup({})
	end,
	keys = {
		{
			"<leader>ff",
			"<cmd>FzfLua files<CR>",
			desc = "[F]ind [F]ile",
		},
		{
			"<leader>sg",
			"<cmd>FzfLua live_grep<CR>",
			desc = "[S]earch by [G]rep",
		},
		{
			"<leader>lb",
			"<cmd>FzfLua buffers<CR>",
			desc = "[L]ist [B]uffers",
		},
		{
			"<leader>h",
			"<cmd>FzfLua help_tags<CR>",
			desc = "[H]elp",
		},
		{
			"gd",
			"<cmd>FzfLua lsp_definitions<CR>",
			desc = "[G]oto [D]efinitions",
		},
		{
			"gr",
			"<cmd>FzfLua lsp_references<CR>",
			desc = "[G]oto [R]eferences",
		},
		{
			"gi",
			"<cmd>FzfLua lsp_implementations<CR>",
			desc = "[G]oto [I]mplementations",
		},
		{
			"<leader>ld",
			"<cmd>FzfLua diagnostics_document<CR>",
			desc = "[L]ist [D]iagnostics",
		},
		{
			"<leader>lad",
			"<cmd>FzfLua diagnostics_workspace<CR>",
			desc = "[L]ist [A]ll [D]iagnostics",
		},
		{
			"<leader>ls",
			"<cmd>FzfLua lsp_document_symbols<CR>",
			desc = "[L]ist [S]ymbols",
		},
		{
			"<leader>ln",
			function()
				list_notification()
			end,
			desc = "[L]ist [N]otifications",
		},
	},
	cmd = { "FzfLua" },
}
