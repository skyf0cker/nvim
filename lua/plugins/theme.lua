return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd([[colorscheme rose-pine]])
        end,
    },
    {
        "catppuccin/nvim",
        lazy = true,
        name = "catppuccin",
        priority = 1000,
        -- config = function()
        --     vim.cmd([[ colorscheme catppuccin-mocha ]])
        -- end,
    },
    -- {
    -- 	"gambhirsharma/vesper.nvim",
    -- 	lazy = false,
    -- 	priority = 1000,
    -- 	name = "vesper",
    -- 	config = function()
    -- 		vim.cmd([[colorscheme vesper]])
    -- 	end,
    -- },
    {
        "datsfilipe/vesper.nvim",
        config = function()
            require("vesper").setup({
                transparent = false, -- Boolean: Sets the background to transparent
                italics = {
                    comments = true, -- Boolean: Italicizes comments
                    keywords = true, -- Boolean: Italicizes keywords
                    functions = true, -- Boolean: Italicizes functions
                    strings = true, -- Boolean: Italicizes strings
                    variables = true, -- Boolean: Italicizes variables
                },
                overrides = {}, -- A dictionary of group names, can be a function returning a dictionary or a table.
            })

            -- vim.cmd([[colorscheme vesper]])
        end,
    },
}
