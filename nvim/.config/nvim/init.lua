require 'core.options'
require 'core.keymaps'
require 'core.command'
require 'core.autocmd'

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.diagnostic.config {
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true, -- <-- головне
}

-- vim.lsp.set_log_level 'debug'

require('lazy').setup {
  -- *** --
  -- Color Themes uncomment to apply, and restart nvim. (one only)
  require 'plugins.themes.everforest',
  -- require 'plugins.themes.catppuccin',
  -- require 'plugins.themes.nord',
  -- *** --
  -- Modules
  require 'plugins.alpha',
  -- require 'plugins.autocompletion',
  require 'plugins.auto-save',
  require 'plugins.blink-cmp',
  -- require 'plugins.bufferline',
  require 'plugins.comment',
  require 'plugins.debug',
  require 'plugins.floaterm',
  require 'plugins.gitsigns',
  require 'plugins.harpoon',
  require 'plugins.indent-blunkline',
  require 'plugins.lazygit',
  require 'plugins.lsp',
  require 'plugins.lualine',
  require 'plugins.mini',
  require 'plugins.misc',
  -- require 'plugins.neotree',
  require 'plugins.noice',
  require 'plugins.none-ls',
  require 'plugins.oil',
  require 'plugins.py_lsp',
  require 'plugins.render-markdown',
  require 'plugins.rest',
  require 'plugins.rust-tools',
  require 'plugins.spectre',
  require 'plugins.substitute',
  require 'plugins.telescope',
  require 'plugins.treesitter',
  require 'plugins.treesitter-textobject',
  require 'plugins.trouble',
  require 'plugins.ufo',
  require 'plugins.vim-maximizer',
  require 'plugins.which-key',
}
