return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup({
            signcolumn = true,
        })
    end,
    lazy = true,
    keys = {
        {
            "<leader>gb",
            function()
                vim.cmd([[Gitsigns toggle_current_line_blame]])
            end,
            desc = "[G]it [B]lame",
        },
        {
            "<leader>gp",
            function()
                vim.cmd([[Gitsigns preview_hunk]])
            end,
            desc = "[G]it [P]review hunk",
        },
        {
            "<leader>gd",
            function()
                vim.cmd([[Gitsigns diffthis]])
            end,
            desc = "[G]it [D]iff",
        },
    },
    event = { "BufReadPost", "BufNewFile" },
}
