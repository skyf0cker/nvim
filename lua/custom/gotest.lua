local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
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

M.list = function(opts)
    opts = opts or {}

    local bufnr = vim.api.nvim_get_current_buf()

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
                    local selection = actions.get_selected_entry(prompt_bufnr)
                    actions.close(prompt_bufnr)
                    -- Do something with the selection
                end)
                return true
            end,
        })
        :find()
end

return M
