return {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
        { "nvim-telescope/telescope.nvim" },
    },
    config = function()
        require("neoclip").setup({
            keys = {
                telescope = {
                    i = {
                        select = "<cr>",
                        paste = "<c-p>",
                        paste_behind = "<c-k>",
                        replay = "<c-q>", -- replay a macro
                        delete = "<c-d>", -- delete an entry
                        edit = "<c-e>", -- edit an entry
                        custom = {},
                    },
                    n = {
                        select = "<cr>",
                        paste = "p",
                        paste_behind = "P",
                        replay = "q",
                        delete = "d",
                        edit = "e",
                        custom = {},
                    },
                },
            },
        })
    end,
}
