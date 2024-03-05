return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("oil").setup()
        vim.keymap.set("n", "<C-b>", function()
            require("oil").toggle_float()
        end, {})
    end,
}
