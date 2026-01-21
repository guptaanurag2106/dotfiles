local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local group = augroup("anurag_autocmds", { clear = true })

-- Highlight on yanking text
autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = augroup('HighlightYank', { clear = true }),
    callback = function()
        vim.hl.on_yank({ timeout = 150 })
    end,
})

-- Restore cursor to last known position when reopening a file
autocmd("BufReadPost", {
    group = group,
    pattern = "*",
    callback = function()
        local last_pos = vim.fn.line([['"]])
        local line_cnt = vim.fn.line("$")

        if last_pos > 1 and last_pos <= line_cnt then
            vim.cmd('normal! g`"')
        end
    end,
})

-- Open help in vertical split
autocmd("FileType", {
    group = group,
    pattern = "help",
    command = "wincmd L"
})

-- Resize splits to be equal on term resize
autocmd("VimResized", {
    group = group,
    command = "wincmd ="
})

-- Disable auto-commenting on new line
autocmd("FileType", {
    group = augroup("no_auto_comment", {}),
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- Remove trailing spaces in Python files on save
autocmd("BufWritePre", {
    group = group,
    pattern = "*.py",
    command = [[%s/\s\+$//e]],
})

-- Terminal tweaks
autocmd("TermOpen", {
    group = group,
    pattern = "*",
    callback = function()
        -- Auto-enter insert mode when opening a terminal
        vim.cmd("startinsert")
        
        -- Turn off line numbers and spell check for terminal
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.spell = false

        -- Terminal Navigation (similar to tmux navigator)
        local opts = { buffer = 0 }
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
        -- Escape terminal mode
        vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)
    end,
})

-- Custom Filetype Detection (Commented out examples)
-- vim.filetype.add({
--     extension = {
--         kcl = "kcl",
--         templ = "templ",
--     },
--     pattern = {
--         [=".*%.env.*"=] = "sh",
--         [=".*ignore"=] = "gitignore",
--     },
-- })

vim.opt.grepprg = "rg --vimgrep --no-heading"
-- After :grep, open quickfix automatically
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "grep",
  callback = function()
    vim.cmd("copen")
  end,
})

-- Make :grep silent by default (no output, no jump)
vim.cmd([[
  cnoreabbrev <expr> grep
    \ (getcmdtype() == ':' && getcmdline() ==# 'grep')
    \ ? 'silent grep'
    \ : 'grep'
]])
