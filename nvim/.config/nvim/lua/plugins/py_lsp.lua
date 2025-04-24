return {
  'HallerPatrick/py_lsp.nvim',
  -- Support for versioning
  -- tag = "v0.0.1"

  config = function()
    -- Функція для перевірки, чи існує venv у вказаному каталозі
    local function find_venv()
      local cwd = vim.fn.getcwd()
      local parent = vim.fn.fnamemodify(cwd, ':h') -- Отримуємо один рівень вище
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return 'venv'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return '.venv'
      elseif vim.fn.executable(parent .. '/venv/bin/python') == 1 then
        return '../venv'
      elseif vim.fn.executable(parent .. '/.venv/bin/python') == 1 then
        return '../.venv'
      end
      return cwd
    end

    local venv_path = find_venv()

    -- Якщо знайдено, передаємо його у py_lsp
    if venv_path then
      require('py_lsp').setup {
        host_python = vim.fn.systemlist('which python')[1],
        default_venv_name = venv_path,
        language_server = 'pyright',
        source_strategies = { 'poetry', 'default', 'system' },
        vim.keymap.set('n', '<leader>vp', '<cmd> PyLspFindVenvs <CR>', { noremap = true, silent = true, desc = '[V]envs [P]ython list' }),
      }
    end
  end,
}
