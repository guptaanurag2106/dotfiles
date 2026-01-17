return {
    { "RRethy/vim-illuminate",   enabled = false },
    { 'rhysd/git-messenger.vim', cmd = 'GitMessenger', enabled = false },
    {
        "crispgm/nvim-go",
        dependencies = {
            "leoluz/nvim-dap-go",
        },
        config = function()
            require("go").setup({})
        end,
        enabled = false
    },
    {
        "stevearc/dressing.nvim",
        config = function()
            require("dressing").setup({})
        end,
        enabled = false
    },
    { "folke/which-key.nvim", enabled = false },
    {
        "hedyhli/outline.nvim",
        config = function()
            require("outline").setup({})
        end,
        enabled = false
    },

    -- Mini.nvim Suite (Surround, AI, Pairs, Starter, etc.)
    {
        "echasnovski/mini.nvim",
        enabled = false,
        config = function()
            require("mini.ai").setup({ n_lines = 500 })
            require("mini.surround").setup()
            require("mini.pairs").setup()       -- Auto-pairs
            require("mini.comment").setup()     -- Commenting
            
            -- Optional: Mini.starter (Dashboard alternative)
            -- require("mini.starter").setup() 

            local statusline = require("mini.statusline")
            statusline.setup({ use_icons = vim.g.have_nerd_font })
            statusline.section_location = function()
                return "%2l:%-2v"
            end
        end,
    },

    -- Session Management
    {
        "folke/persistence.nvim",
        enabled = false,
        event = "BufReadPre", 
        config = function() require("persistence").setup() end,
        keys = {
            { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
            { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
        }
    },

    -- Multi-Cursor Editing
    {
        "mg979/vim-visual-multi",
        enabled = false,
        branch = "master",
        init = function()
            -- Multi-cursor keys
            vim.g.VM_maps = {
                ["Find Under"] = "<C-n>",
                ["Find Subword Under"] = "<C-n>",
            }
        end,
    },

    -- Git Interface (Magit-style)
    {
        "NeogitOrg/neogit",
        enabled = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim", -- Enhanced diff view
            "nvim-telescope/telescope.nvim",
        },
        keys = {
            { "<leader>gs", "<cmd>Neogit<cr>", desc = "Neogit" },
        },
        config = true,
    },
}
