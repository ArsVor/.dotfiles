return {
  'HallerPatrick/py_lsp.nvim',
  -- Support for versioning
  -- tag = "v0.0.1"
  --
  config = function()
    require('py_lsp').setup {
      -- host_python = vim.fn.systemlist('which python')[1],
      -- default_venv_name = '.venv',
      language_server = 'pyright',
      source_strategies = { 'poetry', 'default', 'system' },
      vim.keymap.set('n', '<leader>vp', '<cmd> PyLspFindVenvs <CR>', { noremap = true, silent = true, desc = '[V]envs [P]ython list' }),
    }
  end,
}
