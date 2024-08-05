vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- go to explorer on pressing <leader>pv in normal (n) mode

-- Removed via oil.nvim
-- vim.keymap.set("n", "<leader>pf", vim.cmd('Ex'))

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("x", "<leader>p", [["-dP]])

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set('n', '<leader>W', ':lua vim.api.nvim_exec([[%s/\\s\\+$//e | let @/=""]], true)<CR>',
    { noremap = true, silent = true })


vim.api.nvim_create_user_command("Mmake", "make! | copen", {})
