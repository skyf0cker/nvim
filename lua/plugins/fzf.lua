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
        require("fzf-lua").setup({
            grep = {
                rg_glob = true,
                glob_flag = "--iglob",
                glob_separator = "%s%-%-",
            },
            keymap = {
                builtin = {
                    ["<C-u>"] = "preview-page-up",
                    ["<C-d>"] = "preview-page-down",
                },
            },
            previewers = {
                builtin = {
                    treesitter = { enable = true },
                    extensions = {
                        ["png"] = { "chafa" },
                        ["jpg"] = { "chafa" },
                    },
                },
            },
        })

        vim.keymap.set({ "i" }, "<C-x><C-f>", function()
            require("fzf-lua").complete_file({
                cmd = "rg --files",
                winopts = { preview = { hidden = "nohidden" } },
            })
        end, { silent = true, desc = "Fuzzy complete file" })

        vim.keymap.set({ "n" }, "<leader>fr", function()
            require("fzf-lua").resume()
        end, { silent = true, desc = "[F]zf [R]esume" })
    end,
    keys = {
        {
            "<leader>ff",
            function()
                require("fzf-lua").files({ cmd = "fd --type f --exclude node_modules --exclude vendor" })
            end,
            desc = "[F]ind [F]ile",
        },
        {
            "<leader>sg",
            function()
                require("fzf-lua").live_grep()
            end,
            desc = "[S]earch by [G]rep",
        },
        {
            "<leader>lb",
            function()
                require("fzf-lua").buffers()
            end,
            desc = "[L]ist [B]uffers",
        },
        {
            "<leader>h",
            function()
                require("fzf-lua").help_tags()
            end,
            desc = "[H]elp",
        },
        {
            "gd",
            function()
                require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
            end,
            desc = "[G]oto [D]efinitions",
        },
        {
            "gr",
            function()
                require("fzf-lua").lsp_references({ includeDeclaration = false })
            end,
            desc = "[G]oto [R]eferences",
        },
        {
            "gi",
            function()
                require("fzf-lua").lsp_implementations({ jump_to_single_result = true })
            end,
            desc = "[G]oto [I]mplementations",
        },
        {
            "<leader>ld",
            function()
                require("fzf-lua").diagnostics_document()
            end,
            desc = "[L]ist [D]iagnostics",
        },
        {
            "<leader>lad",
            function()
                require("fzf-lua").diagnostics_workspace()
            end,
            desc = "[L]ist [A]ll [D]iagnostics",
        },
        {
            "<leader>ls",
            function()
                require("fzf-lua").lsp_document_symbols()
            end,
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
