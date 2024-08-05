vim.keymap.set("n", "<leader>gs", vim.cmd.Git);

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
            vim.cmd.Git({ 'pull', '--rebase' })
        end, { buffer = bufnr, remap = false, desc = "Pull rebase (Fugitive)" })

        -- NOTE: It allows me to easily set the branch i am pushing and any tracking
        -- needed if i did not set the branch up correctly
        vim.keymap.set("n", "<leader>t", ":Git push -u origin ",
            { buffer = bufnr, remap = false, desc = "Push origin <branch>(Fugitive)" });
    end,
})

vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
