local minimize = require 'plugins.custom.minimize'

vim.api.nvim_create_user_command('QQ', 'q!', {})
vim.api.nvim_create_user_command('Minimize', function()
  minimize.minimize_current_split()
end, {})
vim.api.nvim_create_user_command('AutoSelectSystemVenv', function()
  vim.cmd 'PyLspFindVenvs' -- Виконуємо команду PyLspFindVenvs
  vim.defer_fn(function()
    vim.fn.feedkeys('system', 't') -- Вводимо "system" у fzf
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 't', false) -- Натискаємо Return
  end, 500) -- Чекаємо 500 мс, щоб дати fzf час відобразити список
end, {})
