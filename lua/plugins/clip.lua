return {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
        { "ibhagwan/fzf-lua" },
    },
    lazy = true,
    config = function()
        require("neoclip").setup({
            keys = {
                fzf = {
                    select = "default",
                    paste = "p",
                },
            },
        })

        vim.keymap.set("n", "<leader>lc", function()
            require("neoclip.fzf")()
        end, {
            desc = "[L]ist [C]lipboard",
        })
    end,
    event = { "BufReadPost", "BufNewFile" },
}
