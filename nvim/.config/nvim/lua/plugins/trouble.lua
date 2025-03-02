return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'folke/todo-comments.nvim' },
  opts = {
    focus = true,
  },
  cmd = 'Trouble',
  keys = {
    { '<leader>zw', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Open trouble [W]orkspace diagnostics' },
    { '<leader>zd', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Open trouble [D]ocument diagnostics' },
    { '<leader>zq', '<cmd>Trouble quickfix toggle<CR>', desc = 'Open trouble [Q]uickfix list' },
    { '<leader>zl', '<cmd>Trouble loclist toggle<CR>', desc = 'Open trouble [L]ocation list' },
    { '<leader>zt', '<cmd>Trouble todo toggle<CR>', desc = 'Open [T]odos in trouble' },
  },
}
