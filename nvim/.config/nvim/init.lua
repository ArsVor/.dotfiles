require 'core.options'
require 'core.keymaps'
require 'core.command'
require 'core.autocmd'

-- disable ruff diagnostic messages
vim.lsp.config('ruff', {
  handlers = {
    ["textDocument/publishDiagnostics"] = function() end,
    ["textDocument/diagnostic"] = function() end,
  },
})
local servers = { 'djlsp', 'emmet_ls', 'lua_ls', 'pyright', 'ruff', 'ts_ls' }

vim.pack.add({
  { src = 'https://github.com/neanias/everforest-nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/nvim-mini/mini.nvim' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = 'https://github.com/mrcjkb/rustaceanvim' },
  { src = 'https://github.com/benomahony/uv.nvim' },
  { src = 'https://github.com/folke/trouble.nvim' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/gbprod/substitute.nvim' },
  { src = 'https://github.com/declancm/maximize.nvim' },
  { src = 'https://github.com/cbochs/grapple.nvim' },
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },
  { src = 'https://github.com/christoomey/vim-tmux-navigator' },
  { src = 'https://github.com/olrtg/nvim-emmet' },
  { src = 'https://github.com/OXY2DEV/markview.nvim' },
  { src = 'https://github.com/MagicDuck/grug-far.nvim' },
  { src = 'https://github.com/goolord/alpha-nvim' },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/stevearc/quicker.nvim' },
  { src = 'https://github.com/mfussenegger/nvim-dap' },
  { src = 'https://github.com/rcarriga/nvim-dap-ui' },
  { src = 'https://github.com/nvim-neotest/nvim-nio' },
  { src = 'https://github.com/rachartier/tiny-inline-diagnostic.nvim' },
})

vim.cmd("packadd nvim.undotree")

require 'plugins.treesitter'
require 'plugins.indent-blankline'
require 'plugins.maximize'
require 'plugins.substitute'
require 'plugins.trouble'
require 'plugins.oil'
require 'plugins.grug-far'
require 'plugins.alpha'
require 'plugins.grapple'
require 'plugins.gitsigns'
require 'plugins.uv'
-- require 'plugins.mini.ai'
require 'plugins.mini.clue'
require 'plugins.mini.hipatterns'
require 'plugins.mini.icons'
require 'plugins.mini.pairs'
require 'plugins.mini.pick'
require 'plugins.mini.statusline'
require 'plugins.mini.surround'
require 'plugins.quickfix'
require("luasnip.loaders.from_vscode").lazy_load()

for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end

require 'plugins.blink'
require 'plugins.dap_ui'
require 'plugins.dap'
require 'plugins.inline_diagnostic'

vim.cmd.colorscheme('everforest')
