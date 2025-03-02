return {
  'declancm/maximize.nvim',
  config = true,
  keys = {
    {
      '<leader>sz',
      '<cmd>Maximize<CR>',
      desc = '[S]plit maximi[Z]e toggle',
    },
    {
      '<leader>sm',
      function()
        require('maximize').maximize()
      end,
      desc = '[S]plit [M]aximize',
    },
    {
      '<leader>sr',
      function()
        require('maximize').restore()
      end,
      desc = '[S]plit [R]estore',
    },
  },
}
