local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local state = require("telescope.actions.state")
local actions = require("telescope.actions")

local M = {}

local function get_go_tests(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)

	-- traverse the lines and use regex to find the golang test functions
	local tests = {}
	for _, line in ipairs(lines) do
		local fname = string.match(line, "func (Test[%w_-]+)%([%w]+ %*testing.T%) {")
		if fname then
			table.insert(tests, fname)
		end
	end

	return tests
end

M.list_go_tests = function(opts)
	opts = opts or {}

	local bufnr = vim.api.nvim_get_current_buf()
	local path = vim.api.nvim_buf_get_name(bufnr)
	local folder_path = path:match("(.*/)")

	pickers
		.new(opts, {
			prompt_title = "List Go Tests",
			finder = finders.new_table({
				results = get_go_tests(bufnr),
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry,
						ordinal = entry,
					}
				end,
			}),
			sorter = sorters.get_generic_fuzzy_sorter(),
			attach_mappings = function(_, map)
				map("i", "<CR>", function(prompt_bufnr)
					local selection = state.get_selected_entry()
					actions.close(prompt_bufnr)

					local cmd = "go test -v -timeout 3600s -run ^" .. selection.value .. "$ " .. folder_path
					vim.cmd(string.format([[TermExec cmd="%s" dir=%s direction=horizontal]], cmd, folder_path))
				end)
				return true
			end,
		})
		:find()
end

M.go_get = function(opts)
	opts = opts or {}

	local bufnr = vim.api.nvim_get_current_buf()
	local path = vim.api.nvim_buf_get_name(bufnr)
	local folder_path = path:match("(.*/)")

	local Input = require("nui.input")
	local event = require("nui.utils.autocmd").event

	local input = Input({
		position = "50%",
		size = {
			width = 30,
		},
		border = {
			style = "single",
			text = {
				top = "[package]",
				top_align = "center",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:Normal",
		},
	}, {
		prompt = "> ",
		on_submit = function(value)
			local cmd = "go get " .. value
			vim.cmd(string.format([[TermExec cmd="%s" dir=%s direction=horizontal]], cmd, folder_path))
		end,
	})

	-- mount/open the component
	input:mount()

	-- unmount component when cursor leaves buffer
	input:on(event.BufLeave, function()
		input:unmount()
	end)
end

return M
