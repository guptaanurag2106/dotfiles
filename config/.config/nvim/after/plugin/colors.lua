function Colors(color)
    -- color = color or "gruvbox"
    -- color = color or "tokyonight-storm"
    color = color or "onedark"
    vim.cmd.colorscheme(color)
    if color == "gruvbox" then
        require("gruvbox").setup({
            italic = {
                strings = false,
                emphasis = false,
                comments = true,
                operators = false,
                folds = true,
            }
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

Colors()
