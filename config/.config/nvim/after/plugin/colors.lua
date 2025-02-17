function Colors(color)
    -- color = color or "gruvbox"
    color = color or "onedark"
    vim.cmd.colorscheme(color)
    if color == "gruvbox" then
        require("gruvbox").setup({
            contrast = "hard"
            -- italic = {
            --     strings = false,
            --     emphasis = false,
            --     comments = true,
            --     operators = false,
            --     folds = true,
            -- }
        })
    end

    local highlights = {
        "Normal",
        "LineNr",
        "Folded",
        "NonText",
        "SpecialKey",
        "VertSplit",
        "SignColumn",
        "EndOfBuffer",
        "TablineFill"
    }

    for _, name in pairs(highlights) do
        vim.api.nvim_set_hl(0, name, { bg = "none" })
    end
end

vim.g.gruvbox_contrast_dark = 'hard'
vim.g.gruvbox_contrast_light = 'hard'

Colors()
