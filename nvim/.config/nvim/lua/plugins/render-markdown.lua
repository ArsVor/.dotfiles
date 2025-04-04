return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    opts = {
      completions = { blink = { enabled = true } },
    },

    config = function()
      require('render-markdown').setup {
        heading = {
          icons = { '󰼏 ', '󰼐 ', '󰼑 ', '󰼒 ', '󰼓 ', '󰼔 ' },
          -- icons = { '󰎦 ', '󰎩 ', '󰎬 ', '󰎮 ', '󰎰 ', '󰎵 ' },
          -- icons = { '󰫃 ', '󰫄 ', '󰫅 ', '󰫆 ', '󰫇 ', '󰫈 ' },
          -- icons = { '󱅊 ', '󱅋 ', '󱅌 ', '󱅍 ', '󱅎 ', '󱅏 ' },
        },
        callout = {
          task = { raw = '[!TASK]', rendered = '󰄱 Task', highlight = 'RenderMarkdownWarn', category = 'custom' },
          ok = { raw = '[!OK]', rendered = '󰄵 Ok', highlight = 'RenderMarkdownHint', category = 'custom' },
        },
      }

      function ToggleCheckbox()
        local line = vim.api.nvim_get_current_line()
        if line:match '%[ %]' then
          line = line:gsub('%[ %]', '[x]', 1) -- Якщо `[ ]`, то міняємо на `[x]`
        elseif line:match '%[x%]' then
          line = line:gsub('%[x%]', '[ ]', 1) -- Якщо `[x]`, то міняємо на `[ ]`
        end
        vim.api.nvim_set_current_line(line)
      end

      function SetCheckboxChecked()
        local line = vim.api.nvim_get_current_line()
        line = line:gsub('%[[ -]%]', '[x]', 1) -- Якщо `[ ]`, то міняємо на `[x]`
        vim.api.nvim_set_current_line(line)
      end

      function SetCheckboxUnchecked()
        local line = vim.api.nvim_get_current_line()
        line = line:gsub('%[[x-]%]', '[ ]', 1) -- Якщо `[ ]`, то міняємо на `[x]`
        vim.api.nvim_set_current_line(line)
      end

      function SetCheckboxInWork()
        local line = vim.api.nvim_get_current_line()
        line = line:gsub('%[[ x]%]', '[-]', 1) -- Якщо `[ ]`, то міняємо на `[x]`
        vim.api.nvim_set_current_line(line)
      end

      function SetCheckboxTask()
        local line = vim.api.nvim_get_current_line()
        line = line:gsub('%[![%a]+%]', '[!TASK]', 1) -- Якщо `[ ]`, то міняємо на `[x]`
        vim.api.nvim_set_current_line(line)
      end

      function SetCheckboxOk()
        local line = vim.api.nvim_get_current_line()
        line = line:gsub('%[![%a]+%]', '[!OK]', 1) -- Якщо `[ ]`, то міняємо на `[x]`
        vim.api.nvim_set_current_line(line)
      end

      function SetCheckboxBug()
        local line = vim.api.nvim_get_current_line()
        line = line:gsub('%[![%a]+%]', '[!BUG]', 1) -- Якщо `[ ]`, то міняємо на `[x]`
        vim.api.nvim_set_current_line(line)
      end

      function SetAllCheckboxChecked()
        local cursor_position = vim.api.nvim_win_get_cursor(0)
        vim.cmd '%s/\\[[ -]\\]/\\[x\\]/g'
        vim.api.nvim_win_set_cursor(0, cursor_position)
      end

      function SetAllCheckboxUnchecked()
        local cursor_position = vim.api.nvim_win_get_cursor(0)
        vim.cmd '%s/\\[[x-]\\]/\\[ \\]/g'
        vim.api.nvim_win_set_cursor(0, cursor_position)
      end

      function SetAllCheckboxInWork()
        local cursor_position = vim.api.nvim_win_get_cursor(0)
        vim.cmd '%s/\\[[x ]\\]/\\[-\\]/g'
        vim.api.nvim_win_set_cursor(0, cursor_position)
      end

      function SetAllCheckboxTask()
        local cursor_position = vim.api.nvim_win_get_cursor(0)
        vim.cmd '%s/\\[!\\(OK\\|BUG\\)\\]/\\[!TASK\\]/g'
        vim.api.nvim_win_set_cursor(0, cursor_position)
      end

      function SetAllCheckboxOk()
        local cursor_position = vim.api.nvim_win_get_cursor(0)
        vim.cmd '%s/\\[!\\(TASK\\|BUG\\)\\]/\\[!OK\\]/g'
        vim.api.nvim_win_set_cursor(0, cursor_position)
      end

      function SetLine(marker)
        local line = vim.api.nvim_get_current_line()
        local trimmed = line:match '^%s*(.-)%s*$' -- Обрізаємо пробіли з початку і кінця
        local first_char = trimmed:sub(1, 1) -- Отримуємо перший символ
        local pref
        if first_char == '-' then
          pref = first_char
        else
          local before_dot = trimmed:match '^[^.]+'
          local last_num = tonumber(before_dot)
          last_num = last_num + 1
          pref = tostring(last_num) .. '.'
        end
        local to_send = 'o' .. pref .. ' [' .. marker .. '] <Esc>'
        local keys = vim.api.nvim_replace_termcodes(to_send, true, false, true)
        vim.api.nvim_feedkeys(keys, 'n', false)
      end

      function AddTask()
        SetLine '!TASK'
      end

      vim.keymap.set('n', '<leader>mt', ToggleCheckbox, { desc = '[T]oggle [M]arkdown Checkbox' })
      vim.keymap.set('n', '<leader>mc', SetCheckboxChecked, { desc = 'Set [M]arkdown Checkbox [C]hecked' })
      vim.keymap.set('n', '<leader>mC', SetAllCheckboxChecked, { desc = 'Set All [M]arkdown Checkbox [C]hecked' })
      vim.keymap.set('n', '<leader>mu', SetCheckboxUnchecked, { desc = 'Set [M]arkdown Checkbox [U]nchecked' })
      vim.keymap.set('n', '<leader>mU', SetAllCheckboxUnchecked, { desc = 'Set All [M]arkdown Checkbox [U]nchecked' })
      vim.keymap.set('n', '<leader>mw', SetCheckboxInWork, { desc = 'Set [M]arkdown Checkbox In [W]orck' })
      vim.keymap.set('n', '<leader>mW', SetAllCheckboxInWork, { desc = 'Set All [M]arkdown Checkbox In [W]orck' })
      vim.keymap.set('n', '<leader>mk', SetCheckboxTask, { desc = 'Set [M]arkdown Checkbox to Tas[K]' })
      vim.keymap.set('n', '<leader>mK', SetAllCheckboxTask, { desc = 'Set All [M]arkdown Checkbox to Tas[K]' })
      vim.keymap.set('n', '<leader>mo', SetCheckboxOk, { desc = 'Set [M]arkdown Checkbox [O]k' })
      vim.keymap.set('n', '<leader>mO', SetAllCheckboxOk, { desc = 'Set All [M]arkdown Checkbox [O]k' })
      vim.keymap.set('n', '<leader>mb', SetCheckboxBug, { desc = 'Set [M]arkdown Checkbox [B]ug' })
      vim.keymap.set('n', '<leader>mat', AddTask, { desc = '[M]arkdown [A]dd [T]ask' })
    end,
  },
}
