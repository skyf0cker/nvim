return {
    "goolord/alpha-nvim",
    config = function()
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
            [[]],
            [[]],
            [[]],
            [[]],
            [[]],
            [[]],
            [[]],
            [[]],
            [[]],
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
            dashboard.button(
                "g",
                "  > DuckDuckGo",
                [[:silent exec "!open -a \"Google Chrome\" https://duckduckgo.com" <CR>]]
            ),
            dashboard.button("f", "  > Find file", ":Telescope find_files<CR>"),
            dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
            dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
        }

        require("alpha").setup(dashboard.config)
    end,
}
