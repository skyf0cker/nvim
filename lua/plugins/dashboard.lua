return {
    "goolord/alpha-nvim",
    config = function()
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
            [[  ,-.       _,---._ __  / \       ]],
            [[ /  )    .-'       `./ /   \      ]],
            [[(  (   ,'            `/    /|     ]],
            [[ \  `-"             \'\   / |     ]],
            [[  `.              ,  \ \ /  |     ]],
            [[   /`.          ,'-`----Y   |     ]],
            [[  (            ;        |   '     ]],
            [[  |  ,-.    ,-'         |  /      ]],
            [[  |  | (   |  dumpling  | /       ]],
            [[  )  |  \  `.___________|/        ]],
            [[  `--'   `--'                     ]],
        }

        dashboard.section.buttons.val = {
            dashboard.button("l", "  > Leetcode", [[:silent Leet <CR>]]),
            dashboard.button("w", "󰯉  > Workspaces", ":Telescope workspaces<CR>"),
            dashboard.button("f", "󰈞  > Find file", ":FzfLua files<CR>"),
            dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
            dashboard.button("q", "󰜎  > Quit NVIM", ":qa<CR>"),
        }

        dashboard.config.opts.setup = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "AlphaReady",
                desc = "disable tabline for alpha",
                callback = function()
                    vim.opt.showtabline = 0
                end,
            })
            vim.api.nvim_create_autocmd("BufUnload", {
                buffer = 0,
                desc = "enable tabline after alpha",
                callback = function()
                    vim.opt.showtabline = 2
                end,
            })
        end

        require("alpha").setup(dashboard.config)
    end,
}
