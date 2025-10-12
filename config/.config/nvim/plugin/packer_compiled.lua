-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/tanz/.cache/nvim/packer_hererocks/2.1.1753364724/share/lua/5.1/?.lua;/home/tanz/.cache/nvim/packer_hererocks/2.1.1753364724/share/lua/5.1/?/init.lua;/home/tanz/.cache/nvim/packer_hererocks/2.1.1753364724/lib/luarocks/rocks-5.1/?.lua;/home/tanz/.cache/nvim/packer_hererocks/2.1.1753364724/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/tanz/.cache/nvim/packer_hererocks/2.1.1753364724/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0" },
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  LuaSnip = {
    config = { "\27LJ\2\n \0\0\2\1\1\0\4-\0\0\0009\0\0\0B\0\1\1K\0\1\0\0À\vexpand\"\0\0\3\1\1\0\5-\0\0\0009\0\0\0)\2\1\0B\0\2\1K\0\1\0\0À\tjump\"\0\0\3\1\1\0\5-\0\0\0009\0\0\0)\2ÿÿB\0\2\1K\0\1\0\0À\tjumpê\2\1\0\a\0\24\0*6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\1\4\0'\3\5\0005\4\6\0B\1\3\0019\1\4\0'\3\a\0005\4\b\0B\1\3\0016\1\t\0009\1\n\0019\1\v\0015\3\f\0'\4\r\0003\5\14\0005\6\15\0B\1\5\0016\1\t\0009\1\n\0019\1\v\0015\3\16\0'\4\17\0003\5\18\0005\6\19\0B\1\5\0016\1\t\0009\1\n\0019\1\v\0015\3\20\0'\4\21\0003\5\22\0005\6\23\0B\1\5\0012\0\0€K\0\1\0\1\0\1\vsilent\2\0\n<C-J>\1\3\0\0\6i\6s\1\0\1\vsilent\2\0\n<C-K>\1\3\0\0\6i\6s\1\0\1\vsilent\2\0\n<C-H>\1\2\0\0\6i\bset\vkeymap\bvim\1\2\0\0\vcppdoc\bcpp\1\2\0\0\tcdoc\6c\20filetype_extend\fluasnip\14lazy_load luasnip.loaders.from_vscode\frequire\0" },
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lsp-signature-help"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-signature-help",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["diffview.nvim"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
  },
  ["fidget.nvim"] = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vfidget\frequire\0" },
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/fidget.nvim",
    url = "https://github.com/j-hui/fidget.nvim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  harpoon = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/harpoon",
    url = "https://github.com/theprimeagen/harpoon"
  },
  ["lazydev.nvim"] = {
    config = { "\27LJ\2\n™\1\0\0\6\0\b\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0004\3\3\0005\4\3\0005\5\4\0=\5\5\4>\4\1\3=\3\a\2B\0\2\1K\0\1\0\flibrary\1\0\1\flibrary\0\nwords\1\2\0\0\fvim%.uv\1\0\2\tpath\23${3rd}/luv/library\nwords\0\nsetup\flazydev\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/opt/lazydev.nvim",
    url = "https://github.com/folke/lazydev.nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\flualine\frequire\0" },
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["mason-nvim-dap.nvim"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/mason-nvim-dap.nvim",
    url = "https://github.com/jay-babu/mason-nvim-dap.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-ui"] = {
    config = { "\27LJ\2\n\30\0\0\2\1\1\0\4-\0\0\0009\0\0\0B\0\1\1K\0\1\0\1À\topen\31\0\0\2\1\1\0\4-\0\0\0009\0\0\0B\0\1\1K\0\1\0\1À\nclose\31\0\0\2\1\1\0\4-\0\0\0009\0\0\0B\0\1\1K\0\1\0\1À\ncloseÚ\1\1\0\4\0\14\0\0256\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\2\3\1B\2\1\0019\2\4\0009\2\5\0029\2\6\0023\3\b\0=\3\a\0029\2\4\0009\2\t\0029\2\n\0023\3\v\0=\3\a\0029\2\4\0009\2\t\0029\2\f\0023\3\r\0=\3\a\0022\0\0€K\0\1\0\0\17event_exited\0\21event_terminated\vbefore\0\17dapui_config\22event_initialized\nafter\14listeners\nsetup\ndapui\bdap\frequire\0" },
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/nvim-dap-ui",
    url = "https://github.com/rcarriga/nvim-dap-ui"
  },
  ["nvim-dap-virtual-text"] = {
    config = { "\27LJ\2\nG\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\26nvim-dap-virtual-text\frequire\0" },
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/nvim-dap-virtual-text",
    url = "https://github.com/theHamsta/nvim-dap-virtual-text"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-nio"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/nvim-nio",
    url = "https://github.com/nvim-neotest/nvim-nio"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    config = { "\27LJ\2\nÜ\1\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\v\24multiline_threshold\3\20\tmode\vcursor\22min_window_height\3\0\14max_lines\3\0\16multiwindow\1\venable\2\17line_numbers\2\14on_attach\0\vzindex\3\20\14separator\0\15trim_scope\nouter\nsetup\23treesitter-context\frequire\0" },
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/nvim-treesitter-context",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-context"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/nvim-tree/nvim-web-devicons"
  },
  ["oil.nvim"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/oil.nvim",
    url = "https://github.com/stevearc/oil.nvim"
  },
  ["onedark.nvim"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/onedark.nvim",
    url = "https://github.com/navarasu/onedark.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["run.nvim"] = {
    config = { "\27LJ\2\nJ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\21ask_confirmation\1\nsetup\brun\frequire\0" },
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/run.nvim",
    url = "/home/tanz/Documents/dev/projects/run.nvim/"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bfzf\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\2\nI\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\nsigns\1\nsetup\18todo-comments\frequire\0" },
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/todo-comments.nvim",
    url = "https://github.com/folke/todo-comments.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ultisnips = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/ultisnips",
    url = "https://github.com/sirver/ultisnips"
  },
  undotree = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-rhubarb"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/vim-rhubarb",
    url = "https://github.com/tpope/vim-rhubarb"
  },
  ["vscode.nvim"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/vscode.nvim",
    url = "https://github.com/Mofiqul/vscode.nvim"
  },
  ["zen-mode.nvim"] = {
    loaded = true,
    path = "/home/tanz/.local/share/nvim/site/pack/packer/start/zen-mode.nvim",
    url = "https://github.com/folke/zen-mode.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
try_loadstring("\27LJ\2\nI\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\nsigns\1\nsetup\18todo-comments\frequire\0", "config", "todo-comments.nvim")
time([[Config for todo-comments.nvim]], false)
-- Config for: nvim-dap-virtual-text
time([[Config for nvim-dap-virtual-text]], true)
try_loadstring("\27LJ\2\nG\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\26nvim-dap-virtual-text\frequire\0", "config", "nvim-dap-virtual-text")
time([[Config for nvim-dap-virtual-text]], false)
-- Config for: fidget.nvim
time([[Config for fidget.nvim]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vfidget\frequire\0", "config", "fidget.nvim")
time([[Config for fidget.nvim]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: LuaSnip
time([[Config for LuaSnip]], true)
try_loadstring("\27LJ\2\n \0\0\2\1\1\0\4-\0\0\0009\0\0\0B\0\1\1K\0\1\0\0À\vexpand\"\0\0\3\1\1\0\5-\0\0\0009\0\0\0)\2\1\0B\0\2\1K\0\1\0\0À\tjump\"\0\0\3\1\1\0\5-\0\0\0009\0\0\0)\2ÿÿB\0\2\1K\0\1\0\0À\tjumpê\2\1\0\a\0\24\0*6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\1\4\0'\3\5\0005\4\6\0B\1\3\0019\1\4\0'\3\a\0005\4\b\0B\1\3\0016\1\t\0009\1\n\0019\1\v\0015\3\f\0'\4\r\0003\5\14\0005\6\15\0B\1\5\0016\1\t\0009\1\n\0019\1\v\0015\3\16\0'\4\17\0003\5\18\0005\6\19\0B\1\5\0016\1\t\0009\1\n\0019\1\v\0015\3\20\0'\4\21\0003\5\22\0005\6\23\0B\1\5\0012\0\0€K\0\1\0\1\0\1\vsilent\2\0\n<C-J>\1\3\0\0\6i\6s\1\0\1\vsilent\2\0\n<C-K>\1\3\0\0\6i\6s\1\0\1\vsilent\2\0\n<C-H>\1\2\0\0\6i\bset\vkeymap\bvim\1\2\0\0\vcppdoc\bcpp\1\2\0\0\tcdoc\6c\20filetype_extend\fluasnip\14lazy_load luasnip.loaders.from_vscode\frequire\0", "config", "LuaSnip")
time([[Config for LuaSnip]], false)
-- Config for: run.nvim
time([[Config for run.nvim]], true)
try_loadstring("\27LJ\2\nJ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\21ask_confirmation\1\nsetup\brun\frequire\0", "config", "run.nvim")
time([[Config for run.nvim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\flualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bfzf\19load_extension\14telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: nvim-dap-ui
time([[Config for nvim-dap-ui]], true)
try_loadstring("\27LJ\2\n\30\0\0\2\1\1\0\4-\0\0\0009\0\0\0B\0\1\1K\0\1\0\1À\topen\31\0\0\2\1\1\0\4-\0\0\0009\0\0\0B\0\1\1K\0\1\0\1À\nclose\31\0\0\2\1\1\0\4-\0\0\0009\0\0\0B\0\1\1K\0\1\0\1À\ncloseÚ\1\1\0\4\0\14\0\0256\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\2\3\1B\2\1\0019\2\4\0009\2\5\0029\2\6\0023\3\b\0=\3\a\0029\2\4\0009\2\t\0029\2\n\0023\3\v\0=\3\a\0029\2\4\0009\2\t\0029\2\f\0023\3\r\0=\3\a\0022\0\0€K\0\1\0\0\17event_exited\0\21event_terminated\vbefore\0\17dapui_config\22event_initialized\nafter\14listeners\nsetup\ndapui\bdap\frequire\0", "config", "nvim-dap-ui")
time([[Config for nvim-dap-ui]], false)
-- Config for: nvim-treesitter-context
time([[Config for nvim-treesitter-context]], true)
try_loadstring("\27LJ\2\nÜ\1\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\v\24multiline_threshold\3\20\tmode\vcursor\22min_window_height\3\0\14max_lines\3\0\16multiwindow\1\venable\2\17line_numbers\2\14on_attach\0\vzindex\3\20\14separator\0\15trim_scope\nouter\nsetup\23treesitter-context\frequire\0", "config", "nvim-treesitter-context")
time([[Config for nvim-treesitter-context]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType lua ++once lua require("packer.load")({'lazydev.nvim'}, { ft = "lua" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
