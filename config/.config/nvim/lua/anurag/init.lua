require("anurag.remap")
require("anurag.packer")
require("anurag.set")

-- Highlight on yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('HighlightYank', { clear = true }),
    callback = function()
        vim.highlight.on_yank({ timeout = 150 })
    end,
})

P = function(v)
    print(vim.inspect(v))
    return v
end

RELOAD = function(...)
    return require("plenary.reload").reload_module(...)
end

R = function(name)
    RELOAD(name)
    return require(name)
end

-- Open a new scratch buffer
function OpenScratchBuffer()
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(bufnr)
    vim.api.nvim_command('setlocal buftype=nofile bufhidden=hide noswapfile nonumber norelativenumber')
    vim.api.nvim_command('au BufUnload <buffer> bd!')
end

-- Save the scratch buffer to a file
function SaveScratchBuffer()
    local bufnr = vim.api.nvim_get_current_buf()
    local file_path = vim.fn.expand('%:p')
    if file_path == '' then
        file_path = vim.fn.input('Save scratch buffer as: ', vim.fn.expand('%:p:h') .. '/', 'file')
    end
    if file_path ~= '' then
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        vim.fn.writefile(lines, file_path)
        print()
        print('Scratch buffer saved as: ' .. file_path)
    end
end

-- Create a command to open a new scratch buffer
vim.api.nvim_create_user_command('Scratch', OpenScratchBuffer, {})

-- Create a keymap to save the scratch buffer
vim.api.nvim_set_keymap('n', '<leader>sb', ':lua SaveScratchBuffer()<CR>', { noremap = true, silent = true })
