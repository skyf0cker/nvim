vim.opt.termguicolors = true

vim.g.encoding = "UTF-8"
vim.o.fileencoding = "utf-8"

vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

-- line number
vim.wo.number = true
vim.wo.relativenumber = true

vim.wo.cursorline = true

vim.wo.signcolumn = "yes"

-- indent
vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftround = true

vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4

vim.o.expandtab = true
vim.bo.expandtab = true
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.incsearch = true

vim.o.cmdheight = 2

vim.o.autoread = true
vim.bo.autoread = true

vim.o.wrap = false
vim.wo.wrap = false

vim.o.whichwrap = "b,s,<,>,[,],h,l"

vim.o.hidden = true

vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

vim.o.updatetime = 300

vim.o.splitbelow = true
vim.o.splitright = true

vim.g.completeopt = "menu,menuone,noselect,noinsert"

vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.pumheight = 10

vim.o.scrolloff=math.floor(0.5 * vim.o.lines)
