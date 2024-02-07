local M = {}

local GoInput = require("custom.plugins.go.go-ui.input")
local Job = require("plenary.job")
local Fidget = require("fidget")

local function splitByPattern(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
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
