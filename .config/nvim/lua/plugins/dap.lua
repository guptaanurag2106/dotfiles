return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "theHamsta/nvim-dap-virtual-text",
            "leoluz/nvim-dap-go",
            {
                "rcarriga/nvim-dap-ui",
                dependencies = { "nvim-neotest/nvim-nio" },
            },
        },
        keys = {
            { "<F5>",       function() require("dap").continue() end,                                             desc = "Debug: Start/Continue" },
            { "<S-F5>",     function() require("dap").terminate({ all = true, hierarchy = true }) end,            desc = "Debug: Stop" },
            { "<F17>",      function() require("dap").terminate({ all = true, hierarchy = true }) end,            desc = "Debug: Stop" },
            { "<C-S-F5>",   function() require("dap").restart() end,                                              desc = "Debug: Restart" },
            { "<F41>",      function() require("dap").restart() end,                                              desc = "Debug: Restart" },
            { "<F9>",       function() require("dap").toggle_breakpoint() end,                                    desc = "Debug: Toggle Breakpoint" },
            { "<F21>",      function() require("dap").clear_breakpoints() end,                                    desc = "Debug: Clear Breakpoint" },
            { "<F10>",      function() require("dap").step_over() end,                                            desc = "Debug: Step Over" },
            { "<F11>",      function() require("dap").step_into() end,                                            desc = "Debug: Step Into" },
            { "<S-F11>",    function() require("dap").step_out() end,                                             desc = "Debug: Step Out" },
            { "<F23>",      function() require("dap").step_out() end,                                             desc = "Debug: Step Out" },
            { "<leader>d?", function() require("dapui").eval() end,                                               desc = "Debug: Eval" },
            { "<leader>d?", function() require("dapui").eval() end,                                               desc = "Debug: Eval Selection",        mode = "v", },
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Debug: Conditional Breakpoint" },
            { "<leader>dl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point: ")) end,  desc = "Debug: Log Point" },
            { "<leader>dX", function() require("dap").disconnect({ terminateDebuggee = true }) end,               desc = "Debug: Force Disconnect" },
            { "<leader>dp", function() require("dap").pause() end,                                                desc = "Debug: Pause" },
            { "<leader>dg", function() require("dap").run_to_cursor() end,                                        desc = "Debug: Run To Cursor" },
            { "<leader>dn", function() require("dap").step_over({ granularity = "instruction" }) end,             desc = "Debug: Next Instruction" },
            { "<leader>dI", function() require("dap").step_into({ granularity = "instruction" }) end,             desc = "Debug: Into Instruction" },
            { "<leader>du", function() require("dapui").toggle() end,                                             desc = "Debug: Toggle UI" },
            { "<leader>dr", function() require("dap").repl.toggle() end,                                          desc = "Debug: Toggle REPL" },
            { "<leader>ds", function() require("dapui").float_element("scopes", { enter = true }) end,            desc = "Debug: Scopes/Locals" },
            { "<leader>dw", function() require("dapui").float_element("watches", { enter = true }) end,           desc = "Debug: Watches" },
            { "<leader>df", function() require("dapui").float_element("stacks", { enter = true }) end,            desc = "Debug: Frames/Threads" },
            { "<leader>dk", function() require("dapui").float_element("breakpoints", { enter = true }) end,       desc = "Debug: Breakpoints" },
            { "<leader>dt", function() require("dap-go").debug_test() end,                                        desc = "Debug: Go Test" },
            { "<leader>dT", function() require("dap-go").debug_last_test() end,                                   desc = "Debug: Go Last Test" },
            { "<leader>dh", "<cmd>DapKeys<cr>",                                                                   desc = "Debug: Key Help" },
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            local function input(prompt, default)
                local value = vim.fn.input({ prompt = prompt, default = default or "", completion = "file" })
                return value ~= "" and value or dap.ABORT
            end

            local function split_args()
                local args = vim.fn.input("Args: ")
                return args ~= "" and vim.split(args, " ", { trimempty = true }) or {}
            end

            local key_help = {
                "F5          start/continue         F9             breakpoint",
                "Shift-F5    stop                   Ctrl-Shift-F5  restart",
                "F10         step over              F11            step into",
                "Shift-F11   step out               <leader>dp     pause",
                "<leader>du  UI                     <leader>dr     REPL",
                "<leader>ds  scopes/locals          <leader>dw     watches",
                "<leader>df  frames/threads         <leader>dk     breakpoints",
                "<leader>d?  eval hover             <leader>dB     conditional bp",
                "<leader>dn  next instruction       <leader>dI     into instruction",
                "<leader>dX  force disconnect       <leader>dg     run to cursor",
                "<leader>dt  Go test                <leader>dT     Go last test",
                "",
            }

            vim.api.nvim_create_user_command("DapKeys", function()
                vim.notify(table.concat(key_help, "\n"), vim.log.levels.INFO, { title = "nvim-dap" })
            end, {})

            vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DiagnosticSignError" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "C", texthl = "DiagnosticSignWarn" })
            vim.fn.sign_define("DapLogPoint", { text = "L", texthl = "DiagnosticSignInfo" })
            vim.fn.sign_define("DapStopped", { text = ">", texthl = "DiagnosticSignHint", linehl = "Visual" })
            vim.fn.sign_define("DapBreakpointRejected", { text = "R", texthl = "DiagnosticSignError" })

            dap.defaults.fallback.focus_terminal = false
            dap.defaults.fallback.switchbuf = "usevisible,usetab,uselast"
            dap.defaults.fallback.terminal_win_cmd = "botright 12split new"

            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = { "-q", "-i", "dap" },
            }

            dap.configurations.c = {
                {
                    name = "Launch executable (gdb)",
                    type = "gdb",
                    request = "launch",
                    program = function()
                        return input("Executable: ", vim.fn.getcwd() .. "/")
                    end,
                    cwd = "${workspaceFolder}",
                    args = split_args,
                    stopAtBeginningOfMainSubprogram = false,
                },
                {
                    name = "Launch executable, stop at main (gdb)",
                    type = "gdb",
                    request = "launch",
                    program = function()
                        return input("Executable: ", vim.fn.getcwd() .. "/")
                    end,
                    cwd = "${workspaceFolder}",
                    args = split_args,
                    stopAtBeginningOfMainSubprogram = true,
                },
                {
                    name = "Attach process (gdb)",
                    type = "gdb",
                    request = "attach",
                    pid = require("dap.utils").pick_process,
                    cwd = "${workspaceFolder}",
                },
            }
            dap.configurations.cpp = dap.configurations.c

            require("dapui").setup({
                controls = { enabled = true },
                layouts = {
                    {
                        elements = {
                            { id = "scopes",      size = 0.45 },
                            { id = "watches",     size = 0.20 },
                            { id = "stacks",      size = 0.25 },
                            { id = "breakpoints", size = 0.10 },
                        },
                        position = "left",
                        size = 60,
                    },
                    {
                        elements = {
                            { id = "repl", size = 1 },
                        },
                        position = "bottom",
                        size = 12,
                    },
                },
            })

            require("nvim-dap-virtual-text").setup({
                enabled = true,
                commented = true,
                only_first_definition = false,
            })

            require("dap-go").setup({
                delve = {
                    path = "dlv",
                    initialize_timeout_sec = 20,
                },
                dap_configurations = {
                    {
                        type = "go",
                        name = "Debug package (args)",
                        request = "launch",
                        program = "${fileDirname}",
                        args = require("dap-go").get_arguments,
                    },
                },
            })

            -- dap.configurations.go = vim.tbl_filter(function(c)
            --     return c.program ~= "${file}"
            -- end, dap.configurations.go)

            dap.listeners.before.attach.dapui = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui = function()
                dapui.close()
            end
        end,
    },
    {
        "mfussenegger/nvim-lint",
        lazy = true,
        keys = {
            {
                "<leader>fl",
                function()
                    require("lint").try_lint()
                end,
                desc = "Lint document",
            },
        },
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                c = { "clangtidy" },
                cpp = { "clangtidy" },
                python = { "ruff" },
                lua = { "luac" },
                json = { "jq" },
                js = { "eslint" },
                go = { "golangcilint" },
            }
        end,
    },
}
