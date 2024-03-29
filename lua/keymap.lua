vim.keymap.set("v", "<leader>y", '"+y', {
    noremap = true,
    desc = "copy into system clipboard",
})

-- vim.o.foldnestmax = 1
--
-- local function fold_all()
--     if vim.o.foldmethod ~= "indent" then
--         vim.o.foldmethod = "indent"
--         vim.cmd([[exe "normal zM"]])
--     else
--         vim.o.foldmethod = "manual"
--         vim.cmd([[exe "normal zR"]])
--     end
-- end
--
-- vim.keymap.set("n", "zA", fold_all, {
--     silent = true,
--     noremap = true,
--     desc = "fold all block",
-- })
--

vim.keymap.set("n", "<c-w>>", "10<c-w>>", {
    desc = "10x increase width",
})

vim.keymap.set("n", "<c-w><", "10<c-w><", {
    desc = "10x increase width",
})
