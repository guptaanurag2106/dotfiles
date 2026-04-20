return {
    {
        dir = "~/Documents/dev/projects/run.nvim/",
        dependencies = { { "nvim-lua/plenary.nvim" } },
        keys = {
            { "<leader>r",  ":RunFile<CR>", mode = { "n", "v" }, desc = "(Run.nvim) Async on selection" },
            { "<leader>ra", ":RunLast<CR>", mode = { "n", "v" }, desc = "(Run.nvim) Run Last" }
        },
        config = function()
            require("run").setup({
                ask_confirmation = false
            })
            require("run").set_current_browser("oil")
        end
    },
    {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        config = function()
            require('lazydev').setup {
                library = {
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            }
        end,
    },
}
