-- help vim.opt, --help option-list

vim.opt.mouse = 'a'
vim.opt.breakindent = true -- useless as disabled wrap
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.timeoutlen = 350
vim.opt.splitright = true
vim.opt.splitbelow = true
-- vim.opt.list = true
--vim.opt.listchars = { tab = '┬╗ ', trail = '┬╖', nbsp = 'ΓÉú' }
--vim.opt.cursorline = true -- highlights line with cursor
vim.opt.hlsearch = true -- related remap in remap.lua

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.encoding = "utf-8"

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
