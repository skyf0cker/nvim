return {
    "yuchanns/ccr.nvim",
    lazy = true,
    keys = {
        {
            "<leader>cr",
            function()
                require("ccr").copy_rel_path_and_line()
            end,
        },
    },
}
