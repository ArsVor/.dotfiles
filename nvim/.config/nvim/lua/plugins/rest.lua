return {
  'rest-nvim/rest.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, 'http')
    end,
  },
  config = function()
    -- Налаштування rest.nvim
    require('rest-nvim').setup {
      formatters = {
        json = function(body)
          local success, decoded = pcall(vim.fn.json_decode, body)
          if success then
            -- Використовуємо jq для форматування JSON
            local handle = io.popen("echo '" .. body .. "' | jq .")
            local result = handle:read '*a'
            handle:close()
            return result
          end
          -- Якщо JSON некоректний, повертаємо його як є
          return body
        end,
      },
    }

    -- Додати автокоманду для використання jq як форматувальника JSON
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'json' }, -- Автокоманда для JSON-файлів
      callback = function()
        vim.api.nvim_set_option_value('formatprg', 'jq .', { scope = 'local' })
      end,
    })
  end,
}
