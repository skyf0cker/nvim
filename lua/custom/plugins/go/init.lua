local M = {}

local GoInput = require("custom.plugins.go.go-ui.input")
local Job = require("plenary.job")
local Fidget = require("fidget")

local function get_go_test_func_nodes()
    local ok, parser = pcall(vim.treesitter.get_parser, 0, "go")
    if not ok then
        print("Failed to get parser range for go")
        return
    end

    local tree = parser:parse()[1]
    local root = tree:root()
    local query = vim.treesitter.query.parse(
        "go",
        [[
        (function_declaration 
            name: (identifier) @function_name (#match? @function_name "^Test.*")
            parameters: (parameter_list 
              (parameter_declaration 
                name: (identifier) 
                type: (pointer_type 
                  (qualified_type 
                    package: (package_identifier)  @package_name (#eq? @package_name "testing")
                    name: (type_identifier))))
            )
        ) @function
        ]]
    )

    local funcs = {}
    local current_func = {}
    for id, node in query:iter_captures(root, 0, 0, -1) do
        if #current_func == 2 then
            table.insert(funcs, current_func)
            current_func = {}
        end

        if id == 1 then
            table.insert(current_func, node)
        end

        if id == 3 then
            table.insert(current_func, node)
        end
    end

    return funcs
end

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

local fzf = require("fzf-lua")
local builtin = require("fzf-lua.previewer.builtin")

local GoTestPreviewer = builtin.base:extend()

function GoTestPreviewer:new(o, opts, fzf_win)
    GoTestPreviewer.super.new(self, o, opts, fzf_win)
    setmetatable(self, GoTestPreviewer)
    return self
end

function GoTestPreviewer:populate_preview_buf(entry_str)
    local func_node = self.func_tables[entry_str]
    local start_row, _, end_row, _ = func_node:range()
    local lines = vim.api.nvim_buf_get_lines(self.current_buf, start_row, end_row + 1, false)

    local tmpbuf = self:get_tmp_buffer()
    vim.api.nvim_buf_set_option(tmpbuf, "filetype", "go")
    vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, lines)

    self:set_preview_buf(tmpbuf)
    self.win:update_scrollbar()
end

-- Disable line numbering and word wrap
function GoTestPreviewer:gen_winopts()
    local new_winopts = {
        wrap = false,
        number = true,
    }
    return vim.tbl_extend("force", self.winopts, new_winopts)
end

function M.list_go_tests(opts)
    opts = opts or {}

    local bufnr = vim.api.nvim_get_current_buf()
    local path = vim.api.nvim_buf_get_name(bufnr)
    local folder_path = path:match("(.*/)")

    local funcs = get_go_test_func_nodes()
    local names = {}
    local func_tables = {}

    for _, nodes in ipairs(funcs) do
        local func_name_node = nodes[2]
        local func_node = nodes[1]
        local name = vim.treesitter.get_node_text(func_name_node, bufnr)

        table.insert(names, name)
        func_tables[name] = func_node
    end

    print(vim.inspect(func_tables))

    GoTestPreviewer.func_tables = func_tables
    GoTestPreviewer.current_buf = bufnr

    fzf.fzf_exec(names, {
        prompt = "Go Tests❯ ",
        previewer = {
            _ctor = function()
                return GoTestPreviewer
            end,
        },
        actions = {
            ["default"] = function(selected)
                local cmd = "go test -v -timeout 3600s -run ^" .. selected[1] .. "$ " .. folder_path
                vim.cmd(string.format([[TermExec cmd="%s" dir=%s direction=horizontal]], cmd, folder_path))
            end,
        },
        winopts = {
            split = "belowright new",
        },
    })
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
    local line = vim.api.nvim_get_current_line()
    local type_name = string.match(line, "type ([%w_-]+) [%w%[%]%{%}]+")
    local receiver = type_name:sub(1, 1):lower()

    fzf.fzf_exec([[rg "^type .* interface"]], {
        fn_transform = function(x)
            local path, interface = string.match(x, [[^(.*):type (.*) interface.*]])
            return require("fzf-lua").utils.ansi_codes.magenta(interface) .. " => " .. path
        end,
        actions = {
            ["default"] = function(selected)
                local raw = selected[1]
                local interface, pkg = string.match(raw, [[^(.*) => .*/(.*)/.*%.go]])

                local result = exec_goimpl(("%s *%s"):format(receiver, type_name), pkg .. "." .. interface)
                if result.err ~= "" then
                    vim.notify(result.err, vim.log.levels.ERROR)
                    return
                end

                vim.fn.setreg("+", result.stubs)
                Fidget.notify("impl stubs copied to clipboard", vim.log.levels.INFO)
            end,
        },
    })
end

return M
