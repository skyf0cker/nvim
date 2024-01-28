return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("telescope").setup({
            defaults = {
                -- Default configuration for telescope goes here:
                -- config_key = value,
                layout_config = {
                    vertical = {
                        preview_cutoff = 0,
                    },
                },
                layout_strategy = "vertical",
                mappings = {
                    i = {
                        -- map actions.which_key to <C-h> (default: <C-/>)
                        -- actions.which_key shows the mappings for your picker,
                        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                        ["<C-h>"] = "which_key",
                    },
                },
                file_ignore_patterns = {
                    "^vendor/",
                },
            },
        })

        require("telescope").load_extension("toggletasks")
        require("telescope").load_extension("neoclip")
    end,
    keys = {
        {
            "<leader>ff",
            require("telescope.builtin").find_files,
            desc = "[F]ind [F]iles"
        },
        {
            "<leader>sg",
            require("telescope.builtin").live_grep,
            desc = "[S]earch by [G]rep"
        },
        {
            "<leader>lb",
            require("telescope.builtin").buffers,
            desc = "[L]ist [B]uffers"
        },
        {
            "<leader>h",
            require("telescope.builtin").help_tags,
            desc = "[H]elp"
        },
        {
            "<leader>ln",
            require('telescope').extensions.notify.notify,
            desc = "[L]ist [N]otify"
        },
        {
            "<leader>st",
            require('telescope.builtin').treesitter,
            desc = "[S]earch [T]reesitter"
        },
        {
            "gd",
            require('telescope.builtin').lsp_definitions,
            desc = "[G]oto [D]efinitions"
        },
        {
            "gr",
            require('telescope.builtin').lsp_references,
            desc = "[G]oto [R]eferences"
        },
        {
            "gi",
            require('telescope.builtin').lsp_implementations,
            desc = "[G]oto [I]mplementations"
        },
        {
            "<leader>ld",
            require("telescope.builtin").diagnostics,
            desc = "[L]ist [D]iagnostics"
        },
        {
            "<leader>lf",
            function()
                require("telescope.builtin").lsp_document_symbols({ symbols = 'function' })
            end,
            desc = "[L]ist [F]unctions"
        },
        {
            "<leader>lm",
            function()
                require("telescope.builtin").lsp_document_symbols({ symbols = 'method' })
            end,
            desc = "[L]ist [M]ethods"
        },
        {
            "<leader>lc",
            require("telescope").extensions.neoclip.default,
            desc = "[L]ist [C]lipboard"
        },
        {
            "<leader>lt",
            require('telescope').extensions.toggletasks.select,
            desc = "[L]ist [T]asks"
        },
        {
            "<leader>swt",
            require('telescope').extensions.toggletasks.spawn,
            desc = "[S]pa[W]n [T]asks"
        }
    },
}
