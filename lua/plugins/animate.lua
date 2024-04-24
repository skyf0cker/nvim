return {
    "echasnovski/mini.animate",
    version = "*",
    config = function()
        local animate = require("mini.animate")
        animate.setup({
            cursor = {
                enable = true,
                timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
            },
            scroll = {
                enable = true,
                timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
            },
            resize = {
                enable = false,
            },
        })

        local original_paste = vim.paste
        local cache_enable_scroll = animate.config.scroll.enable

        vim.paste = function(lines, phase)
            if phase == 1 then
                cache_enable_scroll = MiniAnimate.config.scroll.enable
                MiniAnimate.config.scroll.enable = false
            end

            pcall(original_paste, lines, phase)

            if phase == 3 then
                MiniAnimate.config.scroll.enable = cache_enable_scroll
            end
        end
    end,
}
