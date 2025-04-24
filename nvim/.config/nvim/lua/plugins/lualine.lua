return {
  'nvim-lualine/lualine.nvim',
  config = function()
    local mode = {
      'mode',
      fmt = function(str)
        return ' ' .. str
        -- return ' ' .. str:sub(1, 1) -- displays only the first character of the mode
      end,
    }

    local filename = {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 4, -- 0 = just filename, 1 = relative path, 2 = absolute path, 4 = filename with parent
    }

    local hide_in_width = function()
      return vim.fn.winwidth(0) > 100
    end

    local theme = require('lualine.utils.loader').load_theme 'auto' -- Автоматично завантажує активну тему
    local normal_a = theme.normal.a
    local visual_a = theme.visual.a

    local autosave_current_status_color = function()
      if _G.autosave_status then
        return normal_a
      else
        return visual_a
      end
    end

    local autosave_current_status = function()
      if _G.autosave_status then
        return [[AS]]
      else
        return [[MS]]
      end
    end

    local diagnostics = {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      sections = { 'error', 'warn' },
      symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
      colored = false,
      update_in_insert = false,
      always_visible = false,
      cond = hide_in_width,
    }

    local diff = {
      'diff',
      colored = false,
      symbols = { added = ' ', modified = ' ', removed = ' ' }, -- changes diff symbols
      cond = hide_in_width,
    }

    local permissions = function()
      local filetype = vim.bo.filetype
      local exec_types = { 'sh', 'zsh', 'bash', 'fish' }
      for _, ftype in pairs(exec_types) do
        if ftype == filetype then
          local filepath = vim.fn.expand '%:p'
          local handle = io.popen('ls -l ' .. vim.fn.shellescape(filepath) .. " | awk '{print $1}'")
          if handle ~= nil then
            local permission = handle:read('*a'):gsub('%s+', '') -- Видаляємо зайві пробіли/нові рядки
            handle:close()
            return permission
          end
        end
      end
    end

    local show_permissions = function()
      return vim.fn.winwidth(0) > 100 and permissions() ~= nil
    end

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'auto', -- Set theme based on environment variable
        -- Some useful glyphs:
        -- https://www.nerdfonts.com/cheat-sheet
        --        
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = { 'alpha', 'neo-tree' },
        always_divide_middle = true,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        },
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { 'branch' },
        lualine_c = { filename },
        lualine_x = {
          diagnostics,
          diff,
          { 'encoding', cond = hide_in_width },
          { permissions, cond = show_permissions },
          { 'filetype', cond = hide_in_width },
        },
        lualine_y = { 'location' },
        lualine_z = { { autosave_current_status, color = autosave_current_status_color } },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { { 'location', padding = 0 } },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { 'fugitive' },
    }
  end,
}
