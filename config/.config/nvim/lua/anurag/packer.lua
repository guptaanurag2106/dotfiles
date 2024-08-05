-- This file can be loaded by calling `lua require("plugins")` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("nvim-treesitter/playground")
	use("nvim-treesitter/nvim-treesitter-context")

	use("theprimeagen/harpoon")
	use("mbbill/undotree")
	use("tpope/vim-fugitive")
	use({
		"airblade/vim-gitgutter",
		-- config = function()
		--     require("vim-gitgutter").setup()
		-- end
	})
	-- Packer
	use("sindrets/diffview.nvim")

	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("neovim/nvim-lspconfig")
	use({
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff" },
					cpp = { "clang-format" },
					c = { "clang-format" },
					go = { "gofmt" },
					bash = { "beautysh" },
				},
			})
		end,
	})
	use({
		"crispgm/nvim-go",
		requires = {
			"leoluz/nvim-dap-go",
		},
		config = function()
			require("go").setup({})
		end,
	})

	use("mfussenegger/nvim-dap")
	use({
		"jay-babu/mason-nvim-dap.nvim",
		requires = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
	})
	use({
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			require("nvim-dap-virtual-text").setup({})
		end,
	})
	use({
		"rcarriga/nvim-dap-ui",
		requires = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	})

	-- Completion/Snippet
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-path")
	use("hrsh7th/nvim-cmp")
	use("saadparwaiz1/cmp_luasnip")
	use("hrsh7th/cmp-nvim-lsp-signature-help")
	use({
		"L3MON4D3/LuaSnip",
		run = "make install_jsregexp",
		requires = { { "rafamadriz/friendly-snippets", "sirver/ultisnips" } },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			local ls = require("luasnip")
			ls.filetype_extend("c", { "cdoc" })
			ls.filetype_extend("cpp", { "cppdoc" })
			vim.keymap.set({ "i" }, "<C-H>", function()
				ls.expand()
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-K>", function()
				ls.jump(1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-J>", function()
				ls.jump(-1)
			end, { silent = true })
		end,
	})

	use({
		"folke/neodev.nvim",
		config = function()
			require("neodev").setup({})
		end,
	})

	use({
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup({
				columns = { "icon" },
				keymaps = {
					["<C-h>"] = false,
					["<M-h>"] = "actions.select_split",
				},
				view_options = {
					show_hidden = true,
				},
			})
		end,
	})

	use("RRethy/vim-illuminate")

	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({})
		end,
	})

	-- Theme
	use("nvim-tree/nvim-web-devicons")
	use("ellisonleao/gruvbox.nvim")
	use("folke/tokyonight.nvim")
	use("navarasu/onedark.nvim")

	use({
		"stevearc/dressing.nvim",
		config = function()
			require("dressing").setup({})
		end,
	})
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
		config = function()
			require("lualine").setup({})
		end,
	})

	-- Comments
	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup({
				signs = false,
			})
		end,
	})
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})

	use({
		"folke/trouble.nvim",
		requires = "nvim-tree/nvim-web-devicons",
		config = function()
			require("trouble").setup({})
		end,
	})

	use({
		"hedyhli/outline.nvim",
		config = function()
			require("outline").setup({})
		end,
	})

	use("folke/zen-mode.nvim")

	-- use {
	--     "echasnovski/mini.nvim",
	--     config = function()
	--         require("mini.ai").setup { n_lines = 500 }
	--
	--         require("mini.surround").setup()
	--
	--         local statusline = require "mini.statusline"
	--
	--         -- set use_icons to true if you have a Nerd Font
	--         statusline.setup { use_icons = vim.g.have_nerd_font }
	--
	--         statusline.section_location = function()
	--             return "%2l:%-2v"
	--         end
	--     end,
	-- }
end)
