-- https://github.com/okuuva/auto-save.nvim
-- This is a fork of original plugin `pocco81/auto-save.nvim` but the original
-- one was updated 2 years ago, and I was experiencing issues with autoform
-- undo/redo
--
-- Filename: ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/auto-save.lua
-- ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/auto-save.lua

return {
  {
    'okuuva/auto-save.nvim',
    keys = {
      { '<leader>as', '<cmd>ASToggle<CR>', desc = 'Toggle [A]uto-[S]ave' },
    },

    cmd = 'ASToggle', -- optional for lazy loading on command
    event = { 'InsertLeave', 'TextChanged' }, -- optional for lazy loading on trigger events
    opts = {
      enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)

      -- INFO: Do not worck!!!gvk
      -- execution_message = {
      --   enabled = true,
      --   message = function() -- message to print on save
      --     return ('AutoSave: saved at ' .. vim.fn.strftime '%H:%M:%S')
      --   end,
      --   dim = 0.18, -- dim the color of `message`
      --   cleaning_interval = 11250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
      -- },

      trigger_events = { -- See :h events
        immediate_save = { 'BufLeave', 'FocusLost' }, -- vim events that trigger an immediate save
        defer_save = { 'InsertLeave', 'TextChanged' }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
        cancel_deferred_save = { 'InsertEnter' }, -- vim events that cancel a pending deferred save
      },
      -- function that takes the buffer handle and determines whether to save the current buffer or not
      -- return true: if buffer is ok to be saved
      -- return false: if it's not ok to be saved
      -- if set to `nil` then no specific condition is applied
      condition = function(buf)
        local fn = vim.fn
        local is_harpoon = fn.match(fn.bufname(buf), 'harpoon') ~= -1
        return not is_harpoon -- не зберігати файли з Harpoon
      end, -- nil,
      write_all_buffers = false, -- write all buffers when the current one meets `condition`
      -- Do not execute autocmds when saving
      -- This is what fixed the issues with undo/redo that I had
      -- https://github.com/okuuva/auto-save.nvim/issues/55
      noautocmd = false,
      lockmarks = false, -- lock marks when saving, see `:h lockmarks` for more details
      -- delay after which a pending save is executed (default 1000)
      debounce_delay = 1000,
      -- log debug messages to 'auto-save.log' file in neovim cache directory, set to `true` to enable
      debug = false,
      -- vim.api.nvim_create_autocmd('User', {
      --   pattern = 'AutoSaveEnable',
      --   group = vim.api.nvim_create_augroup('autosave', {}),
      --   callback = function()
      --     vim.notify('AutoSave enabled', vim.log.levels.INFO)
      --   end,
      -- }),
      -- vim.api.nvim_create_autocmd('User', {
      --   pattern = 'AutoSaveDisable',
      --   group = vim.api.nvim_create_augroup('autosave', {}),
      --   callback = function()
      --     vim.notify('AutoSave disabled', vim.log.levels.INFO)
      --   end,
      -- }),
    },
    config = function(_, opts)
      -- Створюємо групу один раз
      local group = vim.api.nvim_create_augroup('autosave', { clear = true })

      -- -- Сторюємо автокоманду для AutoSaveWritePost.
      -- vim.api.nvim_create_autocmd('User', {
      --   pattern = 'AutoSaveWritePost',
      --   group = group,
      --   callback = function()
      --     local buf = vim.fn.bufnr '%' -- vim.api.nvim_get_current_buf()
      --     local filename = vim.api.nvim_buf_get_name(buf)
      --     vim.notify('AutoSave: saved ' .. filename .. ' at ' .. vim.fn.strftime '%H:%M:%S', vim.log.levels.INFO)
      --   end,
      -- })

      -- Створюємо автокоманду для AutoSaveEnable
      vim.api.nvim_create_autocmd('User', {
        pattern = 'AutoSaveEnable',
        group = group,
        callback = function()
          _G.autosave_status = true
          vim.notify('AutoSave enabled', vim.log.levels.INFO)
        end,
      })

      -- Створюємо автокоманду для AutoSaveDisable
      vim.api.nvim_create_autocmd('User', {
        pattern = 'AutoSaveDisable',
        group = group,
        callback = function()
          _G.autosave_status = false
          vim.notify('AutoSave disabled', vim.log.levels.INFO)
        end,
      })

      -- Налаштовуємо сам плагін
      require('auto-save').setup(opts)
    end,
  },
}
