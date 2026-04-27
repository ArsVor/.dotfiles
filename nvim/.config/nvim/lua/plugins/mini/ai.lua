local ai = require('mini.ai')

ai.setup({
  mappings = {
    -- Main textobject prefixes
    around = 'a',
    inside = 'i',

    -- Next/last variants
    -- NOTE: These override built-in LSP selection mappings on Neovim>=0.12
    -- Map LSP selection manually to use it (see `:h MiniAi.config`)
    around_next = 'al',
    inside_next = 'il',
    around_last = 'ah',
    inside_last = 'ih',

    -- Move cursor to corresponding edge of `a` textobject
    goto_left = 'g[',
    goto_right = 'g]',
  },
  n_lines = 500,
  search_method = 'next',
  silent = false,
})
