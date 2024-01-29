return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    lazy = true,
    keys = {
        {
            "<c-t>h",
            function()
                return "<cmd> " .. vim.v.count .. "ToggleTerm direction=horizontal <cr>"
            end,
            mode = { "n", "t" },
            expr = true,
            desc = "create terminal horizontally",
        },
        {
            "<c-t>v",
            function()
                return "<cmd> " .. vim.v.count .. "ToggleTerm direction=vertical <cr>"
            end,
            mode = { "n", "t" },
            expr = true,
            desc = "create terminal vertically",
        },
        {
            "<c-t>f",
            function()
                return "<cmd> " .. vim.v.count .. "ToggleTerm direction=float <cr>"
            end,
            mode = { "n", "t" },
            expr = true,
            desc = "create terminal float",
        },
        {
            "<c-t>n",
            [[<C-\><C-n>]],
            mode = { "t" },
            desc = "back to normal mode",
        },
    },
}
