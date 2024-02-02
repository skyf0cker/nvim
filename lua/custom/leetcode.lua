local M = {}

local Path = require("plenary.path")
local Job = require("plenary.job")

M.setup = function(opts)
	opts = opts or {
		workspace = vim.fn.stdpath("cache") .. "/1eetc0de",
	}

	M.workspace = opts.workspace

	vim.api.nvim_create_user_command("LeetToday", M.leet_today, { nargs = "*" })
end

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

local function get_today_question(title_slug)
	local Question = require("leetcode.api.question")
	local question = Question.by_title_slug(title_slug)

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
	vim.cmd([[e desc.md]])
end

M.leet_today = function()
	require("leetcode.config").setup()
	local Problems = require("leetcode.api.problems")

	Problems.question_of_today(function(qot, err)
		if err then
			error(err)
		end

		local question = get_today_question(qot.title_slug)
		local workspace = Path:new(M.workspace, question.title):joinpath()

		setup_go_workspace(workspace, question.snippet, question.desc)
		open_workspace(workspace)
	end)
end

return M
