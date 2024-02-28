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
})

require("basic")
require("keymap")

local luarocks_path = vim.fn.expand("~/.luarocks/share/lua/5.1/?.lua")
local luarocks_cpath = vim.fn.expand("~/.luarocks/lib/lua/5.1/?/?.so")
package.path = package.path .. ";" .. luarocks_path
package.cpath = package.cpath .. ";" .. luarocks_cpath
