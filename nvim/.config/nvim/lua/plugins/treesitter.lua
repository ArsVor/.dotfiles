require('nvim-treesitter').setup({
  ensure_installed = {
    'lua',
    'python',
    'rust',
    'javascript',
    'html',
    'css',
    'scss',
  },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },
})

require('nvim-treesitter.install').update({ with_sync = true })
