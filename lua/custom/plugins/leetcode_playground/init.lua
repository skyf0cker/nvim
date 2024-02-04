local Path = require("plenary.path")
local Job = require("plenary.job")

local Pickers = require("telescope.pickers")
local Sorters = require("telescope.sorters")
local Finders = require("telescope.finders")
local Actions = require("telescope.actions")
local ActionState = require("telescope.actions.state")
local EntryDisplay = require("telescope.pickers.entry_display")

local LeetConfig = require("leetcode.config")
LeetConfig.setup()

local LeetProblems = require("leetcode.api.problems")
local LeetProblemList = require("leetcode.cache.problemlist")
local LeetQuestion = require("leetcode.api.question")

require("leetcode.theme").setup()

local function split_into_lines(text)
	local lines = {}
	for line in text:gmatch("([^\n]*)\n?") do
		table.insert(lines, line)
	end

	return lines
end

local function go_mod_init(dir)
	local gomod = dir:joinpath("go.mod")
	if gomod:exists() then
		return
	end

	local notify_when_err = function(_, data, _)
		-- go log into stderr
		vim.notify(data, vim.log.levels.DEBUG, {})
	end

	local notify_when_exit = function(code, _)
		if code == 0 then
			vim.notify("go mod init success", vim.log.levels.INFO, {})
		end
	end

	Job:new({
		command = "go",
		args = { "mod", "init", "qot" },
		cwd = dir.filename,
		on_stderr = notify_when_err,
		on_exit = notify_when_exit,
	}):start()
end

local function setup_descriptions(workspace, desc)
	local description_in_mk = ""

	local notify_when_err = function(_, data, _)
		vim.notify(data, vim.log.levels.ERROR, {})
	end

	local job = Job:new({
		command = "sh",
		args = { "-c", string.format('echo "%s" | html2md -i', desc) },
		cwd = workspace.filename,
		on_stdout = function(_, data, _)
			description_in_mk = description_in_mk .. data .. "\n"
		end,
		on_stderr = notify_when_err,
	})

	job:start()
	job:wait(3000)

	return split_into_lines(description_in_mk)
end

local function setup_go_code(codes)
	local lines = {
		"package main",
		"",
		"func main() {}",
		"",
	}

	for _, code in ipairs(codes) do
		table.insert(lines, code)
	end

	return lines
end

local function create_description_file(dir, descriptions)
	local md = Path:new(dir, "desc.md"):joinpath()
	if md:exists() then
		return
	end

	local ok, err = pcall(vim.fn.writefile, descriptions, md.filename)

	-- Check if the operation was successful
	if ok then
		print("File written successfully")
	else
		print("Error writing file:", err)
	end
end

local function create_go_files(dir, code)
	local main = Path:new(dir, "main.go"):joinpath()
	if main:exists() then
		return
	end

	local ok, err = pcall(vim.fn.writefile, code, main.filename)

	-- Check if the operation was successful
	if ok then
		print("File written successfully")
	else
		print("Error writing file:", err)
	end
end

local function create_workspace(dir)
	if dir:exists() then
		return
	end

	dir:mkdir()
end

local function get_question(title_slug)
	local question = LeetQuestion.by_title_slug(title_slug)

	local code = ""
	for _, snippet in ipairs(question.code_snippets) do
		if snippet.lang == "Go" then
			code = snippet.code
			break
		end
	end

	return {
		title = title_slug,
		desc = question.translated_content,
		snippet = code,
	}
end

local function setup_go_workspace(workspace, snippet, desc)
	create_workspace(workspace)
	go_mod_init(workspace)

	local go_code = setup_go_code(split_into_lines(snippet))
	create_go_files(workspace, go_code)

	local descriptions = setup_descriptions(workspace, desc)
	create_description_file(workspace, descriptions)
end

local function open_workspace(workspace)
	vim.api.nvim_set_current_dir(workspace.filename)
	vim.cmd([[e main.go]])

	vim.keymap.set("n", "<leader>p", function() 
        vim.cmd([[Glow desc.md]])
    end, {
		buffer = 0,
	})
end

local M = {}

function M:_setup_question(title_slug)
	local question = get_question(title_slug)
	local workspace = Path:new(self.workspace, question.title):joinpath()

	setup_go_workspace(workspace, question.snippet, question.desc)
	open_workspace(workspace)
end

local function question_formatter(question)
	return ("%s. %s %s %s"):format(
		tostring(question.frontend_id),
		question.title,
		question.title_cn,
		question.title_slug
	)
end

local function display_difficulty(question)
	local ui_utils = require("leetcode-ui.utils")
	local hl = ui_utils.diff_to_hl(question.difficulty)
	return { "󱓻", hl }
end

local function display_user_status(question)
	if question.paid_only and not LeetConfig.auth.is_premium then
		return { "", "leetcode_medium" }
	end

	local user_status = {
		ac = { "", "leetcode_easy" },
		notac = { "󱎖", "leetcode_medium" },
		todo = { "", "leetcode_alt" },
	}

	if question.status == vim.NIL then
		return { "" }
	end
	return user_status[question.status] or { "" }
end

---@param question lc.cache.Question
local function display_question(question)
	local ac_rate = { ("%.1f%%"):format(question.ac_rate), "leetcode_ref" }
	local index = { question.frontend_id .. ".", "leetcode_normal" }

	local title = { question.title_cn }

	return unpack({ index, title, ac_rate })
end

local displayer = EntryDisplay.create({
	separator = " ",
	items = {
		{ width = 1 },
		{ width = 1 },
		{ width = 5 },
		{ width = 78 },
		{ width = 5 },
	},
})

local function make_display(entry)
	local q = entry.value

	return displayer({
		display_user_status(q),
		display_difficulty(q),
		display_question(q),
	})
end

local function entry_maker(entry)
	return {
		value = entry,
		display = make_display,
		ordinal = question_formatter(entry),
	}
end

local function filter_questions(questions, opts)
	if vim.tbl_isempty(opts or {}) then
		return questions
	end

	return vim.tbl_filter(function(q)
		local diff_flag = true
		if opts.difficulty and not vim.tbl_contains(opts.difficulty, q.difficulty:lower()) then
			diff_flag = false
		end

		local status_flag = true
		if opts.status and not vim.tbl_contains(opts.status, q.status) then --
			status_flag = false
		end

		return diff_flag and status_flag
	end, questions)
end

function M:_pick_question(questions, opts)
	opts = opts or {}

	Pickers.new(opts, {
		prompt_title = "挑选题目",
		finder = Finders.new_table({
			results = filter_questions(questions, opts),
			entry_maker = entry_maker,
		}),
		sorter = Sorters.get_generic_fuzzy_sorter(),
		attach_mappings = function(prompt_bufnr, map)
			Actions.select_default:replace(function()
				local selection = ActionState.get_selected_entry()
				if not selection then
					return
				end

				local q = selection.value
				if q.paid_only and not LeetConfig.auth.is_premium then
					return log.warn("Question is for premium users only")
				end

				Actions.close(prompt_bufnr)
				self:_setup_question(q.title_slug)
			end)
			return true
		end,
	}):find()
end

function M:setup(opts)
	opts = opts or {
		workspace = vim.fn.stdpath("cache") .. "/1eetc0de",
	}

	M.workspace = opts.workspace

	vim.api.nvim_create_user_command("LeetToday", M.leet_today, { nargs = "*" })
	vim.api.nvim_create_user_command("LeetProblems", M.list_questions, { nargs = "*" })
end

function M:leet_today()
	LeetProblems.question_of_today(function(qot, err)
		if err then
			error(err)
		end

		M:_setup_question(qot.title_slug)
	end)
end

function M:list_questions(opts)
	LeetConfig.setup()

	local questions = LeetProblemList.get()

	M:_pick_question(questions, opts)
end

return M
