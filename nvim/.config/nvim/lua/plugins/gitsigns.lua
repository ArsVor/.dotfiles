-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
  'lewis6991/gitsigns.nvim',
  opts = {
    -- signs = {
    --   add = { text = '+' },
    --   change = { text = '~' },
    --   delete = { text = '_' },
    --   topdelete = { text = '‾' },
    --   changedelete = { text = '~' },
    -- },
    -- signs_staged = {
    --   add = { text = '+' },
    --   change = { text = '~' },
    --   delete = { text = '_' },
    --   topdelete = { text = '‾' },
    --   changedelete = { text = '~' },
    -- },
  },
  config = function()
    require('gitsigns').setup()
    vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', { desc = 'Open [G]it diff line [P]review' })
    vim.keymap.set('n', '<leader>gd', function()
      require('gitsigns').diffthis(nil, { split = 'rightbelow', vertical = true })
    end, { desc = 'Open [G]it [D]iff in split window' })
    vim.keymap.set('n', '<leader>gs', ':Gitsigns show<CR>', { desc = '[G]it [S]how revision {base} of the current file' })
    vim.keymap.set('n', '<leader>gb', ':Gitsigns blame<CR>', { desc = 'Open [G]it [B]lame' })
    vim.keymap.set('n', '<leader>gi', ':Gitsigns toggle_current_line_blame<CR>', { desc = 'Toggle [G]it current line blame [I]nfo' })
  end,
}
