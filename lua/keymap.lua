vim.keymap.set("v", "<leader>y", '"+y', {
	noremap = true,
	desc = "copy into system clipboard",
})

vim.o.foldnestmax = 1

local function fold_all()
	if vim.o.foldmethod ~= "indent" then
		vim.o.foldmethod = "indent"
		vim.cmd([[exe "normal zM"]])
	else
		vim.o.foldmethod = "manual"
		vim.cmd([[exe "normal zR"]])
	end
end

vim.keymap.set("n", "zA", fold_all, {
	silent = true,
	noremap = true,
	desc = "fold all block",
})

-- telescope
local builtin = require("telescope.builtin")
-- vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
-- vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
-- vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
-- vim.keymap.set("n", "<leader>ft", builtin.treesitter, {})
-- vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})

-- lsp picker key mapping
-- vim.keymap.set("n", "gd", builtin.lsp_definitions, {})
-- vim.keymap.set("n", "gr", builtin.lsp_references, {})
-- vim.keymap.set("n", "gi", builtin.lsp_implementations, {})
vim.keymap.set("n", "gss", builtin.git_status, {})

-- extension
require("telescope").load_extension("toggletasks")
local extensions = require("telescope").extensions
vim.keymap.set("n", "<leader>ts", extensions.toggletasks.select, { desc = "toggletasks: select" })
vim.keymap.set("n", "<leader>fs", extensions.toggletasks.spawn, { desc = "toggletasks: spawn" })

vim.keymap.set("n", "<leader>nl", extensions.notify.notify, { desc = "notify: list" })

require("telescope").load_extension("neoclip")
vim.keymap.set("n", "<leader>ca", extensions.neoclip.default)

