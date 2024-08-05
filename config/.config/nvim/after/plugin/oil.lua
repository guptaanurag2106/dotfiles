vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent dir (Oil)" })
vim.keymap.set("n", "<leader>-", require("oil").toggle_float, { desc = "Open parent dir (Oil)" })
