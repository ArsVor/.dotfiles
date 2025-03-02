return {
  'HallerPatrick/py_lsp.nvim',
  -- Support for versioning
  -- tag = "v0.0.1"

  config = function()
    local function is_virtualenv_available()
      local cwd = vim.fn.getcwd()
      return vim.fn.executable(cwd .. '/venv/bin/python') == 1 or vim.fn.executable(cwd .. '/.venv/bin/python') == 1
    end
    if is_virtualenv_available() then
      require('py_lsp').setup {
        -- This is optional, but allows to create virtual envs from nvim
        host_python = '/home/ars/.pyenv/shims/python',
        default_venv_name = 'venv', -- For local venv
        language_server = 'pyright',
        source_strategies = { 'poetry', 'default', 'system' },
      }
    end
  end,
}
