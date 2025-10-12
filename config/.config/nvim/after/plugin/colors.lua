function Colours(colour)
    colour = colour or "onedark"
    vim.cmd.colorscheme(colour)

    if colour == "gruvbox" then
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
    --
    for _, name in pairs(highlights) do
        vim.api.nvim_set_hl(0, name, { bg = "none" })
    end
end

Colours("vscode")
