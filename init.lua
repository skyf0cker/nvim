local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- deps
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	ui = {
		change_detection = {
			enabled = true,
			notify = false,
		},
	},
	dev = {
		path = vim.fn.stdpath("config") .. "/lua/custom/plugins",
        patterns = {
            "leetcode_custom"
        }
	},
})

require("basic")
require("keymap")
