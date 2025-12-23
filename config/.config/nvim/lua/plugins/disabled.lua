return {
  { "RRethy/vim-illuminate", enabled = false },
  { 'rhysd/git-messenger.vim', cmd = 'GitMessenger', enabled = false },
  {
    "crispgm/nvim-go",
    dependencies = {
      "leoluz/nvim-dap-go",
    },
    config = function()
      require("go").setup({})
    end,
    enabled = false
  },
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({})
    end,
    enabled = false
  },
  { "folke/which-key.nvim", enabled = false },
  {
    "hedyhli/outline.nvim",
    config = function()
      require("outline").setup({})
    end,
    enabled = false
  },
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.ai").setup { n_lines = 500 }
      require("mini.surround").setup()
      local statusline = require "mini.statusline"
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return "%2l:%-2v"
      end
    end,
    enabled = false
  }
}
