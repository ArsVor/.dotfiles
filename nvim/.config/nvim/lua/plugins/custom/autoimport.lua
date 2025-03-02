local M = {}

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
