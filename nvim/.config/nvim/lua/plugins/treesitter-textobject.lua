return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'lewis6991/gitsigns.nvim',
  },

  config = function()
    require('nvim-treesitter').setup {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },

        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']f'] = '@function.outer',
            [']c'] = '@class.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[c'] = '@class.outer',
          },
        },
      },
    }

    -- safe require (IMPORTANT)
    local ok_gs, gs = pcall(require, 'gitsigns')
    if not ok_gs then
      return
    end

    local ok_ts, ts_repeat_move = pcall(require, 'nvim-treesitter.textobjects.repeatable_move')

    if not ok_ts then
      return
    end

    local next_hunk, prev_hunk = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)

    vim.keymap.set({ 'n', 'x', 'o' }, ']h', next_hunk, { desc = 'Next hunk' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[h', prev_hunk, { desc = 'Prev hunk' })
  end,
}
