return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = true,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd([[ colorscheme catppuccin-mocha ]])
        end,
    },
}
