vim.keymap.set({ "v", "n" }, "<leader>r", ":RunFile<CR>", { desc = "(Run.nvim) Async on selection" })
require("run").set_current_browser("oil")
