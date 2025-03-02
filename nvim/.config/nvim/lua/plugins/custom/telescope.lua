local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local make_entry = require 'telescope.make_entry'
local conf = require('telescope.config').values
local previewers = require 'telescope.previewers'

local M = {}

function M.live_multigrep(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local finder = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == '' then
        return nil
      end

      local pices = vim.split(prompt, '  ')
      local args = { 'rg' }
      if pices[1] then
        table.insert(args, '-e')
        table.insert(args, pices[1])
      end

      if pices[2] then
        table.insert(args, '-g')
        table.insert(args, pices[2])
      end

      ---@diagnostic disable-next-line: deprecated
      return vim.tbl_flatten {
        args,
        { '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' },
      }
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }
  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = 'Multi Grep',
      file_ignore_patterns = { 'node_modules', '.git/', '.venv/', 'venv/' },
      finder = finder,
      previewer = conf.grep_previewer(opts),
      softer = require('telescope.sorters').empty(),
    })
    :find()
end

function M.table_multigrep(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local finder = finders.new_async_job {
    command_generator = function(prompt)
      local name = 'class '
      local path = 'models.py'
      local pices = vim.split(prompt, '  ')
      if pices[1] then
        name = name .. pices[1]
      end

      if pices[2] then
        path = pices[2] .. '/' .. path
      end

      local args = { 'rg', '-e', name, '-g', path }

      ---@diagnostic disable-next-line: deprecated
      return vim.tbl_flatten {
        args,
        { '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' },
      }
    end,

    entry_maker = function(entry)
      local t = vim.split(entry, ':')

      local filename, lnum, col, ftext = t[1], tonumber(t[2]), tonumber(t[3]), t[4]
      local text_split = vim.split(ftext, ' ')
      local class_split = vim.split(text_split[2], '%(')
      local class_name = class_split[1]

      return {
        value = entry,
        display = class_name,
        ordinal = class_name,
        filename = filename,
        lnum = lnum,
        col = col,
      }
    end,
    cwd = opts.cwd,
  }
  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = 'Models Grep',
      file_ignore_patterns = { 'node_modules', '.git/', '.venv/', 'venv/' },
      finder = finder,
      -- previewer = conf.grep_previewer(opts),
      previewer = previewers.new_buffer_previewer {
        define_preview = function(self, entry, status)
          conf.buffer_previewer_maker(entry.filename, self.state.bufnr, {
            bufname = self.state.bufname,
            callback = function(bufnr)
              -- Встановлюємо текст зверху
              vim.api.nvim_buf_call(bufnr, function()
                vim.fn.cursor(entry.lnum, entry.col)
                vim.cmd [[normal! zz]] -- Центрує рядок, але ми відключимо це
                vim.cmd [[normal! zt]] -- Переміщує рядок на верх
              end)
              local hl_group = 'DiffDelete' -- Можна використати іншу групу
              vim.api.nvim_buf_add_highlight(bufnr, -1, hl_group, entry.lnum - 1, 0, -1)
            end,
          })
        end,
      },
      softer = require('telescope.sorters').empty(),
      layout_config = {
        width = 0.9, -- Ширина всього вікна як частка від розміру екрана (наприклад, 90%)
        height = 0.9, -- Висота вікна (80% від екрану)
        preview_cutoff = 40, -- Вимикати прев'ю для невеликих вікон
        horizontal = {
          preview_width = 0.7, -- Ширина вікна прев'ю (60% від загальної ширини)
        },
        vertical = {
          preview_height = 0.5, -- Висота вікна прев'ю (50% для вертикального розташування)
        },
      },
      layout_strategy = 'horizontal',
    })
    :find()
end

return M
