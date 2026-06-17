local clue = require('mini.clue')

clue.setup({
  triggers = {
    { mode = { 'n', 'x' }, keys = '<Leader>' },
    { mode = 'n',          keys = 'g' },
    { mode = 'n',          keys = 's' },
    { mode = 'n',          keys = '[' },
    { mode = 'n',          keys = ']' },
  },

  clues = {
    { mode = 'n', keys = '<Leader>c',  desc = '+Code' },
    { mode = 'n', keys = '<Leader>d',  desc = '+Debug' },
    { mode = 'n', keys = '<Leader>f',  desc = '+Find' },
    { mode = 'n', keys = '<Leader>g',  desc = '+Git' },
    { mode = 'n', keys = '<Leader>h',  desc = '+Grapple (Harpoon)' },
    { mode = 'n', keys = '<Leader>p',  desc = '+Paste' },
    { mode = 'n', keys = '<Leader>q',  desc = '+QuickFix' },
    { mode = 'n', keys = '<Leader>s',  desc = '+Split' },
    { mode = 'n', keys = '<Leader>u',  desc = '+Uv' },
    { mode = 'n', keys = '<Leader>w',  desc = '+Write' },
    { mode = 'n', keys = '<Leader>ws', desc = '+Sass Autocompiler' },
    { mode = 'n', keys = '<Leader>y',  desc = '+Yank' },
    clue.gen_clues.g(),
    clue.gen_clues.marks(),
    clue.gen_clues.registers(),
    clue.gen_clues.square_brackets(),
  },

  window = {
    delay = 500,
    config = {
      width = 40,
    },
  },

})
