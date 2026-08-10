return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        keys = {
            {
                "<leader>sf",
                function()
                    require("telescope.builtin").find_files(
                        {
                            hidden = true,
                            no_ignore = true,
                            file_ignore_patterns = {
                                "node_modules",
                                ".ruff_cache",
                                ".nox",
                                ".git/",
                            }
                        })
                end,
                desc = "Find file (Telescope)"
            },
            { "<leader>sh",       function() require("telescope.builtin").help_tags() end,                 desc = "Search Help (Telescope)" },
            { "<leader>sk",       function() require("telescope.builtin").keymaps() end,                   desc = "Search Keymaps (Telescope)" },
            { "<leader>sw",       function() require("telescope.builtin").grep_string() end,               desc = "Search current Word (Telescope)" },
            { "<leader><leader>", function() require("telescope.builtin").buffers() end,                   desc = "Find existing buffers (Telescope)" },
            { "<C-p>",            function() require("telescope.builtin").git_files() end,                 desc = "Find git files (Telescope)" },
            { "<leader>/",        function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Fuzzily search in current buffer (Telescope)" },
            { "<leader>fs",       function() require("telescope.builtin").lsp_document_symbols() end,      desc = "Find Document Symbols (Telescope)" },
            { "<leader>fws",      function() require("telescope.builtin").lsp_workspace_symbols() end,     desc = "Find Workspace Symbols (Telescope)" },
            { "<leader>gc",       function() require("telescope.builtin").git_commits() end,               desc = "Search Git Commits (Telescope)" },
            {
                "<leader>sg",
                function()
                    local pickers = require("telescope.pickers")
                    local finders = require("telescope.finders")
                    local make_entry = require("telescope.make_entry")
                    local conf = require("telescope.config").values

                    local live_adv_grep = function(opts)
                        opts = opts or {}
                        opts.cwd = opts.cwd or vim.uv.cwd()

                        local finder = finders.new_async_job {
                            command_generator = function(prompt)
                                if not prompt or prompt == "" then
                                    return nil
                                end

                                local pieces = vim.split(prompt, "  ")
                                local args = { "rg" }
                                if pieces[1] then
                                    table.insert(args, "-e")
                                    table.insert(args, pieces[1])
                                end
                                if pieces[2] then
                                    table.insert(args, "-g")
                                    table.insert(args, pieces[2])
                                end

                                ---@diagnostic disable-next-line: deprecated
                                return vim.tbl_flatten({
                                    args,
                                    { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
                                })
                            end,
                            entry_maker = make_entry.gen_from_vimgrep(opts),
                            cwd = opts.cwd,
                        }

                        pickers.new(opts, {
                            debounce = 100,
                            prompt_title = "Advanced Grep",
                            finder = finder,
                            previewer = conf.grep_previewer(opts),
                            sorter = require("telescope.sorters").empty()
                        }):find()
                    end
                    live_adv_grep()
                end,
                desc = "Advanced Grep (Telescope)"
            },
        },
        config = function()
            local actions = require("telescope.actions")
            require("telescope").setup({
                ---------------------------------------------------------------------
                -- Defaults apply to *all* pickers ----------------------------------
                ---------------------------------------------------------------------
                defaults = {
                    prompt_prefix = "  ",
                    mappings = { i = { ["<Esc>"] = actions.close } },
                    file_ignore_patterns = {
                        "^%.git/", -- keep .git ignored
                        "^%.idea/",
                        "^%.vscode/",
                        "^%.venv/",
                        "^node_modules/",
                        "^%.cache/",
                        "%.DS_Store$",
                    },
                },
                pickers = {
                    -- :Telescope find_files
                    find_files = {
                        hidden = true,     -- include dot‑files / dot‑dirs
                        follow = true,     -- follow symlinks
                        no_ignore = false, -- still respect .gitignore & friends
                        find_command = {
                            "rg",
                            "--files",
                            "--hidden",
                        },
                    },
                },
            })
            require("telescope").load_extension("fzf")
        end,
    },
}
