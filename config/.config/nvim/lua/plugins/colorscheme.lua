return {
    { 'Mofiqul/vscode.nvim', lazy = true, name = "vscode" },
    {
        'sainnhe/everforest',
        lazy = false,
        priority = 1000,
        config = function()
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
                vim.g.everforest_background = 'hard'
            end

            Colours("everforest")
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({})
        end,
    },
}
