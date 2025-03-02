local minimize = require 'plugins.custom.minimize'

vim.api.nvim_create_user_command('Minimize', function()
  minimize.minimize_current_split()
end, {})
