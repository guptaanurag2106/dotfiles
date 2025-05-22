vim.keymap.set({ "v", "n" }, "<leader>r", ":RunFileAsync<CR>", { desc = "(Run.nvim) Async on selection" })
require("run").set_current_browser("oil")
