local custom = require 'plugins.custom.functions'

vim.api.nvim_create_user_command('LspInfo', ':checkhealth vim.lsp', {})
vim.api.nvim_create_user_command('QQ', 'q!', {})
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('WQ', 'wq', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('Minimize', function()
  custom.minimize_current_split()
end, {})

vim.api.nvim_create_user_command('PyrightIgnore', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local linenr = cursor[1] - 1

  local diagnostics = vim.diagnostic.get(bufnr, { lnum = linenr })
  if #diagnostics == 0 then
    print 'Diagnostic not found.'
    return
  end

  -- Збираємо всі коди проблем
  local codes = {}
  for _, diag in ipairs(diagnostics) do
    if diag.code then
      table.insert(codes, diag.code)
    end
  end

  if #codes == 0 then
    print 'Can not suppress.'
    return
  end

  local code_str = '# pyright: ignore[' .. table.concat(codes, ',') .. ']'

  -- Вставляємо в кінці рядка
  local line = vim.api.nvim_buf_get_lines(bufnr, linenr, linenr + 1, false)[1]
  if not line:find 'pyright: ignore' then
    vim.api.nvim_buf_set_lines(bufnr, linenr, linenr + 1, false, { line .. '  ' .. code_str })
  end
end, {})
