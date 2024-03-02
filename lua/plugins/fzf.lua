return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = true,
    config = function()
        -- calling `setup` is optional for customization
        require("fzf-lua").setup({})
    end,
    keys = {
        {
            "<leader>ff",
            "<cmd>FzfLua files<CR>",
            desc = "[F]ind [F]ile",
        },
        {
            "<leader>sg",
            "<cmd>FzfLua live_grep<CR>",
            desc = "[S]earch by [G]rep",
        },
        {
            "<leader>lb",
            "<cmd>FzfLua buffers<CR>",
            desc = "[L]ist [B]uffers",
        },
        {
            "<leader>h",
            "<cmd>FzfLua help_tags<CR>",
            desc = "[H]elp",
        },
        {
            "gd",
            "<cmd>FzfLua lsp_definitions<CR>",
            desc = "[G]oto [D]efinitions",
        },
        {
            "gr",
            "<cmd>FzfLua lsp_references<CR>",
            desc = "[G]oto [R]eferences",
        },
        {
            "gi",
            "<cmd>FzfLua lsp_implementations<CR>",
            desc = "[G]oto [I]mplementations",
        },
        {
            "<leader>ld",
            "<cmd>FzfLua diagnostics_document<CR>",
            desc = "[L]ist [D]iagnostics",
        },
        {
            "<leader>lad",
            "<cmd>FzfLua diagnostics_workspace<CR>",
            desc = "[L]ist [A]ll [D]iagnostics",
        },
    },
}
