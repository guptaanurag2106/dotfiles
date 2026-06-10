return {
    {
        "stevearc/oil.nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter" },
        keys = {
            { "-",         "<CMD>Oil<CR>",                               desc = "Open parent dir (Oil)" },
            { "<leader>-", function() require("oil").toggle_float() end, desc = "Open parent dir (Oil) float" },
        },
        config = function()
            function _G.get_oil_winbar()
                local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
                local dir = require("oil").get_current_dir(bufnr)
                if dir then
                    return vim.fn.fnamemodify(dir, ":~")
                else
                    return vim.api.nvim_buf_get_name(0)
                end
            end

            local detail = true
            require("oil").setup({
                win_options = {
                    winbar = "%!v:lua.get_oil_winbar()",
                },
                view_options = {
                    show_hidden = true,
                },
                columns = { "icon" },
                keymaps = {
                    ["gd"] = {
                        desc = "Toggle file detail view",
                        callback = function()
                            detail = not detail
                            if detail then
                                require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
                            else
                                require("oil").set_columns({ "icon" })
                            end
                        end,
                    },
                },
            })
        end,
    },
    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        keys = {
            -- vim.keymap.set("n", "<leader>xs", "<cmd>Outline<cr>",
            --     { silent = true, noremap = true, desc = "Symbols (Outline)" }
            { "<leader>xo", "<cmd>Trouble diagnostics toggle<cr>",                                             desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",                                desc = "Buffer Diagnostics (Trouble)" },
            { "<leader>xs", "<cmd>Trouble symbols toggle pinned=true win.relative=win win.position=right<cr>", desc = "Symbols (Trouble)" },
            { "<leader>xl", "<cmd>Trouble loclist toggle<cr>",                                                 desc = "Location list (Trouble)" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                                                  desc = "Quickfix list (Trouble)" },
        },
        config = function()
            require("trouble").setup({})
        end,
    },
}
