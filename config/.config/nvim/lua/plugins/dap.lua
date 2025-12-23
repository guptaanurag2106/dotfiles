return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
          "williamboman/mason.nvim",
          "mfussenegger/nvim-dap",
        },
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup({})
        end,
      },
      {
        "rcarriga/nvim-dap-ui",
        dependencies = {
          "mfussenegger/nvim-dap",
          "nvim-neotest/nvim-nio",
        },
        config = function()
          local dap = require("dap")
          local dapui = require("dapui")

          dapui.setup()
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

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

      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug | Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>gb", dap.run_to_cursor, { desc = "Debug | Run to Cursor" })
      vim.keymap.set("n", "<leader>dl", function() dap.set_breakpoint(nil, nil, vim.fn.input('Breakpoint condition: ')) end, { desc = "Debug | Set Breakpoint with Condition" })
      vim.keymap.set("n", "<leader>?", function() require("dapui").eval(nil, { enter = true }) end, { desc = "Debug | Evaluate Expression" })
      vim.keymap.set("n", "<F1>", dap.continue, { desc = "Debug | Continue" })
      vim.keymap.set("n", "<F2>", dap.step_into, { desc = "Debug | Step Into" })
      vim.keymap.set("n", "<F3>", dap.step_over, { desc = "Debug | Step Over" })
      vim.keymap.set("n", "<F4>", dap.step_out, { desc = "Debug | Step Out" })
      vim.keymap.set("n", "<F5>", dap.step_back, { desc = "Debug | Step Back" })
      vim.keymap.set("n", "<F12>", dap.restart, { desc = "Debug | Restart" })
      vim.keymap.set("n", "<leader>dt", dapui.toggle, { desc = "Debug UI | Toggle" })
      vim.keymap.set("n", "<leader>dr", function() dapui.open({ reset = true }) end, { desc = "Debug UI | Reset & Open" })
    end,
  },
  {
    'mfussenegger/nvim-lint',
    config = function()
      require('lint').linters_by_ft = {
        c = { 'clangtidy' },
        cpp = { 'clangtidy' },
      }
    end,
  },
}
