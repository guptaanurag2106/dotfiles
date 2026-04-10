return {
    {
        'p00f/alabaster.nvim',
        lazy = false,
        config = function()
            Colours("alabaster")
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
