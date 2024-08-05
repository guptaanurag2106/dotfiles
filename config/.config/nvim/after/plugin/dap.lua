local dap = require("dap")
local dapui = require("dapui")

-- dap.adapters.codelldb = {
--     type = "server",
--     host = "127.0.0.1",
--     port = 13000,
--     executable = {
--         command = "codelldb",
--         args = { "--port", "13000" }
--     }
-- }
dap.adapters.gdb = {
    type = "executable",
    command = "gdb",
    args = { "-q", "-i", "dap" },
    name = "cppdbg"
}

dap.configurations.c = {
    {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " ")
        end,
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        stopAtBeginningOfMainSubprogram = false,
    },
}

dap.configurations.cpp = dap.configurations.c

vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>gb", dap.run_to_cursor)
-- vim.keymap.set("n", "<leader>dB",
--     dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')),
--     { desc = "DAP | Breakpoint Condition", silent = true }
-- )
vim.keymap.set("n", "<leader>dl", function() dap.set_breakpoint(nil, nil, vim.fn.input('Breakpoint condition: ')) end)


vim.keymap.set("n", "<leader>?", function()
    require("dapui").eval(nil, { enter = true })
end)

vim.keymap.set("n", "<F1>", dap.continue)
vim.keymap.set("n", "<F2>", dap.step_into)
vim.keymap.set("n", "<F3>", dap.step_over)
vim.keymap.set("n", "<F4>", dap.step_out)
vim.keymap.set("n", "<F5>", dap.step_back)
vim.keymap.set("n", "<F12>", dap.restart)

vim.keymap.set("n", "<leader>dt", dapui.toggle)
vim.keymap.set("n", "<leader>dr", function() dapui.open({ reset = true }) end)
