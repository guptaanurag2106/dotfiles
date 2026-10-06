require("anurag.remap")
require("anurag.set")
require("anurag.autocmds")

-- Open a new scratch buffer
function OpenScratchBuffer()
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(bufnr)
    vim.api.nvim_command('setlocal buftype=nofile bufhidden=hide noswapfile relativenumber')
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

vim.api.nvim_create_user_command('Scratch', OpenScratchBuffer, {})
vim.keymap.set('n', '<leader>sb', SaveScratchBuffer, { noremap = true, silent = true, desc = "Save scratch buffer" })

function Colours(colour)
    vim.cmd.colorscheme(colour)

    local highlights = {
        "Normal", -- Normal background
        "NonText",
        "SpecialKey",
        "VertSplit",
        "DiffviewVertSplit",
        "NormalNC", -- Normal Non current (split)
        "SignColumn",
        "EndOfBuffer",
        "TablineFill",
        "TablineSel",
        "TelescopeNormal",
        "TelescopeBorder",
        "TelescopePromptNormal",
        "TelescopePromptBorder",
        "TelescopeResultsNormal",
        "TelescopeResultsBorder",
        "TelescopePreviewNormal",
        "TelescopePreviewBorder",
    }
    --
    for _, name in pairs(highlights) do
        vim.api.nvim_set_hl(0, name, { bg = "none" })
    end
end
