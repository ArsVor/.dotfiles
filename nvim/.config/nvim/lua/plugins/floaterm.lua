return {
  'voldikss/vim-floaterm',
  config = function()
    local function is_floaterm_open()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local buf_name = vim.api.nvim_buf_get_name(buf)

        if buf_name:match 'term://' then
          return true
        end
      end
      return false
    end

    vim.keymap.set('n', '<leader>zz', function()
      local name = 'floaterm1'
      if is_floaterm_open() then
        vim.cmd('FloatermToggle ' .. name)
      else
        vim.cmd('FloatermNew --height=0.7 --width=0.8 --wintype=float --name=' .. name .. ' --position=center --autoclose=2')
      end
    end, { desc = "Toggle FloatTerm, Open if don't exist" })
    vim.keymap.set('t', '<leader>zz', '<cmd>:FloatermToggle<CR>', { desc = 'Toggle FloatTerm' })
  end,
}
