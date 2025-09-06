return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup {
      settings = {
        -- Sets the marks upon calling `toggle` on the ui, instead of require `:w`
        save_on_toggle = true,
        sync_on_ui_close = false,
        key = function()
          return vim.loop.cwd()
        end,
      },
    }

    vim.keymap.set('n', '<leader>hh', function()
      harpoon:list():add()
    end, { desc = 'add current buffer to [H]arpoon' })
    vim.keymap.set('n', '<leader>hm', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Toggle [H]arpoon [M]enu' })

    vim.keymap.set('n', '<leader>1', function()
      harpoon:list():select(1)
    end, { desc = 'Select [1]-st harpoon buffer' })
    vim.keymap.set('n', '<leader>2', function()
      harpoon:list():select(2)
    end, { desc = 'Select [2]-nd harpoon buffer' })
    vim.keymap.set('n', '<leader>3', function()
      harpoon:list():select(3)
    end, { desc = 'Select [3]-rd harpoon buffer' })
    vim.keymap.set('n', '<leader>4', function()
      harpoon:list():select(4)
    end, { desc = 'Select [4]-th harpoon buffer' })
    vim.keymap.set('n', '<leader>5', function()
      harpoon:list():select(5)
    end, { desc = 'Select [5]-th harpoon buffer' })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<leader>.', function()
      local list = harpoon:list()
      local total = #list.items
      if total == 0 then
        return
      end

      local current_file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p')
      local idx = nil

      -- знайти індекс поточного файла у harpoon
      for i, item in ipairs(list.items) do
        if vim.fn.fnamemodify(item.value, ':p') == current_file then
          idx = i
          break
        end
      end

      if not idx then
        list:select(total)
        return
      end

      local prev_idx = idx - 1
      if prev_idx < 1 then
        prev_idx = total
      end

      list:select(prev_idx)
    end, { desc = 'Go to prev. harpoon buffer' })
    vim.keymap.set('n', '<leader>;', function()
      local list = harpoon:list()
      local total = #list.items
      if total == 0 then
        return
      end

      local current_file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p')
      local idx = nil

      for i, item in ipairs(list.items) do
        if vim.fn.fnamemodify(item.value, ':p') == current_file then
          idx = i
          break
        end
      end

      if not idx then
        list:select(1)
        return
      end

      local next_idx = idx + 1
      if next_idx > total then
        next_idx = 1
      end

      list:select(next_idx)
    end, { desc = 'Go to next harpoon buffer' })
  end,
}
