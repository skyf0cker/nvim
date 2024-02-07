local M = {}

local GoInput = require("custom.plugins.go.go-ui.input")
local Job = require("plenary.job")
local Fidget = require("fidget")
local Pickers = require("telescope.pickers")
local Finders = require("telescope.finders")
local Sorters = require("telescope.sorters")
local State = require("telescope.actions.state")
local Actions = require("telescope.actions")

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

function M.list_go_tests(opts)
	opts = opts or {}

	local bufnr = vim.api.nvim_get_current_buf()
	local path = vim.api.nvim_buf_get_name(bufnr)
	local folder_path = path:match("(.*/)")

	Pickers.new(opts, {
		prompt_title = "List Go Tests",
		finder = Finders.new_table({
			results = get_go_tests(bufnr),
			entry_maker = function(entry)
				return {
					value = entry,
					display = entry,
					ordinal = entry,
				}
			end,
		}),
		sorter = Sorters.get_generic_fuzzy_sorter(),
		attach_mappings = function(_, map)
			map("i", "<CR>", function(prompt_bufnr)
				local selection = State.get_selected_entry()
				Actions.close(prompt_bufnr)

				local cmd = "go test -v -timeout 3600s -run ^" .. selection.value .. "$ " .. folder_path
				vim.cmd(string.format([[TermExec cmd="%s" dir=%s direction=horizontal]], cmd, folder_path))
			end)
			return true
		end,
	}):find()
end

local function exec_goimpl(receiver, interface)
	local stubs = ""
	local err_msg = ""
	local job = Job:new({
		command = "impl",
		args = { receiver, interface },
		on_stdout = function(_, data, _)
			stubs = stubs .. "\n" .. data
		end,
		on_stderr = function(_, data, _)
			err_msg = err_msg .. data
		end,
	})

	job:start()
	job:wait()

	return {
		stubs = stubs,
		err = err_msg,
	}
end

function M.impl()
	local on_submit = function(value)
		Fidget.notify("generating stubs...", vim.log.levels.INFO)

		local line = vim.api.nvim_get_current_line()
		local type_name = string.match(line, "type ([%w_-]+) [%w%[%]%{%}]+")
		if not type_name then
			vim.notify("there is no type definations under current cursor", vim.log.levels.ERROR)
		end
		local receiver = type_name:sub(1, 1):lower()

		local result = exec_goimpl(("%s *%s"):format(receiver, type_name), value)
		if result.err ~= "" then
			vim.notify(result.err, vim.log.levels.ERROR)
			return
		end

		vim.fn.setreg("+", result.stubs)
		Fidget.notify("impl stubs copied to clipboard", vim.log.levels.INFO)
	end

	GoInput.ask({
		themes = {
			border = {
				text = {
					top = "[interface]",
					top_align = "center",
				},
			},
		},
		prompt = ">",
		on_submit = on_submit,
	})
end

return M
