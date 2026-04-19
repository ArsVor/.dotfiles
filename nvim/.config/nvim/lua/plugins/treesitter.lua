return {
  'nvim-treesitter/nvim-treesitter',
  -- event = { 'BufReadPre', 'BufNewFile' },
  branch = 'main',
  main = "nvim-treesitter",
  event = 'VeryLazy',
  lazy = false,
  build = ':TSUpdate',
  dependencies = {
    'windwp/nvim-ts-autotag',
  },
  config = function()
    local treesitter = require 'nvim-treesitter'

    treesitter.setup {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = {
        enable = true,
        disable = { 'ruby' },
      },
      ensure_installed = {
        'lua',
        'python',
        'javascript',
        'typescript',
        'vimdoc',
        'vim',
        'regex',
        'terraform',
        'sql',
        'dockerfile',
        'toml',
        'json',
        'java',
        'groovy',
        'go',
        'gitignore',
        'graphql',
        'yaml',
        'make',
        'cmake',
        'markdown',
        'markdown_inline',
        'bash',
        'fish',
        'tsx',
        'css',
        'html',
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          node_decremental = '<bs>',
        },
      },
    }

    require('nvim-ts-autotag').setup {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
      per_filetype = {
        html = {
          enable_close = true,
        },
      },
    }

    vim.keymap.set('n', '<leader>ci', '<cmd>InspectTree<CR>', { noremap = true, silent = true, desc = '[C]ode [I]nspect tree' })
  end,
}
