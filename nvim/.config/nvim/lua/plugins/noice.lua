return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    -- add any options here
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    -- 'rcarriga/nvim-notify',
  },
  config = function()
    require('noice').setup {
      -- messages = {
      --   enabled = false,
      -- },
      lsp = {
        progress = {
          enabled = true,
          format = 'lsp_progress', -- збережіть формат
          format_done = 'lsp_progress_done', -- збережіть формат завершення
          throttle = 1000 / 30,
          view = 'mini',
        },
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = false,
          ['vim.lsp.util.stylize_markdown'] = false,
          ['cmp.entry.get_documentation'] = false,
        },
        hover = {
          enabled = false, -- вимкнути підказки (hover)
          silent = false,
          view = nil,
          opts = {},
        },
        signature = {
          enabled = false, -- Вимкнути підказки підпису
          auto_open = {
            enabled = false, -- Вимкнути автоматичне відкриття підпису
          },
          view = nil,
          opts = {},
        },
        message = {
          enabled = false,
          view = 'mini',
          opts = {},
        },
        notify = {
          enabled = false,
        },
        documentation = {
          view = 'hover',
          opts = {
            lang = 'markdown',
            replace = true,
            render = 'plain',
            format = { '{message}' },
            win_options = { concealcursor = 'n', conceallevel = 3 },
          },
        },
      },
      views = {
        cmdline_popup = {
          position = {
            row = 5,
            col = '50%',
          },
          size = {
            width = 60,
            height = 'auto',
          },
          icon = '',
        },
        popupmenu = {
          relative = 'editor',
          position = {
            row = 8,
            col = '50%',
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = 'rounded',
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { Normal = 'Normal', FloatBorder = 'DiagnosticInfo' },
          },
        },
      },
    }
  end,
}
