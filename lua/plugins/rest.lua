return {
    "rest-nvim/rest.nvim",
    -- branch = "dev",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    lazy = true,
    config = function()
        require("rest-nvim").setup({
            result_split_horizontal = true,
            highlight = {
                enabled = true,
                timeout = 150,
            },
            result = {
                -- toggle showing URL, HTTP info, headers at top the of result window
                show_url = true,
                -- show the generated curl command in case you want to launch
                -- the same request via the terminal (can be verbose)
                show_curl_command = false,
                show_http_info = true,
                show_headers = true,
                -- table of curl `--write-out` variables or false if disabled
                -- for more granular control see Statistics Spec
                show_statistics = false,
                -- executables or functions for formatting response body [optional]
                -- set them to false if you want to disable them
                formatters = {
                    json = "jq",
                    html = function(body)
                        return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
                    end,
                },
            },
        })

        vim.keymap.set("n", "<leader>rr", "<Plug>RestNvim", {
            desc = "[R]est [R]equest",
            silent = true,
        })

        vim.keymap.set("n", "<leader>rp", "<Plug>RestNvimPreview", {
            desc = "[R]est [P]review",
            silent = true,
        })

        vim.keymap.set("n", "<leader>rl", "<Plug>RestNvimLast", {
            desc = "[R]est [L]ast",
            silent = true,
        })
    end,
    event = {
        "BufEnter *.http",
    },
}
