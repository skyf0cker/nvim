return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        local p = require("rose-pine.palette")
        require("bufferline").setup({
            highlights = {
                fill = {
                    guifg = p.text,
                    guibg = p.base,
                },
                background = {
                    guifg = p.text,
                    guibg = p.base,
                },
            },
            options = {
                mode = "tabs",
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count, level, _, _)
                    local icon = level:match("error") and " " or " "
                    return " " .. icon .. count
                end,
                separator_style = "slant",
                show_close_icon = false,
                show_buffer_close_icons = false,
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        highlight = "Directory",
                        separator = true, -- use a "true" to enable the default, or set your own character
                    },
                },
            },
        })
    end,
}
