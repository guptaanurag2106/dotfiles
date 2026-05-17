return {
    {
        "thimc/gruber-darker.nvim",
        config = function()
            require("gruber-darker").setup({
                bold = false,
                transparent = true
            })
            Colours("gruber-darker")
        end
    },
}
