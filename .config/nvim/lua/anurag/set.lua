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
vim.opt.autoindent = true

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

-- vim.opt.cmdheight = 2                -- Set height to prevent 'press enter to continue'  Set command-line height to 2 rows. Gives more room for messages and reduces "Press ENTER" pauses.
vim.o.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position
vim.o.jumpoptions = "view"           -- save 'view' when jumping
vim.o.ruler = true
-- vim.o.showmatch = true

vim.o.foldenable = true

vim.wo.list = true

vim.opt.updatetime = 300
vim.opt.colorcolumn = "80"
vim.g.c_syntax_for_h = 1 -- Use C syntax for `.h` files, not C++

vim.opt.matchpairs:append("<:>")
