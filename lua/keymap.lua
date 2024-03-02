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

vim.keymap.set("n", "<c-b>", ":Lexplore<CR>", {
    desc = "Explore",
    silent = true,
})

local function netrw_keymap()
    local opts = {
        buffer = true,
        remap = true,
    }

    vim.keymap.set("n", "l", "<CR>", opts)
    vim.keymap.set("n", "h", "-", opts)
    vim.keymap.set("n", ".", "gh", opts)
    vim.keymap.set("n", "P", "<C-w>z", opts)
    vim.keymap.set("n", "<C-b>", "<cmd>Lexplore<CR>", opts)
    vim.keymap.set("n", "a", "%:w<CR>:buffer #<CR>", opts)
end

-- local group = vim.api.nvim_create_augroup("NetrwSettings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = netrw_keymap,
    -- group = group,
})
