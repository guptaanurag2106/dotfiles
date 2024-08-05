vim.keymap.set("n", "<leader>xo", "<cmd>Trouble diagnostics toggle<cr>",
    { silent = true, noremap = true, desc = "Diagnostics (Trouble)" }
)

vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    { silent = true, noremap = true, desc = "Buffer Diagnostics (Trouble)" }
)

vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>",
    { silent = true, noremap = true, desc = "Symbols (Trouble)" }
)

vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>",
    { silent = true, noremap = true, desc = "Location list (Trouble)" }
)

vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>",
    { silent = true, noremap = true, desc = "Quickfix list (Trouble)" }
)

-- Diagnostic signs
-- https://github.com/folke/trouble.nvim/issues/52
-- local signs = {
--     Error = " ",
--     Warning = " ",
--     Hint = " ",
--     Information = " "
-- }
local signs = {
    Error = "E",
    Warning = "W",
    Hint = "H",
    Information = "I"
}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
