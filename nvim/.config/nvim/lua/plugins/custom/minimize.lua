local M = {}

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

return M
