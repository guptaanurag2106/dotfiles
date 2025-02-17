local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Find file (Telescope)" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search Help (Telescope)" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search Keymaps (Telescope)" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Search current Word (Telescope)" })
-- vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Search by Grep (Telescope)" })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find existing buffers (Telescope)" })
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find,
    { desc = "Fuzzily search in current buffer (Telescope)" })
-- vim.keymap.set("n", "<leader>ss", function()
--     builtin.grep_string({ search = vim.fn.input("Grep >") }); -- need ripgrep for this
-- end, { desc = "Grep string (Telescope)" })
vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Find Document Symbols (Telescope)" })
vim.keymap.set("n", "<leader>fws", builtin.lsp_workspace_symbols, { desc = "Find Workspace Symbols (Telescope)" })
vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Search Git Commits (Telescope)" })


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

vim.keymap.set("n", "<leader>sg", live_adv_grep, { desc = "Advanced Grep (Telescope)" })
