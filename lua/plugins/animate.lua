return {
    "echasnovski/mini.animate",
    version = "*",
    config = function()
        local animate = require("mini.animate")
        animate.setup({
            scroll = {
                enable = true,
                timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
            },
            resize = {
                enable = false,
            },
        })
    end,
}
