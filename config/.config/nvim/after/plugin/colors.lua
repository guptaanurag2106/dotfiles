function Colours(colour)
    colour = colour or "vscode"
    vim.cmd.colorscheme(colour)

    local highlights = {
        "Normal",
        "LineNr",
        "Folded",
        "NonText",
        "SpecialKey",
        "VertSplit",
        "DiffviewVertSplit",
        "NormalNC",
        "SignColumn",
        "EndOfBuffer",
        "TablineFill",
        "TablineSel"
    }
    --
    for _, name in pairs(highlights) do
        vim.api.nvim_set_hl(0, name, { bg = "#000000" })
    end
end

Colours("vscode")
