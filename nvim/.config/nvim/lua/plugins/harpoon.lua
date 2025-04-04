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

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<leader>.', function()
      harpoon:list():prev()
    end, { desc = 'Go to prev. harpoon buffer' })
    vim.keymap.set('n', '<leader>;', function()
      harpoon:list():next()
    end, { desc = 'Go to next harpoon buffer' })
  end,
}
