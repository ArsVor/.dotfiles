local pick = require('mini.pick')

pick.setup({
  mappings = {
    toggle_info      = '<S-Tab>',
    toggle_preview   = '<Tab>',
    choose           = '<CR>',
    choose_in_split  = '<C-s>',
    choose_in_vsplit = '<C-v>',
    choose_marked    = '<C-q>',
    caret_left       = '<C-h>',
    caret_right      = '<C-l>',
    move_down        = '<C-j>',
    move_up          = '<C-k>',
    scroll_down      = '<C-n>',
    scroll_left      = '<C-b>',
    scroll_right     = '<C-f>',
    scroll_up        = '<C-p>',
    mark             = '<M-x>',
    mark_all         = '<C-a>',
    refine           = '<C-Space>',
    paste            = '<C-r>',
    mark_and_go_next = {
      char = '<C-x>',
      func = function()
        local ctrl_x = vim.api.nvim_replace_termcodes('<M-x>', true, true, true)
        vim.api.nvim_feedkeys(ctrl_x, 'm', true)

        local down = vim.api.nvim_replace_termcodes('<C-j>', true, true, true)
        vim.api.nvim_feedkeys(down, 'm', true)
      end,
    },
  },
})
