return {
    "Bekaboo/deadcolumn.nvim",
    lazy = true,
    config = function()
        vim.opt.colorcolumn = "120"
        require("deadcolumn").setup({})
    end,
    event = { "BufReadPost", "BufNewFile" },
}
