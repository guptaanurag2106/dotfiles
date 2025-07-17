-- This file can be loaded by calling `lua require("plugins")` from your init.vimpack

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")


    -- Navigation
    use({
        "nvim-telescope/telescope.nvim",
        requires = { { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
        },
        config = function()
            require("telescope").load_extension("fzf")
        end
    })
    use("stevearc/oil.nvim")
    use("theprimeagen/harpoon")

    --Syntax Highlight
    use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
    use("nvim-treesitter/playground")
    use("nvim-treesitter/nvim-treesitter-context")
    use("RRethy/vim-illuminate")

    --Git
    use("tpope/vim-fugitive")
    use("tpope/vim-rhubarb")
    use("lewis6991/gitsigns.nvim")
    use("sindrets/diffview.nvim")
    use("mbbill/undotree")

    --LSP/DAP
    use({ "williamboman/mason.nvim", tag = "stable" })
    use({ "williamboman/mason-lspconfig.nvim", tag = "stable" })
    use("neovim/nvim-lspconfig")
    use({
        "crispgm/nvim-go",
        requires = {
            "leoluz/nvim-dap-go",
        },
        config = function()
            require("go").setup({})
        end,
    })
    use("mfussenegger/nvim-dap")
    use({
        "jay-babu/mason-nvim-dap.nvim",
        requires = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
    })
    use({
        "theHamsta/nvim-dap-virtual-text",
        config = function()
            require("nvim-dap-virtual-text").setup({})
        end,
    })
    use({
        "rcarriga/nvim-dap-ui",
        requires = {
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
    })

    -- Completion/Snippet
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-cmdline")
    use("hrsh7th/cmp-path")
    use("hrsh7th/nvim-cmp")
    use("saadparwaiz1/cmp_luasnip")
    use("hrsh7th/cmp-nvim-lsp-signature-help")
    use({
        "L3MON4D3/LuaSnip",
        run = "make install_jsregexp",
        requires = { { "rafamadriz/friendly-snippets", "sirver/ultisnips" } },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            local ls = require("luasnip")
            ls.filetype_extend("c", { "cdoc" })
            ls.filetype_extend("cpp", { "cppdoc" })
            vim.keymap.set({ "i" }, "<C-H>", function()
                ls.expand()
            end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-K>", function()
                ls.jump(1)
            end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-J>", function()
                ls.jump(-1)
            end, { silent = true })
        end,
    })
    use({
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup({})
        end,
    })

    -- Theme
    use("nvim-tree/nvim-web-devicons")
    use("ellisonleao/gruvbox.nvim")
    use("navarasu/onedark.nvim")
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "nvim-tree/nvim-web-devicons", opt = true },
        config = function()
            require("lualine").setup({})
        end,
    })
    use({
        "stevearc/dressing.nvim",
        config = function()
            require("dressing").setup({})
        end,
    })

    --Dev
    use("vimwiki/vimwiki")

    use({
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        config = function()
            require('lazydev').setup {
                library = {
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            }
        end,
    })

    use({
        "folke/which-key.nvim",
    })


    -- Comments
    use({
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup({
                signs = false,
            })
        end,
    })
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    })

    --Proj Manage
    use({
        "folke/trouble.nvim",
        requires = "nvim-tree/nvim-web-devicons",
        config = function()
            require("trouble").setup({})
        end,
    })
    use({
        "hedyhli/outline.nvim",
        config = function()
            require("outline").setup({})
        end,
    })
    use("folke/zen-mode.nvim")

    -- use {
    --     "echasnovski/mini.nvim",
    --     config = function()
    --         require("mini.ai").setup { n_lines = 500 }
    --
    --         require("mini.surround").setup()
    --
    --         local statusline = require "mini.statusline"
    --
    --         -- set use_icons to true if you have a Nerd Font
    --         statusline.setup { use_icons = vim.g.have_nerd_font }
    --
    --         statusline.section_location = function()
    --             return "%2l:%-2v"
    --         end
    --     end,
    -- }


    use({
        "/home/tanz/Documents/dev/projects/run.nvim/",
        requires = { { "nvim-lua/plenary.nvim" } },
        config = function()
            require("run").setup({
                ask_confirmation = false
            })
        end
    })
end)
