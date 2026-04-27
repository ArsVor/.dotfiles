local M = {}

function M.get_visual_selection()
    local region = vim.fn.getregionpos(vim.fn.getpos('v'), vim.fn.getpos('.'), {
        type = 'v',
        exclusive = false,
        eol = false,
    })
    local s = region[1][1]
    local e = region[#region][2]

    local buf = 0

    local lines = vim.api.nvim_buf_get_text(
        buf,
        s[2] - 1,
        s[3] - 1,
        e[2] - 1,
        e[3],
        {}
    )

    return lines[1]
end


function M.is_splited()
  local normal_window_count = 0
  for _, window_handle in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(window_handle).relative == '' then
      normal_window_count = normal_window_count + 1
    end
  end
  return normal_window_count > 1
end


function M.minimize_current_split()
  if not M.is_splited() then
    vim.notify('Already one window', 'WARN', { title = 'WARNING', hide_from_history = true })
    return
  end

  local total_width = vim.o.columns -- Загальна ширина робочої області
  local win_width = vim.api.nvim_win_get_width(0) -- Ширина поточного вікна

  if win_width == total_width then
    -- Горизонтальний спліт
    vim.cmd 'res 2'
  else
    -- Вертикальний спліт
    vim.cmd 'vert res 10'
  end
end


function M.show_auto_imports()
  local current_word = vim.fn.expand '<cword>' -- Отримуємо слово під курсором
  local params = vim.lsp.util.make_position_params()

  vim.lsp.buf_request(0, 'textDocument/completion', params, function(err, result, ctx, _)
    if err or not result then
      return
    end

    local items = result.items or result
    local imports = {}
    local num = 0

    for _, item in ipairs(items) do
      -- Фільтруємо варіанти, залишаючи тільки ті, що містять "auto-import"
      if item.label == current_word and item.detail and item.detail:match 'Auto%-import' then
        num = num + 1
        local cleanedImport = item.data.autoImportText:match '```%s*(.-)%s*```' or item.data.autoImportText
        table.insert(imports, {
          label = num .. ' ' .. cleanedImport, -- Відображається у вікні вибору
          import_text = cleanedImport, -- Текст для імпорту
        })
      end
    end

    if #imports == 0 then
      return
    end

    -- Відображаємо меню вибору через vim.ui.select
    vim.ui.select(imports, {
      prompt = 'Choose import',
      format_item = function(item)
        return item.label
      end,
    }, function(choice)
      if not choice then
        return
      end
      -- Додаємо імпорт у початок файлу
      vim.api.nvim_buf_set_lines(0, 0, 0, false, { choice.import_text })
      -- Виконуємо Ruff Organize Imports
      --
      vim.lsp.buf.code_action {
        context = { only = { 'source.organizeImports.ruff' } },
        apply = true,
      }
    end)
  end)
end

return M
