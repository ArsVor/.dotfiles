return {
  'rest-nvim/rest.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-neotest/nvim-nio',
    'manoelcampos/xml2lua',
  },
  ft = 'http',

  config = function()
    require('rest-nvim').setup {
      formatters = {
        json = function(body)
          local success = pcall(vim.fn.json_decode, body)
          if success then
            local handle = io.popen("echo '" .. body .. "' | jq .")
            local result = handle:read '*a'
            handle:close()
            return result
          end
          return body
        end,
      },
    }

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'json' },
      callback = function()
        vim.api.nvim_set_option_value('formatprg', 'jq .', { scope = 'local' })
      end,
    })
  end,
}
