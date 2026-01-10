return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-context",
                config = function()
                    require('treesitter-context').setup {
                        enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
                        multiwindow = false,      -- Enable multiwindow support.
                        max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
                        min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                        line_numbers = true,
                        multiline_threshold = 20, -- Maximum number of lines to show for a single context
                        trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                        mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
                        separator = nil,
                        zindex = 20,
                        on_attach = nil,
                    }
                end
            }
        },
        config = function(_, opts)
            require("nvim-treesitter").setup(opts)
        end,
        opts = {
            highlight = { enable = true },
            indent = { enable = true },
            autotag = { enable = true },
            ensure_installed = {
                "c",
                "cpp",
                "go",
                "lua",
                "python",
                "typescript",
                "javascript",
                "json",
                "bash",
                "vim",
                "vimdoc",
            },
            auto_install = true,
        },
    },
    {
        "tpope/vim-fugitive",
        cmd = { "Fugitive", "Git" },
        keys = {
            { "<leader>gs", vim.cmd.Git, desc = "Open Git" },
        },
        config = function()
            local User_Fugitive = vim.api.nvim_create_augroup("UserFugitive", {})

            local autocmd = vim.api.nvim_create_autocmd
            autocmd("BufWinEnter", {
                group = User_Fugitive,
                pattern = "*",
                callback = function()
                    if vim.bo.ft ~= "fugitive" then
                        return
                    end

                    local bufnr = vim.api.nvim_get_current_buf()
                    vim.keymap.set("n", "<leader>p", function()
                        vim.cmd.Git('push')
                    end, { buffer = bufnr, remap = false, desc = "Push (Fugitive)" })

                    -- rebase always
                    vim.keymap.set("n", "<leader>P", function()
                        vim.cmd.Git('pull --rebase')
                    end, { buffer = bufnr, remap = false, desc = "Pull rebase (Fugitive)" })

                    -- NOTE: It allows me to easily set the branch i am pushing and any tracking
                    -- needed if i did not set the branch up correctly
                    vim.keymap.set("n", "<leader>t", ":Git push -u origin ",
                        { buffer = bufnr, remap = false, desc = "Push origin <branch>(Fugitive)" });
                end,
            })

            vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
            vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
        end
    },
    -- { "tpope/vim-rhubarb", cmd = "GBrowse" },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require('gitsigns').setup {
                signs = {
                    add = { text = '+' },
                    change = { text = '~' },
                    delete = { text = '_' },
                    topdelete = { text = '‾' },
                    changedelete = { text = '~' },
                },
                current_line_blame = false,
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    map('n', ']c', function()
                        if vim.wo.diff then return ']c' end
                        vim.schedule(function() gs.next_hunk() end)
                        return '<Ignore>'
                    end, { expr = true })

                    map('n', '[c', function()
                        if vim.wo.diff then return '[c' end
                        vim.schedule(function() gs.prev_hunk() end)
                        return '<Ignore>'
                    end, { expr = true })

                    -- Actions
                    map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
                    map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
                    map('n', '<leader>hS', gs.stage_buffer)
                    map('n', '<leader>ha', gs.stage_hunk)
                    map('n', '<leader>hu', gs.undo_stage_hunk)
                    map('n', '<leader>hR', gs.reset_buffer)
                    map('n', '<leader>hp', gs.preview_hunk)
                    map('n', '<leader>hb', function() gs.blame_line { full = true } end)
                    map('n', '<leader>tb', gs.toggle_current_line_blame)
                    map('n', '<leader>hd', gs.diffthis)
                    map('n', '<leader>hD', function() gs.diffthis('~') end)

                    -- Text object
                    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
                end
            }
        end,
    },
    { "sindrets/diffview.nvim", cmd = "DiffviewOpen" },
    {
        "ThePrimeagen/harpoon",
        keys = {
            { "<leader>a", function() require("harpoon.mark").add_file() end,        desc = "Add file (Harpoon)" },
            { "<C-e>",     function() require("harpoon.ui").toggle_quick_menu() end, desc = "Menu (Harpoon)" },
            { "<leader>1", function() require("harpoon.ui").nav_file(1) end,         desc = "Harpoon File 1" },
            { "<leader>2", function() require("harpoon.ui").nav_file(2) end,         desc = "Harpoon File 2" },
            { "<leader>3", function() require("harpoon.ui").nav_file(3) end,         desc = "Harpoon File 3" },
            { "<leader>4", function() require("harpoon.ui").nav_file(4) end,         desc = "Harpoon File 4" },
            { "<leader>5", function() require("harpoon.ui").nav_file(5) end,         desc = "Harpoon File 5" },
        },
    },
    {
        "mbbill/undotree",
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undo-Tree" },
        }
    },
    {
        "folke/zen-mode.nvim",
        keys = {
            {
                "<leader>zz",
                function()
                    require("zen-mode").setup {
                        window = {
                            width = 150,
                            options = {}
                        },
                    }
                    require("zen-mode").toggle()
                    vim.wo.wrap = false
                    vim.wo.number = true
                    vim.wo.rnu = true
                end,
                desc = "Zen toggle"
            },
            {
                "<leader>zZ",
                function()
                    require("zen-mode").setup {
                        window = {
                            width = 150,
                            options = {}
                        },
                    }
                    require("zen-mode").toggle()
                    vim.wo.wrap = false
                    vim.wo.number = false
                    vim.wo.rnu = false
                    vim.opt.colorcolumn = "0"
                end,
                desc = "Zen full toggle"
            },
        },
    },
    {
        "numToStr/Comment.nvim",
        keys = { "gc", "gcc" },
        config = function()
            require("Comment").setup()
            local ft = require('Comment.ft')
            ft.set('asm', { ';%s', ';%s' })
        end,
    },
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup({
                signs = false,
            })
        end,
    },
}
